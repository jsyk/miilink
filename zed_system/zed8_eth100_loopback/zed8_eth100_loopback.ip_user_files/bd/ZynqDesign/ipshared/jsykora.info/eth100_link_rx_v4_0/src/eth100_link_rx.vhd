library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

-- 
-- FastEthernet input RX LINK path
-- 
entity eth100_link_rx is
generic (
    FRBUF_MEM_ADDR_W : natural := 9;
    M2_SUPPORT_WRITE : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
    M2_READ_DELAY : natural := 2;         -- read delay: 2=insert register at inputs
    RXFIFO_DEPTH_W    : natural := 4                                      -- fifo depth is 2**FIFO_DEPTH_W elements
);
port (
    -- RMII
    ref_clk     : in std_logic;         -- RMII ref_clk
    rmii_rxdv   : in std_logic;
    rmii_rxdt   : in std_logic_vector(1 downto 0);
    --
    clk         : in std_logic;
    rst         : in std_logic;
    -- access to frame buffer memory
    m2_addr     : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m2_wdt      : in std_logic_vector(31 downto 0);            -- buffer write data 
    m2_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    --
    -- for removing processed frames
    rf_strobe   : in std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    rf_frlen    : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
    -- to push-fifo dequeue
    pf_deq      : in std_logic;                                     -- dequeue data command
    pf_frlen    : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    pf_empty    : out std_logic                                    -- empty fifo indication (must not dequeue more)
) ;
end entity ; -- eth100_link_rx

architecture struct of eth100_link_rx is

    -- reset in rmii_clk domain
    signal rmii_rst, rmii_rst_1 : std_logic;

    -- internal byte stream from rmii
    signal r_dv        : std_logic;        -- kept high so long as we are receiving a frame
    signal r_str_dt    : std_logic;        -- a pulse when r_dt is valid
    signal r_dt        : std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active

    -- from RX FSM to the circ buffer
    signal b_restart   : std_logic;        -- re/start new buffer
    signal b_enq       : std_logic;        -- enqueu byte to buffer
    signal b_dt        : std_logic_vector(7 downto 0);     -- data to enqueue
    signal b_commit    : std_logic;        -- commit buffer & close
    signal b_overflowed : std_logic;         -- buffer enque has caused overflow (must cancel buffer and discard frame)

    -- from frame buffer controller to the buffer
    signal m1_addr      : std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal m1_wdt       : std_logic_vector(31 downto 0);            -- buffer write data 
    signal m1_wstrobe   : std_logic;                                -- strobe to write data into the buffer

        -- to push-fifo queue
    signal pf1_enq      : std_logic;                        -- enqueue to the push-fifo
    signal pf1_frlen    : std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- data to enqueue: received frame length
    signal pf1_full     : std_logic;                         -- feedback that push-fifo is full and cannot accept input
        -- 
        -- to remove-fifo queue
    signal rf1_strobe   : std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rf1_frlen    : std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- dequeued data
    signal rf1_strobe_tmp1, rf1_strobe_tmp2 : std_logic;

        -- to push-fifo queue, in the clk domain
    signal pf2_enq      : std_logic;                        -- enqueue to the push-fifo
    signal pf2_frlen    : std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- data to enqueue: received frame length
    signal pf2_full     : std_logic;                         -- feedback that push-fifo is full and cannot accept input
    signal pf2_enq_tmp1, pf2_enq_tmp2 : std_logic;

