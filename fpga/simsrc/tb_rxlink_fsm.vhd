library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_rxlink_fsm is
end entity ; -- tb_rxlink_fsm

architecture behav of tb_rxlink_fsm is

    signal clk         :  std_logic;
    signal rst         :  std_logic;
    -- 
    -- RX byte stream from RMII
    signal r_dv        :  std_logic;        -- kept high so long as we are receiving a frame
    signal r_str_dt    :  std_logic;        -- a pulse when r_dt is valid
    signal r_dt        :  std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active
    -- 
    signal b_restart   :  std_logic;        -- re/start new buffer
    signal b_enq       :  std_logic;        -- enqueu byte to buffer
    signal b_dt        :  std_logic_vector(7 downto 0);     -- data to enqueue
    signal b_commit    :  std_logic;        -- commit buffer & close
    signal b_overflowed : std_logic;         -- buffer enque has caused overflow (must cancel buffer and discard frame)

    signal eos : boolean := false;


    type ethframe_t is array (natural range <>) of std_logic_vector(7 downto 0);

    constant TEST_FRAME_1 : ethframe_t := 
        (X"55", X"55", X"55", X"55", X"55", X"55", X"55", X"D5", -- //start of frame
        X"00", X"0A", X"E6", X"F0", X"05", X"A3", 
        X"00", X"12", X"34", X"56", X"78", X"90", 
        X"08", X"00",        -- EtherType = IP
        --X"00", X"30",           -- EtherLen
        X"45", X"00", X"00", X"30", X"B3", X"FE", X"00", X"00", X"80", X"11", X"72", X"BA", X"0A", X"00", X"00", X"03", 
        X"0A", X"00", X"00", X"02", X"04", X"00", X"04", X"00", X"00", X"1C", X"89", X"4D", X"00", X"01", X"02", X"03", 
        X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F", X"10", X"11", X"12", X"13",
        X"7A", X"D5", X"6B", X"B3"  --//frame checksum; incorrect because we hand-modified the frame type/len
        );

begin
    dut: rxlink_fsm
    port map (
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        -- 
        -- RX byte stream from RMII
        r_dv, --        : in std_logic;        -- kept high so long as we are receiving a frame
        r_str_dt, --    : in std_logic;        -- a pulse when r_dt is valid
        r_dt, --        : in std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active
        -- 
        b_restart, --   : out std_logic;        -- re/start new buffer
        b_enq, --       : out std_logic;        -- enqueu byte to buffer
        b_dt, --        : out std_logic_vector(7 downto 0);     -- data to enqueue
        b_commit, --    : out std_logic;        -- commit buffer & close
        b_overflowed -- : in std_logic         -- buffer enque has caused overflow (must cancel buffer and discard frame)

    ) ;

    clkgen: process
    begin
        if eos then wait; end if;
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    tb: process
    begin
        rst <= '1';
        r_dv <= '0';
        r_str_dt <= '0';
        r_dt <= X"00";
        b_overflowed <= '0';
        wait for 10 ns;
        rst <= '0';

        r_dv <= '1';
        for i in 0 to TEST_FRAME_1'high loop
            r_dt <= TEST_FRAME_1(i);
            r_str_dt <= '1';
            wait for 10 ns;
        end loop;

        r_str_dt <= '0';
        wait for 10 ns;

        r_dv <= '0';


        -- epilog
        wait for 100 ns;
        eos <= true;
        wait;
    end process;
end architecture ; -- behav
