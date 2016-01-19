library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

-- 
-- FastEthernet output TX LINK path.
-- Dual-clock core.
-- 
entity eth100_link_tx is
generic (
    FRBUF_MEM_ADDR_W : natural := 9;
    IGAP_LEN : natural := 6;	            -- inter-frame gap in bytes
    M1_SUPPORT_READ : boolean := true;     	-- whether port 2 is read-write (when true) or read-only (when false)
    M1_DELAY : natural := 2;         		-- read delay: 2=insert register at inputs
    TXFIFO_DEPTH_W    : natural := 4;      	-- fifo depth is 2**FIFO_DEPTH_W elements
    FRTAG_W : natural := 0                  -- nr of bits for frame tag that is moved between fifos
);
port (
    -- RMII
    ref_clk     : in std_logic;         -- RMII ref_clk
    rmii_txen   : out std_logic;
    rmii_txdt   : out std_logic_vector(1 downto 0);
    --
    clk         : in std_logic;
    rst         : in std_logic;
    -- access to frame buffer memory
    m1_addr     : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m1_wdt      : in std_logic_vector(31 downto 0);            -- buffer write data 
    m1_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m1_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m1_rdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    --
    -- for removing processed (sent) frames by the tx-link
    rf_strobe   : out std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    rf_tag_len_ptr    : out std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
    -- to push-fifo queue of frames to transmit
    pf_enq      : in std_logic;                                     -- enqueue data command
    pf_tag_len_ptr : in std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    pf_full     : out std_logic;                                   -- full fifo indication (must not enqueue more)
    -- status info
    info_tx_frames : out std_logic_vector(31 downto 0);             -- number of sent frames
    info_tx_bytes : out std_logic_vector(31 downto 0)               -- number of sent bytes (incl. preamble bytes)
) ;
end entity ; -- eth100_link_tx

architecture rtl of eth100_link_tx is

    -- reset in rmii_clk domain
    signal rmii_rst, rmii_rst_1 : std_logic;

    -- internal byte stream from rmii
    signal t_dv        : std_logic;        -- kept high so long as we are sending a frame
    signal t_str_dt    : std_logic;        -- a pulse when t_dt is valid
    signal t_dt        : std_logic_vector(7 downto 0);      -- 1-byte transmit data, valid only during t_str_dt is active

    -- from frame buffer controller to the buffer
    signal m2_addr      : std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal m2_rdt       : std_logic_vector(31 downto 0);            -- buffer write data 
    signal m2_rstrobe   : std_logic;                                -- strobe to write data into the buffer

        -- to push-fifo queue
    signal pf1_deq      : std_logic;                        -- enqueue to the push-fifo
    signal pf1_tag_len_ptr    : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);     -- data to enqueue: received frame length
    signal pf1_empty    : std_logic;                         -- feedback that push-fifo is full and cannot accept input

        -- to remove-fifo queue
    signal rf1_strobe   : std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rf1_tag_len_ptr    : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- dequeued data
    signal rf1_strobe_tmp1, rf1_strobe_tmp2 : std_logic;

        -- to push-fifo queue, in the clk domain
    signal pf2_deq      : std_logic;                        -- enqueue to the push-fifo
    signal pf2_tag_len_ptr    : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);     -- data to enqueue: received frame length
    signal pf2_empty     : std_logic;                         -- feedback that push-fifo is full and cannot accept input
    signal pf2_deq_tmp1, pf2_deq_tmp2 : std_logic;

    -- status info registers, in the ref_clk domain
    signal info2_tx_frames : unsigned(31 downto 0);
    signal info2_tx_bytes : unsigned(31 downto 0);
    signal prev_t_dv : std_logic;

