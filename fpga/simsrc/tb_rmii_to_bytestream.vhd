library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_rmii_to_bytestream is
end entity ; -- tb_rmii_to_bytestream

architecture behav of tb_rmii_to_bytestream is

    signal     clk         :  std_logic;         -- RMII ref_clk
    -- RMII
    signal     rxdv        :  std_logic;
    signal     rxdt        :  std_logic_vector(1 downto 0);
    -- internal byte stream
    signal     r_dv        :  std_logic;        -- kept high so long as we are receiving a frame
    signal     r_str_dt    :  std_logic;        -- a pulse when r_dt is valid
    signal     r_dt        :  std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active

    signal eos : boolean := false;

begin
    dut: rmii_to_bytestream
    port map (
        clk,
        rxdv,
        rxdt,
        r_dv,
        r_str_dt,
        r_dt
    );

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
        rxdv <= '0';
        rxdt <= "00";
        wait for 50 ns;
        assert r_dv = '0' severity failure;
        assert r_str_dt = '0' severity failure;

        rxdv <= '1';
        rxdt <= "01";
        wait for 10 ns;
        assert r_dv = '1' severity failure;
        assert r_str_dt = '0' severity failure;

        wait for 10 ns;
        assert r_dv = '1' severity failure;
        assert r_str_dt = '0' severity failure;

        wait for 10 ns;
        assert r_dv = '1' severity failure;
        assert r_str_dt = '0' severity failure;

        rxdt <= "10";
        wait for 10 ns;
        assert r_dv = '1' severity failure;
        assert r_str_dt = '1' severity failure;
        assert r_dt = "10010101" severity failure;

        eos <= true;
        wait;
    end process;

end architecture ; -- behav
