library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_eth100_link_rx is
end entity ; -- tb_eth100_link_rx

architecture behav of tb_eth100_link_rx is

    constant FRBUF_MEM_ADDR_W : natural := 9;
    constant M2_SUPPORT_WRITE : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
    constant M2_READ_DELAY : natural := 2;         -- read delay: 2=insert register at inputs
    constant RXFIFO_DEPTH_W    : natural := 4;                                      -- fifo depth is 2**FIFO_DEPTH_W elements

        -- RMII
    signal ref_clk     :  std_logic;         -- RMII ref_clk
    signal rmii_rxdv   :  std_logic;
    signal rmii_rxdt   :  std_logic_vector(1 downto 0);
        --
    signal clk         :  std_logic;
    signal rst         :  std_logic;
        -- access to frame buffer memory
    signal m2_addr     :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal m2_wdt      :  std_logic_vector(31 downto 0);            -- buffer write data 
    signal m2_wstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal m2_rstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal m2_rdt      :  std_logic_vector(31 downto 0);            -- buffer write data 
        --
        -- for removing processed frames
    signal rf_strobe   :  std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rf_frlen    :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
        -- to push-fifo dequeue
    signal pf_deq      :  std_logic;                                     -- dequeue data command
    signal pf_frlen    :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    signal pf_empty    :  std_logic;                                    -- empty fifo indication (must not dequeue more)

    signal info_rx_frames :  std_logic_vector(31 downto 0);         -- number of correctly received frames
    signal info_rx_sofs :  std_logic_vector(31 downto 0);            -- number of started frames
    signal info_rx_ovfs :  std_logic_vector(31 downto 0);            -- number of started frames

    signal eos : boolean := false;

    type ethframe_t is array (natural range <>) of std_logic_vector(7 downto 0);

    constant TEST_FRAME_1 : ethframe_t := 
        (X"55", X"55", X"55", X"55", X"55", X"55", X"55", X"D5", -- //start of frame
        X"00", X"0A", X"E6", X"F0", X"05", X"A3", 
        X"00", X"12", X"34", X"56", X"78", X"90", 
        X"08", X"00",        -- EtherType = IP
        -- X"00", X"30",           -- EtherLen
        X"45", X"00", X"00", X"30", X"B3", X"FE", X"00", X"00", X"80", X"11", X"72", X"BA", X"0A", X"00", X"00", X"03", 
        X"0A", X"00", X"00", X"02", X"04", X"00", X"04", X"00", X"00", X"1C", X"89", X"4D", X"00", X"01", X"02", X"03", 
        X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F", X"10", X"11", X"12", X"13",
        X"7A", X"D5", X"6B", X"B3"  --//frame checksum; incorrect because we hand-modified the frame type/len
        );

begin
    dut: eth100_link_rx
    generic map (
        FRBUF_MEM_ADDR_W, -- : natural := 9;
        M2_SUPPORT_WRITE, -- : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
        M2_READ_DELAY, -- : natural := 2;         -- read delay: 2=insert register at inputs
        RXFIFO_DEPTH_W  --  : natural := 4                                      -- fifo depth is 2**FIFO_DEPTH_W elements
    )
    port map (
        -- RMII
        ref_clk, --     : in std_logic;         -- RMII ref_clk
        rmii_rxdv, --   : in std_logic;
        rmii_rxdt, --   : in std_logic_vector(1 downto 0);
        --
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        -- access to frame buffer memory
        m2_addr, --     : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m2_wdt, --      : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);            -- buffer write data 
        m2_wstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        m2_rstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        m2_rdt, --      : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);            -- buffer write data 
        --
        -- for removing processed frames
        rf_strobe, --   : in std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
        rf_frlen, --    : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
        -- to push-fifo dequeue
        pf_deq, --      : in std_logic;                                     -- dequeue data command
        pf_frlen, --    : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
        pf_empty,   -- : out std_logic                                    -- empty fifo indication (must not dequeue more)
        info_rx_frames, info_rx_sofs, info_rx_ovfs
    ) ;

    clkgen: process
    begin
        if eos then wait; end if;
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    refclkgen: process
    begin
        if eos then wait; end if;
        ref_clk <= '0';
        wait for 10 ns;
        ref_clk <= '1';
        wait for 10 ns;
    end process;


    tb_rmii: process
    begin
        rmii_rxdv <= '0';
        rmii_rxdt <= "00";
        wait for 100 ns;

        rmii_rxdv <= '1';
        for i in 0 to TEST_FRAME_1'high loop
            for k in 0 to 3 loop
                rmii_rxdt <= TEST_FRAME_1(i)(2*k+1 downto 2*k);
                wait for 20 ns;
            end loop;
        end loop;
        rmii_rxdv <= '0';

        wait for 500 ns;
        eos <= true;
        wait;
    end process;

    tb2: process
    begin
        m2_wdt <= (others => '0');
        m2_addr <= (others => '0');
        m2_wstrobe <= '0';
        m2_rstrobe <= '0';
        rf_strobe <= '0';
        rf_frlen <= (others => '0');
        pf_deq <= '0';
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        wait until pf_empty = '0' and rising_edge(clk);

        -- read from frame buffer
        m2_rstrobe <= '1';
        wait until rising_edge(clk);

        m2_rstrobe <= '1';
        m2_addr <= "000000001";
        wait until rising_edge(clk);

        wait for 2 ns;
        assert m2_rdt = X"F0E60A00" severity failure;

        m2_rstrobe <= '0';
        wait until rising_edge(clk);

        wait for 2 ns;
        assert m2_rdt = X"1200A305" severity failure;

        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait until rising_edge(clk);
        
        rf_strobe <= '1';
        pf_deq <= '1';
        rf_frlen <= pf_frlen;
        wait until rising_edge(clk);

        rf_strobe <= '0';
        rf_frlen <= (others => '0');
        pf_deq <= '0';
        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait until rising_edge(clk);

        wait;
    end process;

end architecture ; -- behav
