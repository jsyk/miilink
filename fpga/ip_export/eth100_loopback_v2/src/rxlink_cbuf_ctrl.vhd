library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 
-- Controller of a circular buffer.
-- Receives frame bytes from RX-FSM and stores them in buffer.
-- Buffer is organized as a circle. Keeps track which part is used and which is allocated.
-- When frame is finished pushes frame length to a FIFO for protocol machine.
-- 
entity rxlink_cbuf_ctrl is
generic (
    MEM_ADDR_W : natural := 9           -- buffer address width
);
port (
    clk         : in std_logic;
    rst         : in std_logic;
    -- 
    -- interface to rxlink FSM
    b_restart   : in std_logic;        -- open new buffer
    b_enq       : in std_logic;        -- enqueu byte to buffer
    b_dt        : in std_logic_vector(7 downto 0);     -- data to enqueue
    b_commit    : in std_logic;        -- commit buffer
    b_overflowed : out std_logic;      -- buffer enque has caused overflow (must cancel buffer and discard frame)
    -- 
    -- to buffer memory
    m_addr      : out std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m_wdt       : out std_logic_vector(31 downto 0);            -- buffer write data 
    m_wstrobe   : out std_logic;                                -- strobe to write data into the buffer
    -- 
    -- to push-fifo queue
    pf_enq      : out std_logic;                        -- enqueue to the push-fifo
    pf_frlen    : out std_logic_vector(MEM_ADDR_W-1 downto 0);     -- data to enqueue: received frame length
    pf_full     : in std_logic;                         -- feedback that push-fifo is full and cannot accept input
    -- 
    -- remove processed frames from the buffer
    rf_strobe   : in std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    rf_frlen    : in std_logic_vector(MEM_ADDR_W-1 downto 0)      -- remove length
) ;
end entity ; -- rxlink_cbuf_ctrl

architecture rtl of rxlink_cbuf_ctrl is

    subtype wordpointer_t is unsigned(MEM_ADDR_W-1 downto 0);       -- wrapping
    
    subtype bytepointer_t is integer range 0 to 3;

    type registers_t is record
        bottom : wordpointer_t;         -- bottom of the used buffer space
        top : wordpointer_t;            -- top of the used buffer space
        wptr : wordpointer_t;           -- current write pointer
        subptr : bytepointer_t;         -- current write sub-pointer - byte in a word
        frlength : wordpointer_t;       -- total frame length in words
        wptr_at_end : std_logic;        -- flag: write pointer is at end mark
    
        b_overflowed : std_logic;         -- buffer enque has caused overflow (must cancel buffer and discard frame)
        m_wdt       : std_logic_vector(31 downto 0);    -- write data
        m_wstrobe   : std_logic;                        -- write strobe
        pf_enq      : std_logic;                        -- 
    end record;

    signal r, rin : registers_t;

begin

    comb: process (r, rst, b_restart, b_enq, b_dt, b_commit, pf_full, rf_frlen, rf_strobe)
    variable v : registers_t;
    begin
        v := r;
        v.pf_enq := '0';
        -- v.pf_frlen := (others => '0');
        -- v.rf_deq := '0';

        if v.m_wstrobe = '1' then
            -- post-increment address after strobe finished
            v.wptr := v.wptr + 1;
        end if;

        -- clear buf write strobe by default
        v.m_wstrobe := '0';

        if (b_commit='1') and (v.b_overflowed='0') then
            -- commit buffer: move the top pointer an
            if pf_full='0' then
                v.top := v.wptr;
                v.pf_enq := '1';
            else
                -- overflowing due to full push-fifo, do not move the top -> frame will be discarded
                v.b_overflowed := '1';
            end if;
        elsif (b_restart='1') then
            -- starting new frame or cancelling existing one -> reset pointers
            v.wptr := v.top;
            v.subptr := 0;
            v.frlength := (others => '0');
            v.b_overflowed := '0';
        elsif (b_enq='1') and (v.b_overflowed='0') then
            -- enqueue byte to the buffer, only if not already overflowing
            v.m_wdt := b_dt & v.m_wdt(31 downto 8);
            -- full 32b word filled?
            if v.subptr = 3 then
                -- yes, write the word to the memory
                v.m_wstrobe := '1';
                v.subptr := 0;
                v.frlength := v.frlength + 1;
            else
                -- no
                v.subptr := v.subptr + 1;
            end if;
        end if;

        -- check for overflow
        if (v.wptr_at_end='1') and (v.m_wstrobe='1') then
            -- overflow!
            v.m_wstrobe := '0';         -- cancel write attempt
            v.b_overflowed := '1';      -- set flag (persistent until b_restart)
        end if;

        -- calculate if wptr is at the end
        if v.wptr + 1 = v.bottom then
            -- incrementing wptr would overflow buffer -> we're at the end
            v.wptr_at_end := '1';
        else
            -- free space in buffer
            v.wptr_at_end := '0';
        end if;


        -- dequeue info that a frame has been processed
        if rf_strobe='1' then
            v.bottom := v.bottom + to_integer(unsigned(rf_frlen));
        end if;

        if rst='1' then
            v.bottom := (others => '0');
            v.top := (others => '0');
            v.wptr := (others => '0');
            v.frlength := (others => '0');
            v.subptr := 0;
            v.b_overflowed := '0';
        end if;

        rin <= v;
    end process;

    ff: process (clk)
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;

    b_overflowed <= r.b_overflowed;
    m_addr      <= std_logic_vector(r.wptr);
    m_wdt       <= r.m_wdt;
    m_wstrobe   <= r.m_wstrobe;
    pf_enq      <= r.pf_enq;
    pf_frlen    <= std_logic_vector(r.frlength);

end architecture ; -- rtl
