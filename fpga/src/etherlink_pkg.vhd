library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package etherlink_pkg is

-- 
-- FIFO queue with configurable width and depth.
-- Single clock. Provides full/empty/level indicators.
-- 
component fifo_queue is
generic (
    FIFO_DATA_W     : natural;                                      -- width of data held in the fifo
    FIFO_DEPTH_W    : natural                                       -- fifo depth is 2**FIFO_DEPTH_W elements
);
port (
    clk         : in std_logic;
    rst         : in std_logic;
    --
    enq_strobe  : in std_logic;                                     -- enqueue data command
    enq_data    : in std_logic_vector(FIFO_DATA_W-1 downto 0);      -- data to enqueue
    deq_strobe  : in std_logic;                                     -- dequeue data command
    deq_data    : out std_logic_vector(FIFO_DATA_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    fifo_full   : out std_logic;                                    -- full fifo indication (must not enqueue more)
    fifo_empty  : out std_logic;                                    -- empty fifo indication (must not dequeue more)
    fifo_level  : out std_logic_vector(FIFO_DEPTH_W downto 0)       -- actual fill level
) ;
end component ; -- fifo


-- 
-- Converts input RMII stream to am internal byte-stream with a lower data frequency.
-- 
component rmii_to_bytestream is
port (
    clk         : in std_logic;         -- RMII ref_clk
    -- RMII
    rxdv        : in std_logic;
    rxdt        : in std_logic_vector(1 downto 0);
    -- internal byte stream
    r_dv        : out std_logic;        -- kept high so long as we are receiving a frame
    r_str_dt    : out std_logic;        -- a pulse when r_dt is valid
    r_dt        : out std_logic_vector(7 downto 0)      -- 1-byte received data, valid only during r_str_dt is active
) ;
end component ; -- rmii_to_bytestream


-- 
-- Controller of a circular buffer.
-- Receives frame bytes from RX-FSM and stores them in buffer.
-- Buffer is organized as a circle. Keeps track which part is used and which is allocated.
-- When frame is finished pushes frame length to a FIFO for protocol machine.
-- 
component rxlink_cbuf_ctrl is
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
    b_commit    : in std_logic;        -- commit buffer & close
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
end component ; -- rxlink_cbuf_ctrl


-- 
-- Receive Link FSM
-- Gets frames from RMII byte stream, checks frame structure (preamble, SFD, length, FCS)
-- and forwards them into the circular buffer.
-- 
component rxlink_fsm is
port (
    clk         : in std_logic;
    rst         : in std_logic;
    -- 
    -- RX byte stream from RMII
    r_dv        : in std_logic;        -- kept high so long as we are receiving a frame
    r_str_dt    : in std_logic;        -- a pulse when r_dt is valid
    r_dt        : in std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active
    -- 
    b_restart   : out std_logic;        -- re/start new buffer
    b_enq       : out std_logic;        -- enqueu byte to buffer
    b_dt        : out std_logic_vector(7 downto 0);     -- data to enqueue
    b_commit    : out std_logic;        -- commit buffer & close
    b_overflowed : in std_logic         -- buffer enque has caused overflow (must cancel buffer and discard frame)

) ;
end component ; -- rxlink_fsm


-- 
-- Dual-port dual-clock RAM.
-- Port 1 is write-only, with 2T write latency.
-- Port 2 is read-write, with configurable 1T or 2T read latency.
-- 
component dp_dclk_ram_wr_rdwr is
generic (
    MEM_ADDR_W : natural := 9;           -- buffer address width
    MEM_DATA_W : natural := 32;          -- buffer data width
    M2_SUPPORT_WRITE : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
    M2_READ_DELAY : natural := 2         -- read delay: 2=insert register at inputs
);
port (
    -- Port 1: write-only
    clk1        : in std_logic;
    m1_addr     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m1_wdt      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    m1_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    -- Port 2: read/write
    clk2        : in std_logic;
    m2_addr     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m2_wdt      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    m2_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rdt      : out std_logic_vector(MEM_DATA_W-1 downto 0)            -- buffer write data 
) ;
end component ; -- dp_dclk_ram_wr_rdwr


-- 
-- Dual-port dual-clock RAM.
-- Port 1 is read-write, with configurable 1T or 2T read latency.
-- Port 2 is read-write, with configurable 1T or 2T read latency.
-- 
component dp_dclk_ram_2rdwr is
generic (
    MEM_ADDR_W : natural := 9;           -- buffer address width
    MEM_DATA_W : natural := 32;          -- buffer data width
    M1_SUPPORT_READ : boolean := true;     -- whether port 1 is read-write (when true) or write-only (when false)
    M1_DELAY : natural := 2;         -- read/write delay on P1: 2=insert register at inputs
    M2_SUPPORT_WRITE : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
    M2_DELAY : natural := 2         -- read/write delay on P2: 2=insert register at inputs
);
port (
    -- Port 1: read/write
    clk1        : in std_logic;
    m1_addr     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m1_wdt      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    m1_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m1_rstrobe  : in std_logic;                                 -- strobe to read data
    m1_rdt      : out std_logic_vector(MEM_DATA_W-1 downto 0);      -- buffer read data 
    -- Port 2: read/write
    clk2        : in std_logic;
    m2_addr     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m2_wdt      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    m2_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rdt      : out std_logic_vector(MEM_DATA_W-1 downto 0)            -- buffer write data 
) ;
end component ; -- dp_dclk_ram_2rdwr


-- 
-- FastEthernet input RX LINK path
-- 
component eth100_link_rx is
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
    pf_empty    : out std_logic;                                    -- empty fifo indication (must not dequeue more)
    -- status info
    info_rx_frames : out std_logic_vector(31 downto 0);         -- number of correctly received frames
    info_rx_sofs : out std_logic_vector(31 downto 0);            -- number of started frames
    info_rx_ovfs : out std_logic_vector(31 downto 0)            -- number of overflow frames
) ;
end component ; -- eth100_link_rx


