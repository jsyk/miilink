library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

--
-- Transmitting FSM for 100Mbit FastEthernet, with integrated
-- buffer control.
--
entity txlink_fsm is
generic (
    MEM_ADDR_W : natural := 9;          -- buffer address width
    IGAP_LEN : natural := 6;            -- inter-frame gap in bytes
    FRTAG_W : natural := 0              -- nr of bits for frame tag that is moved between fifos
);
port (
    clk         : in std_logic;
    rst         : in std_logic;
    -- 
    -- TX byte stream to RMII
    t_dv        : out std_logic;        -- kept high so long as we are transmitting a frame
    t_str_dt    : out std_logic;        -- a pulse when t_dt is valid
    t_dt        : out std_logic_vector(7 downto 0);      -- 1-byte transmit data, valid only during t_str_dt is active
    -- 
    -- push-frame fifo
    pf_empty    : in std_logic;             -- indicates no frame to send
    pf_tag_len_ptr : in std_logic_vector(FRTAG_W+2*MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    pf_deq      : out std_logic;            -- dequeu the frame when we're done
    --
    -- remove-frame output
    rf_strobe   : out std_logic;
    rf_tag_len_ptr    : out std_logic_vector(FRTAG_W+2*MEM_ADDR_W-1 downto 0);
    --
    -- memory interface, 2T read latency
    m_rstrobe   : out std_logic;
    m_addr      : out std_logic_vector(MEM_ADDR_W-1 downto 0);
    m_rdt       : in std_logic_vector(31 downto 0)
) ;
end entity ; -- txlink_fsm

architecture rtl of txlink_fsm is

    subtype count_t is integer range 0 to 15;
    subtype mii_count_t is integer range 0 to 3;
    subtype wordpointer_t is unsigned(MEM_ADDR_W-1 downto 0);       -- wrapping

    type state_t is (IDLE, TXPREAMBLE, TXSFD_D5, TXDATA, TXFCS, IGAP);

    type registers_t is record
        state : state_t;        -- top-level state of the FSM
        cnt : count_t;          -- sub-state
        rptr : wordpointer_t;       -- read pointer, in words
        frlen : wordpointer_t;      -- remaining frame length, in words 
        fr_done : std_logic;        -- frame done -> remove from fifos

        mii_strobe : std_logic;     -- RMII byte strobe (internal)
        mii_cnt : mii_count_t;      -- counter for RMII strobe generator
        --
        t_dv        : std_logic;        -- kept high so long as we are transmitting a frame
        t_str_dt    : std_logic;        -- a pulse when t_dt is valid
        t_dt        : std_logic_vector(7 downto 0);      -- 1-byte transmit data, valid only during t_str_dt is active
        --
        m_rstrobe   : std_logic;        -- memory read strobe
        --
        crc_init    : std_logic;        -- init/reset the CRC generator
        crc_calc    : std_logic;        -- calculate (1) or generate (0) crc value
    end record;

    
    signal r, rin : registers_t;
    signal crc_byte : std_logic_vector(7 downto 0);

begin
    fcs_checker: crc
    port map (
        clk, rst,
        r.t_dt, r.crc_init, r.crc_calc, r.t_str_dt,
        crc_byte, open, open
    );

    comb: process (r, rst, pf_empty, pf_tag_len_ptr, m_rdt, crc_byte)
    variable v : registers_t;
    begin
        v := r;
        v.t_dv := '0';
        v.t_str_dt := '0';
        v.m_rstrobe := '0';
        v.crc_init := '0';
        v.crc_calc := '0';
        v.fr_done := '0';

        case v.state is
            when IDLE =>
                -- wait until tx frame is ready in buffer
                v.crc_init := '1';

                if pf_empty = '0' then
                    -- push-fifo is not empty; next data is at pf_tag_len_ptr: (tag,len,ptr)
                    v.rptr := unsigned(pf_tag_len_ptr(MEM_ADDR_W-1 downto 0));
                    v.frlen := unsigned(pf_tag_len_ptr(2*MEM_ADDR_W-1 downto MEM_ADDR_W));
                    v.state := TXPREAMBLE;
                    v.cnt := 0;
                    v.t_dv := '1';
                    v.t_dt := x"55";
                    v.t_str_dt := '1';
                    v.mii_cnt := 0;             -- restart MII counter
                end if;

            when TXPREAMBLE =>
                -- send 7x 0x55
                v.t_dv := '1';
                if v.mii_strobe = '1' then
                    v.t_dt := x"55";
                    v.t_str_dt := '1';
                    if v.cnt = 5 then
                        -- at this tick sending the last 0x55
                        v.state := TXSFD_D5;
                    else
                        v.cnt := v.cnt + 1;
                    end if;
                end if;

            when TXSFD_D5 =>
                -- send the 0xD5 code - SFD
                v.t_dv := '1';
                if v.mii_strobe = '1' then
                    -- sending 0xD5
                    v.t_dt := x"D5";
                    v.t_str_dt := '1';
                    v.state := TXDATA;
                    v.cnt := 0;
                end if;

            when TXDATA =>
                v.t_dv := '1';
                v.crc_calc := '1';

                if v.mii_strobe = '1' then
                    -- send data (that we got from a buffer)
                    if v.cnt = 0 then
                        v.t_dt := m_rdt(7 downto 0);
                        v.cnt := 1;
                    elsif v.cnt = 1 then
                        v.t_dt := m_rdt(15 downto 8);
                        v.cnt := 2;
                    elsif v.cnt = 2 then
                        v.t_dt := m_rdt(23 downto 16);
                        v.cnt := 3;
                    else
                        v.t_dt := m_rdt(31 downto 24);
                        -- the last byte of the current word is being sent.
                        -- inc read word pointer
                        v.rptr := v.rptr + 1;
                        -- decrement remaining words counter
                        v.frlen := v.frlen - 1;
                        -- next time start at lowest byte again
                        v.cnt := 0;
                    end if;
                    -- strobe output byte
                    v.t_str_dt := '1';
                else
                    -- request data from the memory
                    v.m_rstrobe := '1';
                    -- is there more words in the buffer?
                    if v.frlen = 0 then
                        -- no, start sending CRC code
                        v.state := TXFCS;
                        v.cnt := 0;
                        v.crc_calc := '0';
                        -- dequeue frame from input fifo and push
                        -- the frame len to the output fifo
                        v.fr_done := '1';
                    end if;
                end if;

            when TXFCS =>
                -- transmitting the 4-byte CRC code
                v.t_dv := '1';
                if v.mii_strobe = '1' then
                    -- copy output from CRC module to out
                    v.t_dt := crc_byte;
                    -- strobe out, also strobe the CRC byte
                    v.t_str_dt := '1';

                    -- finished?
                    if v.cnt = 3 then
                        -- yes, go to idle state.
                        v.state := IGAP;
                        v.cnt := IGAP_LEN - 1;
                    else
                        v.cnt := v.cnt + 1;
                    end if;
                end if;

            when IGAP =>
                -- insert inter-frame gap after each frame
                if v.mii_strobe = '1' then
                    if v.cnt = 0 then
                        -- end of inter-frame gap
                        v.state := IDLE;
                    else
                        -- continuing inter-frame gap
                        v.cnt := v.cnt - 1;
                    end if;
                end if;
        end case;

        -- RMII byte-strobe generator.
        -- Free running, but it is reset/resync when a new frame starts
        -- (when leaving IDLE).
        if v.mii_cnt = 3 then
            v.mii_cnt := 0;
            v.mii_strobe := '1';
        else
            v.mii_cnt := v.mii_cnt + 1;
            v.mii_strobe := '0';
        end if;

        if rst = '1' then
            v.state := IDLE;
            v.cnt := 0;
            v.rptr := (others => '0');
            v.frlen := (others => '0');
            v.mii_strobe := '0';
            v.mii_cnt := 0;
            v.m_rstrobe := '0';
        end if;

        rin <= v;
    end process;

    ff: process (clk)
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;

    t_dv        <= r.t_dv;
    t_str_dt    <= r.t_str_dt;
    t_dt        <= r.t_dt;

    pf_deq      <= r.fr_done;
    rf_strobe   <= r.fr_done;
    rf_tag_len_ptr <= pf_tag_len_ptr;
    
    -- memory interface, 2T read latency
    m_rstrobe   <= r.m_rstrobe;
    m_addr      <= std_logic_vector(r.rptr);

end architecture ; -- rtl
