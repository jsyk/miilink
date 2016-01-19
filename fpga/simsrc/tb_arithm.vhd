library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_arithm is
end entity ; -- tb_arithm

architecture behav of tb_arithm is

    constant EIGHT : integer := 8;
    -- subtype uint8_t is integer range 0 to 255;
    subtype uint8_t is unsigned(EIGHT-1 downto 0);

    subtype wrapping_int is natural;

    subtype wuint8_t is wrapping_int range 0 to 255;


begin

    tb: process
    variable u : uint8_t;
    begin
        u := X"FF";
        report "u=" & integer'image(to_integer(u));
        u := u + 1;
        report "u=" & integer'image(to_integer(u));
        

        wait;
    end process;

end architecture ; -- behav