component CRC is
    Port (  CLOCK               :   in  std_logic;
            RESET               :   in  std_logic;
            DATA                :   in  std_logic_vector(7 downto 0);
            LOAD_INIT           :   in  std_logic;
            CALC                :   in  std_logic;
            D_VALID             :   in  std_logic;
            CRC                 :   out std_logic_vector(7 downto 0);
            CRC_REG             :   out std_logic_vector(31 downto 0);
            CRC_VALID           :   out std_logic
         );
end component;


--
-- Transmitting FSM for 100Mbit FastEthernet, with integrated
-- buffer control.
--
component txlink_fsm is
generic (
    MEM_ADDR_W : natural := 9;           -- buffer address width
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
    pf_empty    : in std_logic;
    pf_tag_len_ptr : in std_logic_vector(FRTAG_W+2*MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    pf_deq      : out std_logic;
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
end component ; -- txlink_fsm


--
-- Encodes MAC bytestream to RMII
--
component bytestream_to_rmii is
port (
    clk         : in std_logic;         -- RMII ref_clk
    rst         : in std_logic;
    -- RMII
    txen        : out std_logic;
    txdt        : out std_logic_vector(1 downto 0);
    -- internal byte stream
    t_dv        : in std_logic;        -- kept high so long as we are transmitting a frame
    t_str_dt    : in std_logic;        -- a pulse when t_dt is valid
    t_dt        : in std_logic_vector(7 downto 0)      -- 1-byte send data, valid only during r_str_dt is active
);
end component bytestream_to_rmii;


-- 
-- Signal crossing from clk1 to clk2
-- Transports strobe and data.
-- 
component dclk_transport is
generic (
    DWIDTH      : positive := 8
);
port (
    clk1    : in std_logic;
    rst1    : in std_logic;
    strobe1 : in std_logic;
    dt1     : in std_logic_vector(DWIDTH-1 downto 0);
    ---
    clk2    : in std_logic;
    strobe2 : out std_logic;
    dt2     : out std_logic_vector(DWIDTH-1 downto 0)
) ;
end component ; -- dclk_transport


-- 
-- FastEthernet output TX LINK path.
-- Dual-clock core.
-- 
component eth100_link_tx is
generic (
    FRBUF_MEM_ADDR_W : natural := 9;
    IGAP_LEN : natural := 6;                -- inter-frame gap in bytes
    M1_SUPPORT_READ : boolean := true;      -- whether port 2 is read-write (when true) or read-only (when false)
    M1_DELAY : natural := 2;                -- read delay: 2=insert register at inputs
    TXFIFO_DEPTH_W    : natural := 4;       -- fifo depth is 2**FIFO_DEPTH_W elements
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
end component ; -- eth100_link_tx

-- 
-- Loopback data from RX to TX Etherlink.
-- - the source and destination MACs are exchanged
-- - The first 5 words of payload are changed with info words about the state of etherlink.
-- 
component loopback is
generic (
    FRBUF_MEM_ADDR_W : natural := 9;
    FRTAG_W : natural := 0                  -- nr of bits for frame tag that is moved between fifos
);
port (
    clk         : in std_logic;
    rst         : in std_logic;
    -- access to RX frame buffer memory
    mr_addr     : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    mr_wdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    mr_wstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mr_rstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mr_rdt      : in std_logic_vector(31 downto 0);            -- buffer read data 
    --
    -- for removing frames processed by rx-protocol machine
    rx_rf_strobe   : out std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    rx_rf_frlen    : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
    -- to RX push-fifo dequeue
    rx_pf_deq      : out std_logic;                                     -- dequeue data command
    rx_pf_frlen    : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    rx_pf_empty    : in std_logic;                                   -- empty fifo indication (must not dequeue more)
    -- access to TX frame buffer memory
    mt_addr     : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    mt_wdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    mt_wstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mt_rstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mt_rdt      : in std_logic_vector(31 downto 0);            -- buffer write data 
    --
    -- for removing processed (sent) frames by the tx-link
    tx_rf_strobe   : in std_logic;                                  -- finished sending
    tx_rf_tag_len_ptr : in std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
    -- to push-fifo queue of frames to transmit
    tx_pf_enq      : out std_logic;                                     -- enqueue data command
    tx_pf_tag_len_ptr : out std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    tx_pf_full     : in std_logic;                                   -- full fifo indication (must not enqueue more)
    -- status info
    frame_in_work : out std_logic;                          -- frame is being processed
    info_rx_frames : in std_logic_vector(31 downto 0);         -- number of correctly received frames
    info_rx_sofs : in std_logic_vector(31 downto 0);            -- number of started frames
    info_rx_ovfs : in std_logic_vector(31 downto 0);            -- number of overflow frames
    info_tx_frames : in std_logic_vector(31 downto 0);             -- number of sent frames
    info_tx_bytes : in std_logic_vector(31 downto 0)               -- number of sent bytes (incl. preamble bytes)
) ;
end component ; -- loopback

end package ; -- etherlink_pkg

-- package body etherlink_pkg is
-- end package body; -- etherlink_pkg
