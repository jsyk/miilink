library ieee;
use ieee.std_logic_1164.all;

-- 
-- Converts input RMII stream to am internal byte-stream with a lower data frequency.
-- 
entity rmii_to_bytestream is
port (
    clk         : in std_logic;         -- RMII ref_clk
    -- RMII
    rxdv        : in std_logic;
    rxdt        : in std_logic_vector(1 downto 0);
    -- internal byte stream
    r_dv        : out std_logic;        -- kept high so long as we are receiving a frame
    r_str_dt    : out std_logic;        -- a pulse when r_dt is valid
    r_dt        : out std_logic_vector(7 downto 0)      -- 1-byte received data, valid only during r_str_dt is active
) ;
end entity ; -- rmii_to_bytestream


architecture rtl of rmii_to_bytestream is

    subtype count_t is integer range 0 to 3;

    -- internal register type
    type registers_t is record
        str : std_logic;
        dv : std_logic;
        dt : std_logic_vector(7 downto 0);
        cnt : count_t;
    end record;

    signal r, rin : registers_t;

begin
    comb: process (r, rxdv, rxdt)
    variable v : registers_t;
    begin
        v := r;

        -- no strobe by default
        v.str := '0';

        -- copy data-valid signal
        v.dv := rxdv;

        -- Shift in new data.
        -- LSB is transmitted first, so we shift from the left side in:
        v.dt := rxdt & v.dt(7 downto 2);

        -- check rmii data-valid signal
        if rxdv = '0' then
            -- rmii data not valid, just reset the counter.
            -- Strobe and DV outputs are reset above.
            v.cnt := 0;
        else
            -- rmii data is valid;
            if v.cnt = 3 then
                -- And shifted in the last dibit!
                -- Signal the strobe so that data output is admitted downstream.
                v.str := '1';
                -- Reset count
                v.cnt := 0;
            else
                -- Some middle dibit shifted in.
                v.cnt := v.cnt + 1;
            end if;
        end if;

        rin <= v;
    end process;

    ff: process (clk)
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;

    -- Set entity outputs
    r_dv <= r.dv;
    r_str_dt <= r.str;
    r_dt <= r.dt;

end architecture ; -- rtl
