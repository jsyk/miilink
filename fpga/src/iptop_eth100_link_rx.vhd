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
    mr_rdt      : out std_logic_vector(31 downto 0);           -- buffer write data 
    -- interupt request (frame received) out, level
    irq         : out std_logic
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

    signal rst, rst1 : std_logic;
    signal rst_shift : std_logic_vector(7 downto 0);

    signal info_rx_frames :  std_logic_vector(31 downto 0);         -- number of correctly received frames
    signal info_rx_sofs :  std_logic_vector(31 downto 0);            -- number of started frames
    signal info_rx_ovfs :  std_logic_vector(31 downto 0);            -- number of started frames

    signal r_irq_en : std_logic;
    signal r_irq_st : std_logic;

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
        pf_empty,   -- : out std_logic                                    -- empty fifo indication (must not dequeue more)
        -- info counters
        info_rx_frames, info_rx_sofs, info_rx_ovfs
    ) ;


    ff: process (clk)
    begin
        if rising_edge(clk) then
            rst1 <= not(aresetn);
            rst <= rst1;
            if rst_shift /= X"00" then
                rst <= '1';
            end if;
            if rst='1' then
                r_irq_en <= '0';
                r_irq_st <= '0';
            end if;
            mr_rdt <= (others => '0');
            rf_strobe <= '0';
            rf_frlen <= (others => '0');
            pf_deq <= '0';
            rst_shift <= '0' & rst_shift(7 downto 1);

            if mr_rstrobe = '1' then
                if mr_addr = X"00" then
                    -- register X"0": Status flags
                    -- bit 0 = pf_empty
                    -- bit 1 = R/W: irq_en
                    -- bit 2 = R/W: irq_st
                    -- bits 31:3 = undefined
                    mr_rdt(0) <= pf_empty;
                    mr_rdt(1) <= r_irq_en;
                    mr_rdt(2) <= r_irq_st;
                elsif mr_addr = X"04" then
                    -- register X"1": Current Frame Len
                    mr_rdt(FRBUF_MEM_ADDR_W-1 downto 0) <= pf_frlen;
                elsif mr_addr = X"10" then
                    mr_rdt <= info_rx_frames;
                elsif mr_addr = X"14" then
                    mr_rdt <= info_rx_sofs;
                elsif mr_addr = X"18" then
                    mr_rdt <= info_rx_ovfs;
                end if;
            end if;

            if mr_wstrobe = '1' then
                if mr_addr = X"00" then
                    if mr_wdt(31) = '1' then
                        -- bit 31 - reset
                        rst_shift(7) <= '1';
                    end if;
                    r_irq_en <= mr_wdt(1);
                    r_irq_st <= mr_wdt(2);
                elsif mr_addr = X"04" then
                    -- register X"1": write causes to deque the Current Frame Len
                    pf_deq <= '1';
                elsif mr_addr = X"08" then
                    -- register X"2": write-only cmd Remove Frame
                    rf_frlen <= mr_wdt(FRBUF_MEM_ADDR_W-1 downto 0);
                    rf_strobe <= '1';
                end if;
            end if;

            if pf_empty='0' then
                -- there is received frame
                r_irq_st <= r_irq_en;
            end if;
        end if;
    end process;

    irq <= r_irq_st;

end architecture ; -- rtl