begin
    -- RMII frontent - convert to byte stream
    rmii2bs: rmii_to_bytestream
    port map (
        ref_clk, --         : in std_logic;         -- RMII ref_clk
        -- RMII
        rmii_rxdv, --        : in std_logic;
        rmii_rxdt, --        : in std_logic_vector(1 downto 0);
        -- internal byte stream
        r_dv, --        : out std_logic;        -- kept high so long as we are receiving a frame
        r_str_dt, --    : out std_logic;        -- a pulse when r_dt is valid
        r_dt  --      : out std_logic_vector(7 downto 0)      -- 1-byte received data, valid only during r_str_dt is active
    ) ;

    -- RX FSM
    rxfsm: rxlink_fsm
    port map (
        ref_clk, --         : in std_logic;
        rmii_rst, --         : in std_logic;
        -- 
        -- RX byte stream from RMII
        r_dv, --        : in std_logic;        -- kept high so long as we are receiving a frame
        r_str_dt, --    : in std_logic;        -- a pulse when r_dt is valid
        r_dt, --        : in std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active
        -- 
        b_restart, --   : out std_logic;        -- re/start new buffer
        b_enq, --       : out std_logic;        -- enqueu byte to buffer
        b_dt, --        : out std_logic_vector(7 downto 0);     -- data to enqueue
        b_commit, --    : out std_logic;        -- commit buffer & close
        b_overflowed   --: in std_logic         -- buffer enque has caused overflow (must cancel buffer and discard frame)
    ) ;

    -- RX circular frame buffer controller
    rxcbufctrl: rxlink_cbuf_ctrl
    generic map (
        FRBUF_MEM_ADDR_W -- : natural := 9           -- buffer address width
    )
    port map (
        ref_clk, --         : in std_logic;
        rmii_rst, --         : in std_logic;
        -- 
        -- interface to rxlink FSM
        b_restart, --   : in std_logic;        -- open new buffer
        b_enq, --       : in std_logic;        -- enqueu byte to buffer
        b_dt, --        : in std_logic_vector(7 downto 0);     -- data to enqueue
        b_commit, --    : in std_logic;        -- commit buffer & close
        b_overflowed, -- : out std_logic;      -- buffer enque has caused overflow (must cancel buffer and discard frame)
        -- 
        -- to buffer memory
        m1_addr, --      : out std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m1_wdt, --       : out std_logic_vector(31 downto 0);            -- buffer write data 
        m1_wstrobe, --   : out std_logic;                                -- strobe to write data into the buffer
        -- 
        -- to push-fifo queue
        pf1_enq, --      : out std_logic;                        -- enqueue to the push-fifo
        pf1_frlen, --    : out std_logic_vector(MEM_ADDR_W-1 downto 0);     -- data to enqueue: received frame length
        pf1_full, --     : in std_logic;                         -- feedback that push-fifo is full and cannot accept input
        -- 
        -- to remove-fifo queue
        rf1_strobe, --   : in std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
        rf1_frlen  --    : in std_logic_vector(MEM_ADDR_W-1 downto 0);      -- dequeued data
    ) ;

    -- RX frame buffer, dual-ported
    rxcbuf: dp_dclk_ram_wr_rdwr
    generic map (
        FRBUF_MEM_ADDR_W, -- : natural := 9;           -- buffer address width
        32, --MEM_DATA_W : natural := 32;          -- buffer data width
        M2_SUPPORT_WRITE, -- : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
        M2_READ_DELAY  -- : natural := 2         -- read delay: 2=insert register at inputs
    )
    port map (
        -- Port 1: write-only
        ref_clk, --        : in std_logic;
        m1_addr, --     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m1_wdt, --      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
        m1_wstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        -- Port 2: read/write
        clk, --        : in std_logic;
        m2_addr, --     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m2_wdt, --      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
        m2_wstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        m2_rstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        m2_rdt  --      : out std_logic_vector(MEM_DATA_W-1 downto 0)            -- buffer write data 
    ) ;

    -- FIFO queue holding lengths of new frames
    pfqueue: fifo_queue
    generic map (
        FRBUF_MEM_ADDR_W, --     : natural;                                      -- width of data held in the fifo
        RXFIFO_DEPTH_W    --: natural                                       -- fifo depth is 2**FIFO_DEPTH_W elements
    )
    port map (
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        --
        pf2_enq, --  : in std_logic;                                     -- enqueue data command
        pf2_frlen, --    : in std_logic_vector(FIFO_DATA_W-1 downto 0);      -- data to enqueue
        pf_deq, --  : in std_logic;                                     -- dequeue data command
        pf_frlen, --    : out std_logic_vector(FIFO_DATA_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
        pf2_full, --   : out std_logic;                                    -- full fifo indication (must not enqueue more)
        pf_empty, --  : out std_logic;                                    -- empty fifo indication (must not dequeue more)
        open    --fifo_level  : out std_logic_vector(FIFO_DEPTH_W downto 0)       -- actual fill level
    ) ;

    -- clock crossing of pf1_* to pf2_*
    pf_12: process (clk)
    begin
        if rising_edge(clk) then
            pf2_frlen <= pf1_frlen;
            pf2_enq_tmp1 <= pf1_enq;
            pf2_enq_tmp2 <= pf2_enq_tmp1;
        end if;
    end process;

    -- enqueue: detect edge
    pf2_enq <= '1' when pf2_enq_tmp1='1' and pf2_enq_tmp2='0' else '0';

    -- clock crossing of pf2_* to pf1_*
    pf_21: process (ref_clk)
    begin
        if rising_edge(ref_clk) then
            pf1_full <= pf2_full;
        end if;
    end process;


    -- clock crossing of rf_* to rf1_*
    rf_21: process (ref_clk)
    begin
        if rising_edge(ref_clk) then
            rf1_frlen <= rf_frlen;
            rf1_strobe_tmp1 <= rf_strobe;
            rf1_strobe_tmp2 <= rf1_strobe_tmp1;
        end if;
    end process;

    rf1_strobe <= '1' when rf1_strobe_tmp1='1' and rf1_strobe_tmp2='0' else '0';


    -- carry reset from clk to ref_clk
    ff_rmii_clk: process (ref_clk)
    begin
        if rising_edge(ref_clk) then
            rmii_rst_1 <= rst;
            rmii_rst <= rmii_rst_1;
        end if;
    end process;

end architecture ; -- struct
