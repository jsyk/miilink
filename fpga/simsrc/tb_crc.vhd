library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_crc is
end entity ; -- tb_crc

architecture behav of tb_crc is
    type ethframe_t is array (natural range <>) of std_logic_vector(7 downto 0);

    constant TEST_FRAME_1 : ethframe_t := 
        (
        -- X"55", X"55", X"55", X"55", X"55", X"55", X"55", X"D5", -- //start of frame - not part of CRC
        X"00", X"0A", X"E6", X"F0", X"05", X"A3", 
        X"00", X"12", X"34", X"56", X"78", X"90", 
        X"08", X"00",        -- EtherType = IP
        X"45", X"00", X"00", X"30", X"B3", X"FE", X"00", X"00", X"80", X"11", X"72", X"BA", X"0A", X"00", X"00", X"03", 
        X"0A", X"00", X"00", X"02", X"04", X"00", X"04", X"00", X"00", X"1C", X"89", X"4D", X"00", X"01", X"02", X"03", 
        X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F", X"10", X"11", X"12", X"13",
        X"7A", X"D5", X"6B", X"B3"  --//frame checksum
        );

    
    signal CLOCK               :   std_logic;
    signal RESET               :   std_logic;
    signal DATA                :   std_logic_vector(7 downto 0);
    signal LOAD_INIT           :   std_logic;
    signal CALC                :   std_logic;
    signal D_VALID             :   std_logic;
    signal CRCD                :   std_logic_vector(7 downto 0);
    signal CRC_REG             :   std_logic_vector(31 downto 0);
    signal CRC_VALID           :   std_logic;

    signal eos : boolean := false;

begin
    dut: CRC
    Port map (  
        CLOCK, --               :   in  std_logic;
        RESET, --               :   in  std_logic;
        DATA, --                :   in  std_logic_vector(7 downto 0);
        LOAD_INIT, --           :   in  std_logic;
        CALC, --                :   in  std_logic;
        D_VALID, --             :   in  std_logic;
        CRCD, --                 :   out std_logic_vector(7 downto 0);
        CRC_REG, --             :   out std_logic_vector(31 downto 0);
        CRC_VALID   --        :   out std_logic
     );

    clkgen: process
    begin
        if eos then wait; end if;
        CLOCK <= '0';
        wait for 5 ns;
        CLOCK <= '1';
        wait for 5 ns;
    end process;

    tb: process
    begin
        RESET <= '1';
        DATA <= (others => '0');
        LOAD_INIT <= '0';
        CALC <= '0';
        D_VALID <= '0';
        wait until rising_edge(CLOCK);
        RESET <= '0';
        
        wait until rising_edge(CLOCK);

        LOAD_INIT <= '1';
        wait until rising_edge(CLOCK);
        LOAD_INIT <= '0';

        CALC <= '1';
        wait until rising_edge(CLOCK);

        for i in 0 to TEST_FRAME_1'high loop
            D_VALID <= '1';
            DATA <= TEST_FRAME_1(i);
            wait until rising_edge(CLOCK);
            D_VALID <= '0';
        end loop;
        D_VALID <= '0';

        wait until rising_edge(CLOCK);
        
        wait until rising_edge(CLOCK);
        assert CRC_VALID = '1' severity failure;

        -- -----------
        CALC <= '0';
        LOAD_INIT <= '1';
        wait until rising_edge(CLOCK);
        LOAD_INIT <= '0';

        CALC <= '1';
        wait until rising_edge(CLOCK);

        for i in 0 to TEST_FRAME_1'high - 4 loop
            D_VALID <= '1';
            DATA <= TEST_FRAME_1(i);
            wait until rising_edge(CLOCK);
            D_VALID <= '0';
        end loop;
        D_VALID <= '0';

        -- read out final CRC: dessert CALC, assert D_VALID four times
        CALC <= '0';
        DATA <= (others => '0');    
        wait until rising_edge(CLOCK);

        D_VALID <= '1';
        wait until rising_edge(CLOCK);

        assert CRCD = X"7A" severity failure;

        wait until rising_edge(CLOCK);
        assert CRCD = X"D5" severity failure;

        wait until rising_edge(CLOCK);
        assert CRCD = X"6B" severity failure;

        wait until rising_edge(CLOCK);
        assert CRCD = X"B3" severity failure;

        D_VALID <= '0';


        wait for 100 ns;
        eos <= true;
        wait;
    end process;

end architecture ; -- behav
