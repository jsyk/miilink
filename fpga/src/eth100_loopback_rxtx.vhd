library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity eth100_loopback_rxtx is
generic (
    FRBUF_MEM_ADDR_W : natural := 9;        -- buffer memory size in address width (word addressing)
    IGAP_LEN : natural := 6;               -- inter-frame gap in bytes
    RXFIFO_DEPTH_W   : natural := 4;       -- fifo depth is 2**FIFO_DEPTH_W elements
    TXFIFO_DEPTH_W    : natural := 4       -- fifo depth is 2**FIFO_DEPTH_W elements
);
port (
    -- RMII
    ref_clk     : in std_logic;         -- RMII ref_clk
    rmii_rxdv   : in std_logic;
    rmii_rxdt   : in std_logic_vector(1 downto 0);
    rmii_txen   : out std_logic;
    rmii_txdt   : out std_logic_vector(1 downto 0);
    --
    clk         : in std_logic;
    aresetn     : in std_logic;
    --
    status_leds_o : out std_logic_vector(5 downto 0)
) ;
end entity ; -- eth100_loopback_rxtx

architecture rtl of eth100_loopback_rxtx is

    -- RX
    constant M2_SUPPORT_WRITE : boolean := false;     -- whether port 2 is read-write (when true) or read-only (when false)
    constant M2_READ_DELAY : natural := 1;         -- read delay: 2=insert register at inputs
    -- TX
    constant M1_SUPPORT_READ : boolean := false;      -- whether port 2 is read-write (when true) or read-only (when false)
    constant M1_DELAY : natural := 1;                -- read delay: 2=insert register at inputs
    constant FRTAG_W : natural := 0;                  -- nr of bits for frame tag that is moved between fifos


    -- access to RX frame buffer memory
    signal mr_addr     :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal mr_wdt      :  std_logic_vector(31 downto 0);            -- buffer write data 
    signal mr_wstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal mr_rstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal mr_rdt      :  std_logic_vector(31 downto 0);            -- buffer read data 
    --
    -- for removing frames processed by rx-protocol machine
    signal rx_rf_strobe   :  std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rx_rf_frlen    :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
    -- to RX push-fifo dequeue
    signal rx_pf_deq      :  std_logic;                                     -- dequeue data command
    signal rx_pf_frlen    :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    signal rx_pf_empty    :  std_logic;                                   -- empty fifo indication (must not dequeue more)
    -- access to TX frame buffer memory
    signal mt_addr     :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal mt_wdt      :  std_logic_vector(31 downto 0);            -- buffer write data 
    signal mt_wstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal mt_rstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal mt_rdt      :  std_logic_vector(31 downto 0);            -- buffer write data 
    --
    -- for removing processed (sent) frames by the tx-link
    signal tx_rf_strobe   :  std_logic;                                  -- finished sending
    signal tx_rf_tag_len_ptr :  std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
    -- to push-fifo queue of frames to transmit
    signal tx_pf_enq      :  std_logic;                                     -- enqueue data command
    signal tx_pf_tag_len_ptr :  std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    signal tx_pf_full     :  std_logic;                                   -- full fifo indication (must not enqueue more)
    -- status info
    signal info_rx_frames :  std_logic_vector(31 downto 0);         -- number of correctly received frames
    signal info_rx_sofs :  std_logic_vector(31 downto 0);            -- number of started frames
    signal info_rx_ovfs :  std_logic_vector(31 downto 0);            -- number of overflow frames
    signal info_tx_frames :  std_logic_vector(31 downto 0);             -- number of sent frames
    signal info_tx_bytes :  std_logic_vector(31 downto 0);               -- number of sent bytes (incl. preamble bytes)

    signal rst : std_logic;

