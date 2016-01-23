library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_loopback is
end entity ; -- tb_loopback

architecture behav of tb_loopback is

    constant FRBUF_MEM_ADDR_W : natural := 9;
    constant FRTAG_W : natural := 0;                  -- nr of bits for frame tag that is moved between fifos

    signal eos : boolean := false;

    signal clk         : std_logic;
    signal rst         :  std_logic;
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
    signal frame_in_work : std_logic;                          -- frame is being processed
    signal info_rx_frames :  std_logic_vector(31 downto 0);         -- number of correctly received frames
    signal info_rx_sofs :  std_logic_vector(31 downto 0);            -- number of started frames
    signal info_rx_ovfs :  std_logic_vector(31 downto 0);            -- number of overflow frames
    signal info_tx_frames :  std_logic_vector(31 downto 0);             -- number of sent frames
    signal info_tx_bytes :  std_logic_vector(31 downto 0);               -- number of sent bytes (incl. preamble bytes)

    type ethframe_t is array (natural range <>) of std_logic_vector(7 downto 0);

    constant TEST_FRAME_1 : ethframe_t := 
        (--X"55", X"55", X"55", X"55", X"55", X"55", X"55", X"D5", -- //start of frame
        X"00", X"0A", X"E6", X"F0", X"05", X"A3", 
        X"00", X"12", X"34", X"56", X"78", X"90", 
        X"08", X"00",        -- EtherType = IP
        --X"00", X"30",           -- EtherLen
        X"45", X"00", X"00", X"30", X"B3", X"FE", X"00", X"00", X"80", X"11", X"72", X"BA", X"0A", X"00", X"00", X"03", 
        X"0A", X"00", X"00", X"02", X"04", X"00", X"04", X"00", X"00", X"1C", X"89", X"4D", X"00", X"01", X"02", X"03", 
        X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F", X"10", X"11", X"12", X"13",
        X"7A", X"D5" --, X"6B", X"B3"  --//frame checksum; incorrect because we hand-modified the frame type/len
        );

    constant TEST_FRAME_2 : ethframe_t := 
        (--X"55", X"55", X"55", X"55", X"55", X"55", X"55", X"D5", -- //start of frame
        X"10", X"1A", X"F6", X"00", X"15", X"B3", 
        X"10", X"22", X"44", X"66", X"88", X"A0", 
        X"08", X"00",        -- EtherType = IP
        --X"00", X"30",           -- EtherLen
        X"45", X"00", X"00", X"30", X"B3", X"FE", X"00", X"00", X"80", X"11", X"72", X"BA", X"0A", X"00", X"00", X"03", 
        X"0A", X"00", X"00", X"02", X"04", X"00", X"04", X"00", X"00", X"1C", X"89", X"4D", X"00", X"01", X"02", X"03", 
        X"DE", X"AD" --, X"BE", X"EF"  --frame checksum; incorrect
        );
    

begin
    dut: loopback
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
        frame_in_work,
        info_rx_frames, -- : in std_logic_vector(31 downto 0);         -- number of correctly received frames
        info_rx_sofs, -- : in std_logic_vector(31 downto 0);            -- number of started frames
        info_rx_ovfs, -- : in std_logic_vector(31 downto 0);            -- number of overflow frames
        info_tx_frames, -- : in std_logic_vector(31 downto 0);             -- number of sent frames
        info_tx_bytes --: in std_logic_vector(31 downto 0)               -- number of sent bytes (incl. preamble bytes)
    ) ;

    -- simulate clock generator
    clkgen: process
    begin
        if eos then
            wait;
        end if;
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
    end process;

    -- simulate rx memory with a frame
    rxmem: process (clk)
    variable ba : natural;
    begin
        if rising_edge(clk) then
            if mr_rstrobe = '1' then
                ba := 4*to_integer(unsigned(mr_addr));
                if (ba+3) > TEST_FRAME_1'high then

                    ba := ba - (TEST_FRAME_1'high + 1);

                    if (ba+3) > TEST_FRAME_2'high then
                        mr_rdt <= (others => '0');
                    else
                        mr_rdt <= TEST_FRAME_2(ba + 3)
                            & TEST_FRAME_2(ba + 2)
                            & TEST_FRAME_2(ba + 1)
                            & TEST_FRAME_2(ba + 0);
                    end if;
                else
                    mr_rdt <= TEST_FRAME_1(ba + 3)
                        & TEST_FRAME_1(ba + 2)
                        & TEST_FRAME_1(ba + 1)
                        & TEST_FRAME_1(ba + 0);
                end if;
            end if;
        end if;
    end process;

    tb: process
    begin
        rst <= '1';
        rx_pf_frlen <= (others => '0');
        rx_pf_empty <= '1';
        mt_rdt <= (others => '0');
        tx_rf_strobe <= '0';
        tx_rf_tag_len_ptr <= (others => '0');
        tx_pf_full <= '0';
        info_rx_frames <= X"00000001";
        info_rx_sofs <= X"00000002";
        info_rx_ovfs <= X"00000003";
        info_tx_frames <= X"00000004";
        info_tx_bytes <= X"00000005";
        wait for 100 ns;
        rst <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        -- frame 1
        rx_pf_frlen <= std_logic_vector(to_unsigned(TEST_FRAME_1'length/4, FRBUF_MEM_ADDR_W));
        rx_pf_empty <= '0';
        wait until rising_edge(clk);
        
        wait until rising_edge(clk) and rx_pf_deq='1';
        rx_pf_empty <= '1';
        wait until rising_edge(clk);

        wait until rising_edge(clk);

        -- sending the frame finished
        -- tx_rf_strobe <= '1';
        -- tx_rf_tag_len_ptr(2*FRBUF_MEM_ADDR_W-1 downto FRBUF_MEM_ADDR_W) <= std_logic_vector(to_unsigned(TEST_FRAME_1'length/4, FRBUF_MEM_ADDR_W));
        -- wait until rising_edge(clk);
        -- tx_rf_strobe <= '0';
        -- wait until rising_edge(clk);

        -- frame 2
        rx_pf_frlen <= std_logic_vector(to_unsigned(TEST_FRAME_2'length/4, FRBUF_MEM_ADDR_W));
        rx_pf_empty <= '0';
        wait until rising_edge(clk);
        
        wait until rising_edge(clk) and rx_pf_deq='1';
        rx_pf_empty <= '1';
        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait for 100 ns;
        eos <= true;
        wait;
    end process;

end architecture ; -- behav
