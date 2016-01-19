library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 
-- Dual-port dual-clock RAM.
-- Port 1 is read-write, with configurable 1T or 2T read latency.
-- Port 2 is read-write, with configurable 1T or 2T read latency.
-- 
entity dp_dclk_ram_2rdwr is
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
end entity ; -- dp_dclk_ram_2rdwr

architecture rtl of dp_dclk_ram_2rdwr is

    type mem_array_t is array (integer range <>) of std_logic_vector(MEM_DATA_W-1 downto 0);

    -- memory array
    shared variable memory : mem_array_t(0 to 2**MEM_ADDR_W-1);

    -- port 1 registered signals
    signal rm1_addr     : std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal rm1_wdt      : std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    signal rm1_wstrobe  : std_logic;                                -- strobe to write data into the buffer
    signal rm1_rstrobe  : std_logic;                                -- strobe to write data into the buffer
    signal rm1_rdt      : std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 

    -- port 2 signals
    signal rm2_addr     : std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal rm2_rstrobe  : std_logic;                                -- strobe to write data into the buffer
    signal rm2_wdt      : std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 
    signal rm2_wstrobe  : std_logic;                                -- strobe to write data into the buffer
    --
    signal rm2_rdt      : std_logic_vector(MEM_DATA_W-1 downto 0);            -- buffer write data 

begin
    ----------------------------------------------------------------------
    -- PORT 1
    ---------------
    port1_rdelay_1: if M1_DELAY = 1 generate
        -- Generate rm1_rstrobe and rm1_addr as combinatorial signals
        rm1_rstrobe <= m1_rstrobe;
        rm1_wstrobe <= m1_wstrobe;
        rm1_wdt <= m1_wdt;
        rm1_addr <= m1_addr;
    end generate;

    port1_rdelay_2: if M1_DELAY = 2 generate
        -- Generate rm1_rstrobe and rm1_addr as registered signals, adding a 1T latency
        ff3: process (clk1)
        begin
            if rising_edge(clk1) then
                rm1_rstrobe <= m1_rstrobe;
                rm1_wstrobe <= m1_wstrobe;
                rm1_wdt <= m1_wdt;
                rm1_addr <= m1_addr;
            end if;
        end process;
    end generate;

    ff1 : process (clk1)
    begin
        if rising_edge(clk1) then
            if M1_SUPPORT_READ and (rm1_rstrobe = '1') then
                rm1_rdt <= memory(to_integer(unsigned(rm1_addr)));
            end if;
            if rm1_wstrobe = '1' then
                memory(to_integer(unsigned(rm1_addr))) := rm1_wdt;
            end if;
        end if;
    end process;


    ----------------------------------------------------------------------
    -- PORT 2
    ---------------

    port2_rdelay_1: if M2_DELAY = 1 generate
        -- Generate rm2_rstrobe and rm2_addr as combinatorial signals
        rm2_rstrobe <= m2_rstrobe;
        rm2_wstrobe <= m2_wstrobe;
        rm2_wdt <= m2_wdt;
        rm2_addr <= m2_addr;
    end generate;

    port2_rdelay_2: if M2_DELAY = 2 generate
        -- Generate rm2_rstrobe and rm2_addr as registered signals, adding a 1T latency
        ff2: process (clk2)
        begin
            if rising_edge(clk2) then
                rm2_rstrobe <= m2_rstrobe;
                rm2_wstrobe <= m2_wstrobe;
                rm2_wdt <= m2_wdt;
                rm2_addr <= m2_addr;
            end if;
        end process;
    end generate;

    ff2_read: process (clk2)
    begin
        if rising_edge(clk2) then
            if rm2_rstrobe = '1' then
                rm2_rdt <= memory(to_integer(unsigned(rm2_addr)));
            end if;
            if M2_SUPPORT_WRITE and (rm2_wstrobe = '1') then
                memory(to_integer(unsigned(rm2_addr))) := rm2_wdt;
            end if;
        end if;
    end process;

    m2_rdt <= rm2_rdt;
    m1_rdt <= rm1_rdt;

    assert (M1_DELAY=1) or (M1_DELAY=2) severity failure;
    assert (M2_DELAY=1) or (M2_DELAY=2) severity failure;

end architecture ; -- rtl