begin
    rx: eth100_link_rx
    generic map (
        FRBUF_MEM_ADDR_W, -- : natural := 9;
        M2_SUPPORT_WRITE, -- : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
        M2_READ_DELAY, -- : natural := 2;         -- read delay: 2=insert register at inputs
        RXFIFO_DEPTH_W    --: natural := 4                                      -- fifo depth is 2**FIFO_DEPTH_W elements
    )
    port map (
        -- RMII
        ref_clk, --    : in std_logic;         -- RMII ref_clk
        rmii_rxdv, --   : in std_logic;
        rmii_rxdt, --   : in std_logic_vector(1 downto 0);
        --
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        -- access to frame buffer memory
        mr_addr, --     : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        mr_wdt, --      : in std_logic_vector(31 downto 0);            -- buffer write data 
        mr_wstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        mr_rstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        mr_rdt, --      : out std_logic_vector(31 downto 0);            -- buffer write data 
        --
        -- for removing frames processed by rx-protocol machine
        rx_rf_strobe, --   : in std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
        rx_rf_frlen, --    : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
        -- to push-fifo dequeue
        rx_pf_deq, --      : in std_logic;                                     -- dequeue data command
        rx_pf_frlen, --    : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
        rx_pf_empty, --    : out std_logic;                                   -- empty fifo indication (must not dequeue more)
        -- status info
        info_rx_frames, -- : out std_logic_vector(31 downto 0);         -- number of correctly received frames
        info_rx_sofs, -- : out std_logic_vector(31 downto 0);            -- number of started frames
        info_rx_ovfs    --: out std_logic_vector(31 downto 0)            -- number of overflow frames
    ) ;

    lb: loopback
    generic map (
        FRBUF_MEM_ADDR_W, -- : natural := 9;
        FRTAG_W     -- : natural := 0                  -- nr of bits for frame tag that is moved between fifos
    )
    port map (
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        -- access to RX frame buffer memory
        mr_addr, --     : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        mr_wdt, --      : out std_logic_vector(31 downto 0);            -- buffer write data 
        mr_wstrobe, --  : out std_logic;                                -- strobe to write data into the buffer
        mr_rstrobe, --  : out std_logic;                                -- strobe to write data into the buffer
        mr_rdt, --      : in std_logic_vector(31 downto 0);            -- buffer read data 
        --
        -- for removing frames processed by rx-protocol machine
        rx_rf_strobe, --   : out std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
        rx_rf_frlen, --    : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
        -- to RX push-fifo dequeue
        rx_pf_deq, --      : out std_logic;                                     -- dequeue data command
        rx_pf_frlen, --    : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
        rx_pf_empty, --    : in std_logic;                                   -- empty fifo indication (must not dequeue more)
        -- access to TX frame buffer memory
        mt_addr, --     : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        mt_wdt, --      : out std_logic_vector(31 downto 0);            -- buffer write data 
        mt_wstrobe, --  : out std_logic;                                -- strobe to write data into the buffer
        mt_rstrobe, --  : out std_logic;                                -- strobe to write data into the buffer
        mt_rdt, --      : in std_logic_vector(31 downto 0);            -- buffer write data 
        --
        -- for removing processed (sent) frames by the tx-link
        tx_rf_strobe, --   : in std_logic;                                  -- finished sending
        tx_rf_tag_len_ptr, -- : in std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
        -- to push-fifo queue of frames to transmit
        tx_pf_enq, --      : out std_logic;                                     -- enqueue data command
        tx_pf_tag_len_ptr, -- : out std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
        tx_pf_full, --     : in std_logic;                                   -- full fifo indication (must not enqueue more)
        -- status info
        info_rx_frames, -- : in std_logic_vector(31 downto 0);         -- number of correctly received frames
        info_rx_sofs, -- : in std_logic_vector(31 downto 0);            -- number of started frames
        info_rx_ovfs, -- : in std_logic_vector(31 downto 0);            -- number of overflow frames
        info_tx_frames, -- : in std_logic_vector(31 downto 0);             -- number of sent frames
        info_tx_bytes --: in std_logic_vector(31 downto 0)               -- number of sent bytes (incl. preamble bytes)
    ) ;


    tx: eth100_link_tx
    generic map (
        FRBUF_MEM_ADDR_W, -- : natural := 9;
        IGAP_LEN, -- : natural := 6;                -- inter-frame gap in bytes
        M1_SUPPORT_READ, -- : boolean := true;      -- whether port 2 is read-write (when true) or read-only (when false)
        M1_DELAY, -- : natural := 2;                -- read delay: 2=insert register at inputs
        TXFIFO_DEPTH_W, --    : natural := 4;       -- fifo depth is 2**FIFO_DEPTH_W elements
        FRTAG_W --: natural := 0                  -- nr of bits for frame tag that is moved between fifos
    )
    port map (
        -- RMII
        ref_clk, --     : in std_logic;         -- RMII ref_clk
        rmii_txen, --   : out std_logic;
        rmii_txdt, --   : out std_logic_vector(1 downto 0);
        --
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        -- access to frame buffer memory
        mt_addr, --     : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        mt_wdt, --      : in std_logic_vector(31 downto 0);            -- buffer write data 
        mt_wstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        mt_rstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        mt_rdt, --      : out std_logic_vector(31 downto 0);            -- buffer write data 
        --
        -- for removing processed (sent) frames by the tx-link
        tx_rf_strobe, --   : out std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
        tx_rf_tag_len_ptr, --    : out std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
        -- to push-fifo queue of frames to transmit
        tx_pf_enq, --      : in std_logic;                                     -- enqueue data command
        tx_pf_tag_len_ptr, -- : in std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
        tx_pf_full, --     : out std_logic;                                   -- full fifo indication (must not enqueue more)
        -- status info
        info_tx_frames, -- : out std_logic_vector(31 downto 0);             -- number of sent frames
        info_tx_bytes   --: out std_logic_vector(31 downto 0)               -- number of sent bytes (incl. preamble bytes)
    ) ;

    
    genrst: process (clk)
    begin
        if rising_edge(clk) then
            rst <= not(aresetn);
        end if;
    end process;

    status_leds_o(0) <= not rx_pf_empty;
    status_leds_o(1) <= tx_pf_enq;
    status_leds_o(5 downto 2) <= (others => '0');

end architecture ; -- rtl
