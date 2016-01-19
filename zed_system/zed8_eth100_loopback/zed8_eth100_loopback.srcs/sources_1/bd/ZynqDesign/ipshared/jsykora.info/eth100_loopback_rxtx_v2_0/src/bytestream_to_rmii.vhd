library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--
-- Encodes MAC bytestream to RMII
--
entity bytestream_to_rmii is
port (
    clk         : in std_logic;         -- RMII ref_clk
    rst         : in std_logic;
    -- RMII
    txen        : out std_logic;
    txdt        : out std_logic_vector(1 downto 0);
    -- internal byte stream
    t_dv        : in std_logic;        -- kept high so long as we are transmitting a frame
    t_str_dt    : in std_logic;        -- a pulse when t_dt is valid
    t_dt        : in std_logic_vector(7 downto 0)      -- 1-byte send data, valid only during r_str_dt is active
);
end entity bytestream_to_rmii;


architecture rtl of bytestream_to_rmii is

    subtype count_t is integer range 0 to 3;

    -- internal register type
    type registers_t is record
        en : std_logic;
        dt : std_logic_vector(7 downto 0);
        dv : std_logic_vector(3 downto 0);
    end record;

    signal r, rin : registers_t;

begin

    comb: process (r, rst, t_dv, t_str_dt, t_dt)
    variable v : registers_t;
    begin
        v := r;

        if v.en = '0' then
            -- quiet, not sending
            v.dv := (others => '0');

            -- startup if t_dv and strobe are active at the same time
            if (t_dv and t_str_dt) = '1' then
                -- startup!
                v.dt := t_dt;
                v.dv := (others => '1');
                v.en := '1';
            end if;
        else
            -- ongoing transmission
            -- shift data - move bits to LSB
            v.dt := "00" & v.dt(7 downto 2);
            v.dv := '0' & v.dv(3 downto 1);

            if t_str_dt = '1' then
                v.dt := t_dt;
                v.dv := (others => '1');
            end if;

            if t_dv = '0' then
                -- end of byte stream; finish current byte first
                if v.dv = "0000" then
                    -- last byte finished, go idle
                    v.en := '0';
                end if;
            end if;
        end if;


        if rst = '1' then
            v.en := '0';
            v.dt := (others => '0');
            v.dv := (others => '0');
        end if;

        rin <= v;
    end process;

    ff: process (clk)
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;

    -- set output signals:
    -- TX data - LSB of the internal buffer
    txdt <= r.dt(1 downto 0);
    txen <= r.en;

end architecture rtl;
