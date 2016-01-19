library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_dp_dclk_ram_wr_rdwr is
end entity ; -- tb_dp_dclk_ram_wr_rdwr

architecture behav of tb_dp_dclk_ram_wr_rdwr is

    constant MEM_ADDR_W : natural := 8;           -- buffer address width
    constant MEM_DATA_W : natural := 32;          -- buffer data width
    constant M2_SUPPORT_WRITE : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
    constant M2_READ_DELAY : natural := 2;         -- read delay: 2=insert register at inputs

    
        -- Port 1: write-only
    signal clk1        :  std_logic;
    signal m1_addr     :  std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal m1_wdt      :  std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    signal m1_wstrobe  :  std_logic;                                -- strobe to write data into the buffer
        -- Port 2: read/write
    signal clk2        :  std_logic;
    signal m2_addr     :  std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal m2_wdt      :  std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    signal m2_wstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal m2_rstrobe  :  std_logic;                                -- strobe to write data into the buffer
    signal m2_rdt      :  std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 

    signal eos : boolean := false;

begin
    dut: dp_dclk_ram_wr_rdwr
    generic map (
        MEM_ADDR_W, -- : natural := 9;           -- buffer address width
        MEM_DATA_W, -- : natural := 32;          -- buffer data width
        M2_SUPPORT_WRITE, -- : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
        M2_READ_DELAY -- : natural := 2         -- read delay: 2=insert register at inputs
    )
    port map (
        -- Port 1: write-only
        clk1, --        : in std_logic;
        m1_addr, --     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m1_wdt, --      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
        m1_wstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        -- Port 2: read/write
        clk2, --        : in std_logic;
        m2_addr, --     : in std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m2_wdt, --      : in std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
        m2_wstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        m2_rstrobe, --  : in std_logic;                                -- strobe to write data into the buffer
        m2_rdt    --  : out std_logic_vector(MEM_DATA_W-1 downto 0)            -- buffer write data 
    ) ;


    clkgen1: process
    begin
        if eos then wait; end if;
        clk1 <= '0';
        wait for 5 ns;
        clk1 <= '1';
        wait for 5 ns;
    end process;

    clk2 <= clk1;
    
    -- clkgen2: process
    -- begin
    --     if eos then wait; end if;
    --     clk2 <= '0';
    --     wait for 5 ns;
    --     clk2 <= '1';
    --     wait for 5 ns;
    -- end process;

    tb: process
    begin
        m1_addr <= (others => '0');
        m1_wdt <= (others => '0');
        m1_wstrobe <= '0';
        m2_addr <= (others => '0');
        m2_wdt <= (others => '0');
        m2_wstrobe <= '0';
        m2_rstrobe <= '0';
        wait for 10 ns;

        m1_wdt <= X"000000A1";
        m1_wstrobe <= '1';
        wait for 10 ns;
        m1_wstrobe <= '0';

        wait for 10 ns;
        wait for 10 ns;
        wait for 10 ns;
        wait for 10 ns;
        wait for 10 ns;

        m2_rstrobe <= '1';
        wait for 10 ns;
        m2_rstrobe <= '0';


        wait for 100 ns;
        eos <= true;
        wait;
    end process;


end architecture ; -- behav
