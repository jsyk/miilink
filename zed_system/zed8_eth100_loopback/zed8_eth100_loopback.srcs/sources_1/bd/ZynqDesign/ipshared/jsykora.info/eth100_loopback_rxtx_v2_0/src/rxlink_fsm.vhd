library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

-- 
-- Receive Link FSM
-- Gets frames from RMII byte stream, checks frame structure (preamble, SFD, length, FCS)
-- and forwards them into the circular buffer.
-- 
entity rxlink_fsm is
port (
    clk         : in std_logic;
    rst         : in std_logic;
    -- 
    -- RX byte stream from RMII
    r_dv        : in std_logic;        -- kept high so long as we are receiving a frame
    r_str_dt    : in std_logic;        -- a pulse when r_dt is valid
    r_dt        : in std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active
    -- 
    b_restart   : out std_logic;        -- re/start new buffer
    b_enq       : out std_logic;        -- enqueu byte to buffer
    b_dt        : out std_logic_vector(7 downto 0);     -- data to enqueue
    b_commit    : out std_logic;        -- commit buffer & close
    b_overflowed : in std_logic         -- buffer enque has caused overflow (must cancel buffer and discard frame)

) ;
end entity ; -- rxlink_fsm

architecture rtl of rxlink_fsm is

    type state_t is (IDLE, DISCARD, RXPREAMBLE, RXSFD_D5, RXMACADDR, RXCLIDATA, VERIFYFCS); 

    subtype count_t is integer range 0 to 2047;
    subtype pad_length_t is integer range 0 to 63;

    type registers_t is record
        state : state_t;
        cnt : count_t;

        b_restart   : std_logic;        -- re/start new buffer
        b_enq       : std_logic;        -- enqueu byte to buffer
        b_dt        : std_logic_vector(7 downto 0);     -- data to enqueue
        b_commit    : std_logic;        -- commit buffer & close
    end record;

    signal r, rin : registers_t;

    signal crc_valid : std_logic;

