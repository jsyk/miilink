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
    pf_empty    : out std_logic                                    -- empty fifo indication (must not dequeue more)
) ;
end component ; -- eth100_link_rx


end package ; -- etherlink_pkg

-- package body etherlink_pkg is
-- end package body; -- etherlink_pkg
