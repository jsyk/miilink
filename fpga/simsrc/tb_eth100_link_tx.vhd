library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_eth100_link_tx is
end entity ; -- tb_eth100_link_tx

architecture behav of tb_eth100_link_tx is

    constant FRBUF_MEM_ADDR_W : natural := 9;
    constant IGAP_LEN : natural := 6;                -- inter-frame gap in bytes
    constant M1_SUPPORT_READ : boolean := true;      -- whether port 2 is read-write (when true) or read-only (when false)
    constant M1_DELAY : natural := 2;                -- read delay: 2=insert register at inputs
    constant TXFIFO_DEPTH_W    : natural := 4;        -- fifo depth is 2**FIFO_DEPTH_W elements
    constant FRTAG_W : natural := 0;                  -- nr of bits for frame tag that is moved between fifos

    signal eos : boolean := false;

        -- RMII
    signal ref_clk     : std_logic;         -- RMII ref_clk
    signal rmii_txen   :  std_logic;
    signal rmii_txdt   :  std_logic_vector(1 downto 0);
        --
    signal clk         :  std_logic;
    signal rst         :  std_logic;
        -- access to frame buffer memory
    signal m1_addr     :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal m1_wdt      :  std_logic_vector(31 downto 0);            -- buffer write data 
    signal m1_wstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal m1_rstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal m1_rdt      :  std_logic_vector(31 downto 0);            -- buffer write data 
        --
        -- for removing processed (sent) frames by the tx-link
    signal rf_strobe   :  std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rf_tag_len_ptr    : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
        -- to push-fifo queue of frames to transmit
    signal pf_enq      :  std_logic;                                     -- enqueue data command
    signal pf_tag_len_ptr : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    signal pf_full    :  std_logic;                                   -- full fifo indication (must not enqueue more)

    type ethframe_t is array (natural range <>) of std_logic_vector(7 downto 0);

    constant TEST_FRAME_1 : ethframe_t := (
        X"00", X"0A", X"E6", X"F0", X"05", X"A3", 
        X"00", X"12", X"34", X"56", X"78", X"90", 
        X"08", X"00",        -- EtherType = IP
        X"45", X"00", X"00", X"30", X"B3", X"FE", X"00", X"00", X"80", X"11", X"72", X"BA", X"0A", X"00", X"00", X"03", 
        X"0A", X"00", X"00", X"02", X"04", X"00", X"04", X"00", X"00", X"1C", X"89", X"4D", X"00", X"01", X"02", X"03", 
        X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F", X"10", X"11", X"12", X"13",
        X"14", X"15"
    );

begin
    dut: eth100_link_tx
    generic map (
        FRBUF_MEM_ADDR_W,   -- : natural := 9;
        IGAP_LEN,           -- : natural := 6;                -- inter-frame gap in bytes
        M1_SUPPORT_READ,    -- : boolean := true;      -- whether port 2 is read-write (when true) or read-only (when false)
        M1_DELAY,           -- : natural := 2;                -- read delay: 2=insert register at inputs
        TXFIFO_DEPTH_W,     --: natural := 4        -- fifo depth is 2**FIFO_DEPTH_W elements
        FRTAG_W
    )
    port map (
        -- RMII
        ref_clk,    --: in std_logic;         -- RMII ref_clk
        rmii_txen,   --: out std_logic;
        rmii_txdt,   --: out std_logic_vector(1 downto 0);
        --
        clk,         --: in std_logic;
        rst,         --: in std_logic;
        -- access to frame buffer memory
        m1_addr,     --: in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m1_wdt,      --: in std_logic_vector(31 downto 0);            -- buffer write data 
        m1_wstrobe,  --: in std_logic;                                -- strobe to write data into the buffer
        m1_rstrobe,  --: in std_logic;                                -- strobe to write data into the buffer
        m1_rdt,      --: out std_logic_vector(31 downto 0);            -- buffer write data 
        --
        -- for removing processed (sent) frames by the tx-link
        rf_strobe,   --: out std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
        rf_tag_len_ptr,
        -- to push-fifo queue of frames to transmit
        pf_enq,      --: in std_logic;                                     -- enqueue data command
        pf_tag_len_ptr,
        pf_full     --: out std_logic                                   -- full fifo indication (must not enqueue more)
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

    tb2: process
    variable wdt : std_logic_vector(31 downto 0);
    begin
        rst <= '1';
        pf_enq <= '0';
        pf_tag_len_ptr <= (others => '0');
        m1_addr <= (others => '0');
        m1_wdt <= (others => '0');
        m1_wstrobe <= '0';
        m1_rstrobe <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        rst <= '0';

        wait until rising_edge(clk);
        -- fill in framebuffer memory with constant data
        for k in 0 to (TEST_FRAME_1'length/4-1) loop
            wdt(7 downto 0) := TEST_FRAME_1(4*k + 0);
            wdt(15 downto 8) := TEST_FRAME_1(4*k + 1);
            wdt(23 downto 16) := TEST_FRAME_1(4*k + 2);
            wdt(31 downto 24) := TEST_FRAME_1(4*k + 3);
            m1_addr <= std_logic_vector(to_unsigned(k, FRBUF_MEM_ADDR_W));
            m1_wdt <= wdt;
            m1_wstrobe <= '1';
            wait until rising_edge(clk);
        end loop;
        m1_wstrobe <= '0';

        wait until rising_edge(clk);

        -- enque the frame ready in the buffer
        pf_tag_len_ptr(2*FRBUF_MEM_ADDR_W-1 downto FRBUF_MEM_ADDR_W) <= std_logic_vector(to_unsigned(TEST_FRAME_1'length/4, FRBUF_MEM_ADDR_W));
        pf_enq <= '1';
        wait until rising_edge(clk);
        pf_tag_len_ptr <= (others => '0');
        pf_enq <= '0';
        wait until rising_edge(clk);

        -- wait till frame is sent
        wait until rising_edge(clk) and rf_strobe='1';

        wait for 1000 ns;
        eos <= true;
        wait;
    end process;

end architecture ; -- behav