begin
	bs2rmii: bytestream_to_rmii
    port map (
        ref_clk,    --  : in std_logic;         -- RMII ref_clk
        rmii_rst,   ---       : in std_logic;
        -- RMII
        rmii_txen,   --     : out std_logic;
        rmii_txdt,   --     : out std_logic_vector(1 downto 0);
        -- internal byte stream
        t_dv,    --    : in std_logic;        -- kept high so long as we are transmitting a frame
        t_str_dt,  --  : in std_logic;        -- a pulse when t_dt is valid
        t_dt      --  : in std_logic_vector(7 downto 0)      -- 1-byte send data, valid only during r_str_dt is active
    );

    txlnkfsm: txlink_fsm
    generic map (
        FRBUF_MEM_ADDR_W,   -- : natural := 9;           -- buffer address width
        IGAP_LEN,       -- : natural := 6            -- inter-frame gap in bytes
        FRTAG_W
    )
    port map (
        ref_clk,   --      : in std_logic;
        rmii_rst,   --      : in std_logic;
        -- 
        -- TX byte stream to RMII
        t_dv,     --   : out std_logic;        -- kept high so long as we are transmitting a frame
        t_str_dt,  --  : out std_logic;        -- a pulse when t_dt is valid
        t_dt,      --  : out std_logic_vector(7 downto 0);      -- 1-byte transmit data, valid only during t_str_dt is active
        -- 
        -- push-frame fifo
        pf1_empty,  --  : in std_logic;
        pf1_tag_len_ptr,
        pf1_deq,    --  : out std_logic;
        --
        -- remove-frame output
        rf1_strobe,  -- : out std_logic;
        rf1_tag_len_ptr,
        --
        -- memory interface, 2T read latency
        m2_rstrobe,  -- : out std_logic;
        m2_addr,    --  : out std_logic_vector(MEM_ADDR_W-1 downto 0);
        m2_rdt      -- : in std_logic_vector(31 downto 0)
    ) ;

    fbuf: dp_dclk_ram_2rdwr
    generic map (
        FRBUF_MEM_ADDR_W, -- : natural := 9;           -- buffer address width
        32,             -- MEM_DATA_W : natural := 32;          -- buffer data width
        M1_SUPPORT_READ,  -- : boolean := true;     -- whether port 1 is read-write (when true) or write-only (when false)
        M1_DELAY,       -- : natural := 2;         -- read/write delay on P1: 2=insert register at inputs
        false,      -- M2_SUPPORT_WRITE : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
        2           -- M2_DELAY : natural := 2         -- read/write delay on P2: 2=insert register at inputs
    )
    port map (
        -- Port 1: read/write
        clk,     --   : in std_logic;
        m1_addr,  --   : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m1_wdt,   --   : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
        m1_wstrobe,  --: in std_logic;                                -- strobe to write data into the buffer
        m1_rstrobe,  --: in std_logic;                                 -- strobe to read data
        m1_rdt,    --  : out std_logic_vector(MEM_DATA_W-1 downto 0);      -- buffer read data 
        -- Port 2: read/write
        ref_clk,    --    : in std_logic;
        m2_addr,   --  : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        X"00000000",  -- m2_wdt      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
        '0',        -- m2_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
        m2_rstrobe,  -- : in std_logic;                                -- strobe to write data into the buffer
        m2_rdt      -- : out std_logic_vector(MEM_DATA_W-1 downto 0)            -- buffer write data 
    ) ;


    -- FIFO queue holding lengths of frames for transmission
    pfqueue: fifo_queue
    generic map (
        FRTAG_W+2*FRBUF_MEM_ADDR_W, --     : natural;             -- width of data held in the fifo
        TXFIFO_DEPTH_W    --: natural                 -- fifo depth is 2**FIFO_DEPTH_W elements
    )
    port map (
        clk,        --     : in std_logic;
        rst,        --     : in std_logic;
        --
        pf_enq,     --  : in std_logic;                                     -- enqueue data command
        pf_tag_len_ptr,   --    : in std_logic_vector(FIFO_DATA_W-1 downto 0);      -- data to enqueue
        pf2_deq,    --  : in std_logic;                                     -- dequeue data command
        pf2_tag_len_ptr,  --    : out std_logic_vector(FIFO_DATA_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
        pf_full,    --   : out std_logic;                                    -- full fifo indication (must not enqueue more)
        pf2_empty,  --  : out std_logic;                                    -- empty fifo indication (must not dequeue more)
        open        --fifo_level  : out std_logic_vector(FIFO_DEPTH_W downto 0)       -- actual fill level
    ) ;


    -- clock crossing from pf2_*(clk) to pf1_*(ref_clk)
    pf_21: process (ref_clk)
    begin
        if rising_edge(ref_clk) then
            pf1_empty <= pf2_empty;
            pf1_tag_len_ptr <= pf2_tag_len_ptr;
        end if;
    end process;

    -- clock crossing ref_clk->clk for (pf1_deq) -> (pf2_deq)
    pfdeq_dclk: dclk_transport
    generic map (1)
    port map (
        ref_clk,    --    : in std_logic;
        rmii_rst,   --    : in std_logic;
        pf1_deq,    -- : in std_logic;
        "0",        --   : in std_logic_vector(DWIDTH-1 downto 0);
        ---
        clk,        --: in std_logic;
        pf2_deq,    -- : out std_logic;
        open        -- : out std_logic_vector(DWIDTH-1 downto 0)
    ) ;

    -- clock crossing ref_clk->clk for (rf1_strobe, rf1_frlen) -> (rf_strobe, rf_frlen)
    rf_dclk: dclk_transport
    generic map (FRTAG_W+2*FRBUF_MEM_ADDR_W)
    port map (
        ref_clk, --    : in std_logic;
        rmii_rst, --    : in std_logic;
        rf1_strobe, -- : in std_logic;
        rf1_tag_len_ptr,  --   : in std_logic_vector(DWIDTH-1 downto 0);
        ---
        clk,    --: in std_logic;
        rf_strobe,  -- : out std_logic;
        rf_tag_len_ptr    -- : out std_logic_vector(DWIDTH-1 downto 0)
    ) ;


    -- carry reset from clk to ref_clk
    ff_rmii_clk: process (ref_clk)
    begin
        if rising_edge(ref_clk) then
            rmii_rst_1 <= rst;
            rmii_rst <= rmii_rst_1;
        end if;
    end process;

    -- count bytes and frames sent
    infocnt: process (ref_clk)
    begin
        if rising_edge(ref_clk) then
            if rmii_rst='1' then
                info2_tx_bytes <= (others => '0');
                info2_tx_frames <= (others => '0');
                prev_t_dv <= '0';
            else
                if t_str_dt='1' then
                    -- transmitting a byte
                    info2_tx_bytes <= info2_tx_bytes + 1;
                end if;
                if (t_dv='1') and (prev_t_dv='0') then
                    -- start of frame transmit
                    info2_tx_frames <= info2_tx_frames + 1;
                end if;
                prev_t_dv <= t_dv;
            end if;
        end if;
    end process;

    -- carry info counters to clk domain
    infocnt_clk: process (clk)
    begin
        if rising_edge(clk) then
            info_tx_bytes <= std_logic_vector(info2_tx_bytes);
            info_tx_frames <= std_logic_vector(info2_tx_frames);
        end if;
    end process;

end architecture rtl;
