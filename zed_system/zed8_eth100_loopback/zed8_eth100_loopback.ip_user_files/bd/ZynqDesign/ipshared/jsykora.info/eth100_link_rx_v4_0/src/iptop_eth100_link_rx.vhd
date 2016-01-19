library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity iptop_eth100_link_rx is
generic (
    FRBUF_MEMBYTE_ADDR_W : natural := 11;
    RXFIFO_DEPTH_W    : natural := 4                                      -- fifo depth is 2**FIFO_DEPTH_W elements
);
port (
    -- RMII
    ref_clk     : in std_logic;         -- RMII ref_clk
    rmii_rxdv   : in std_logic;
    rmii_rxdt   : in std_logic_vector(1 downto 0);
    --
    clk         : in std_logic;
    aresetn     : in std_logic;
    -- access to frame buffer memory
    m2_addr     : in std_logic_vector(FRBUF_MEMBYTE_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m2_wdt      : in std_logic_vector(31 downto 0);            -- buffer write data 
    m2_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m2_rdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    --
    -- access to control registers "memory"
    mr_addr     : in std_logic_vector(7 downto 0);  -- register address, granularity 32b words
    mr_wdt      : in std_logic_vector(31 downto 0);            -- reg write data 
    mr_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    mr_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    mr_rdt      : out std_logic_vector(31 downto 0)            -- buffer write data 
) ;
end entity ; -- iptop_eth100_link_rx

architecture rtl of iptop_eth100_link_rx is
    constant FRBUF_MEM_ADDR_W : natural := FRBUF_MEMBYTE_ADDR_W-2;
    constant M2_SUPPORT_WRITE : boolean := true;     -- whether port 2 is read-write (when true) or read-only (when false)
    constant M2_READ_DELAY : natural := 1;         -- read delay: 2=insert register at inputs
    
    -- for removing processed frames
    signal rf_strobe   :  std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rf_frlen    :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
    -- to push-fifo dequeue
    signal pf_deq      :  std_logic;                                     -- dequeue data command
    signal pf_frlen    :  std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    signal pf_empty    :  std_logic;                                    -- empty fifo indication (must not dequeue more)

    signal rst : std_logic;

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
        m2_addr(FRBUF_MEMBYTE_ADDR_W-1 downto 2), --     : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
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
        pf_empty   -- : out std_logic                                    -- empty fifo indication (must not dequeue more)
    ) ;


    ff: process (clk)
    begin
        if rising_edge(clk) then
            rst <= not(aresetn);
            mr_rdt <= (others => '0');
            rf_strobe <= '0';
            rf_frlen <= (others => '0');
            pf_deq <= '0';

            if mr_rstrobe = '1' then
                if mr_addr = X"00" then
                    -- register X"0": Status flags
                    mr_rdt(0) <= pf_empty;
                elsif mr_addr = X"04" then
                    -- register X"1": Current Frame Len
                    mr_rdt(FRBUF_MEM_ADDR_W-1 downto 0) <= pf_frlen;
                end if;
            end if;

            if mr_wstrobe = '1' then
                if mr_addr = X"04" then
                    -- register X"1": write causes to deque the Current Frame Len
                    pf_deq <= '1';
                elsif mr_addr = X"08" then
                    -- register X"2": write-only cmd Remove Frame
                    rf_frlen <= mr_wdt(FRBUF_MEM_ADDR_W-1 downto 0);
                    rf_strobe <= '1';
                end if;
            end if;
        end if;
    end process;

end architecture ; -- rtl