begin
    fcs_checker: crc
    port map (
        clk, rst,
        r.b_dt, r.b_restart, '1', r.b_enq,
        open, open, crc_valid
    );

    comb: process (r, rst, r_str_dt, r_dv, r_dt, b_overflowed, crc_valid)
    variable v : registers_t;
    begin
        v := r;
        v.b_restart := '0';
        v.b_enq := '0';
        v.b_dt := r_dt;
        v.b_commit := '0';
        -- fcs_calc <= '1';
        -- fcs_init <= '0';

        case v.state is
            when IDLE =>            -- wait for start of frame
                v.cnt := 0;
                v.b_restart := '1';
                -- fcs_init <= '1';
                if r_dv='1' then
                    -- start of new frame: receiving preamble
                    v.state := RXPREAMBLE;
                    -- maybe already receiving data?
                    if r_str_dt='1' then
                        -- yes!
                        if (r_dt=X"55") then
                            -- and it is preamble byte
                            v.cnt := 1;
                        else
                            -- incorrect, go to discard
                            v.state := DISCARD;
                        end if;
                    end if;
                end if;

            when DISCARD =>         -- discard everything till end of frame (error state)
                v.b_restart := '1';

            when RXPREAMBLE =>      -- frame started, receiving the preamble
                if r_str_dt='1' then
                    -- byte received: check if it is a preamble byte
                    if (r_dt=X"55") then
                        -- it is a preamble byte! End of preamble already? (there are 7B of preamble)
                        if v.cnt = 6 then           -- 6B already received?
                            -- seventh byte recv'ed, preamble done, expect SFD_D
                            v.state := RXSFD_D5;
                        else
                            -- continue with preamble - more bytes needed
                            v.cnt := v.cnt + 1;
                        end if;
                    else
                        -- incorrect byte in preamble -> discard frame
                        v.state := DISCARD;
                    end if;
                end if;

            when RXSFD_D5 =>         -- expect SFD byte = 0xD5 
                if r_str_dt='1' then
                    -- byte received: check if it is SFD byte
                    if (r_dt=X"D5") then
                        v.cnt := 0;
                        v.state := RXMACADDR;
                    else
                        -- incorrect byte in preamble -> discard frame
                        v.state := DISCARD;
                    end if;
                end if;

            when RXMACADDR =>       -- receiving 12B of MAC addresses
                if r_str_dt='1' then
                    -- byte received; enqueu
                    v.b_enq := '1';
                    -- finished yet? 
                    if v.cnt = 11 then          -- if 11B already received...
                        -- receiving the final 12-th byte
                        -- continue to receiving data
                        v.state := RXCLIDATA;
                        v.cnt := 0;
                    else
                        v.cnt := v.cnt + 1;
                    end if;
                end if;

            -- when RXFRAMELEN =>      -- receiving 2B of frame length
            --     if r_str_dt='1' then
            --         -- byte received; enqueu
            --         v.b_enq := '1';
            --         v.clidt_length := v.clidt_length(7 downto 0) & r_dt;
            --         -- finished yet?
            --         if v.cnt = 1 then          -- if 1B already received
            --             -- receiving the final second byte;
            --             -- Hence v.clidt_length holds frame's client data length in bytes.
            --             -- Calculate PAD field length: sum of client data and pad must be 46 or more
            --             if to_integer(unsigned(v.clidt_length)) >= 46 then
            --                 v.pad_length := 0;
            --             else
            --                 v.pad_length := 46 - to_integer(unsigned(v.clidt_length));
            --             end if;
            --             -- start receiving client data - up to clidt_length bytes
            --             v.cnt := 0;
            --             v.state := RXCLIDATA;
            --         else
            --             -- continue to receiving frame length (2B)
            --             v.cnt := v.cnt + 1;
            --         end if;
            --     end if;

            when RXCLIDATA =>
                if r_str_dt='1' then
                    -- insert to buffer
                    v.b_enq := '1';
                    v.cnt := v.cnt + 1;

                    -- if v.cnt = to_integer(unsigned(v.clidt_length)) then
                    --     -- finished client data, this byte is actually a PAD or FCS byte, do not enqueue
                    --     if v.pad_length = 0 then
                    --         -- an FCS byte already
                    --         v.state := RXFCS;
                    --         v.cnt := 1;
                    --     else
                    --         -- a PAD byte
                    --         v.state := RXPAD;
                    --         v.cnt := 1;
                    --     end if;
                    -- else
                    --     -- normal client data byte;
                    --     -- insert to buffer
                    --     v.b_enq := '1';
                    --     v.cnt := v.cnt + 1;
                    -- end if;
                elsif r_dv = '0' then
                    -- end of frame reached -> go to check the FCS
                    v.state := VERIFYFCS;
                    v.cnt := 0;
                end if;

            -- when RXPAD =>
            --     if r_str_dt='1' then
            --         if v.cnt = v.pad_length then
            --             -- received byte is FCS byte already!
            --             v.state := RXFCS;
            --             v.cnt := 1;
            --         else
            --             -- a pad byte (discard)
            --             v.cnt := v.cnt + 1;
            --         end if;
            --     end if;

            -- when RXFCS =>
            --     if r_str_dt='1' then
            --         if v.cnt = 3 then
            --             -- receiving the fourth (last) FCS byte
            --             v.state := VERIFYFCS;
            --         else
            --             -- receiving FCS byte
            --             v.cnt := v.cnt + 1;
            --         end if;
            --     end if;

            when VERIFYFCS =>
                if v.cnt = 1 then
                    if crc_valid = '1' then
                        v.b_commit := '1';          -- commit current buffer
                    end if;
                    v.state := IDLE;
                else
                    v.cnt := 1;
                end if;

        end case;

        if b_overflowed='1' then
            -- output buffer has overflowed -> discard everything
            v.b_enq := '0';
            v.b_commit := '0';
            v.state := DISCARD;
        end if;

        if (r_dv='0') and (v.state /= VERIFYFCS) then
            -- end of frame reached -> go to IDLE
            v.state := IDLE;
        end if;

        if rst = '1' then
            v.state := IDLE;
            v.cnt := 0;
        end if;

        rin <= v;
    end process;

    ff: process (clk)
    begin
        if rising_edge(clk) then
            r <= rin;
            report "r.state=" & state_t'image(rin.state) & ", cnt=" & integer'image(rin.cnt) 
                    & ", b_enq=" & std_logic'image(rin.b_enq) & ", b_dt=" 
                    & integer'image(to_integer(unsigned(rin.b_dt))) severity note;
        end if;
    end process;

    b_restart   <= r.b_restart;
    b_enq       <= r.b_enq;
    b_dt        <= r.b_dt;
    b_commit    <= r.b_commit;

    -- aux_r_state <= r.state;


end architecture ; -- rtl

