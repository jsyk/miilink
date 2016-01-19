library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 
-- Signal crossing from clk1 to clk2
-- Transports strobe and data.
-- 
entity dclk_transport is
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
end entity ; -- dclk_transport


architecture rtl of dclk_transport is

    -- in clk1
    signal strobe_latch : std_logic;
    signal dt_latch : std_logic_vector(DWIDTH-1 downto 0);

    -- in clk2
    signal strobe_tmp1, strobe_tmp2 : std_logic;

begin

    -- clock crossing of rf_* to rf1_*
    rf_21: process (clk2)
    begin
        if rising_edge(clk2) then
            dt2 <= dt_latch;              -- state signal -> simple crossing ok
            --
            strobe_tmp1 <= strobe_latch;
            strobe_tmp2 <= strobe_tmp1;
        end if;
    end process;

    rf_21l: process (clk1)
    begin
        if rising_edge(clk1) then
            if rst1 = '1' then
                strobe_latch <= '0';
            else
                if strobe1 = '1' then
                    strobe_latch <= '1';
                    dt_latch <= dt1;
                elsif strobe_tmp1 = '1' then
                    strobe_latch <= '0';
                end if;
            end if;
        end if;
    end process;

    strobe2 <= '1' when strobe_tmp1='1' and strobe_tmp2='0' else '0';

end architecture ; -- rtl
