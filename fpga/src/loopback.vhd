library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

-- 
-- Loopback data from RX to TX Etherlink.
-- - the source and destination MACs are exchanged
-- - The first 5 words of payload are changed with info words about the state of etherlink.
-- 
-- TBD: NOT IMPLEMENTED - check for overflows on the transmit buffer!
-- 
entity loopback is
generic (
    FRBUF_MEM_ADDR_W : natural := 9;
    FRTAG_W : natural := 0                  -- nr of bits for frame tag that is moved between fifos
);
port (
    clk         : in std_logic;
    rst         : in std_logic;
    -- access to RX frame buffer memory
    mr_addr     : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    mr_wdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    mr_wstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mr_rstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mr_rdt      : in std_logic_vector(31 downto 0);            -- buffer read data 
    --
    -- for removing frames processed by rx-protocol machine
    rx_rf_strobe   : out std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    rx_rf_frlen    : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);      -- remove length
    -- to RX push-fifo dequeue
    rx_pf_deq      : out std_logic;                                     -- dequeue data command
    rx_pf_frlen    : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    rx_pf_empty    : in std_logic;                                   -- empty fifo indication (must not dequeue more)
    -- access to TX frame buffer memory
    mt_addr     : out std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    mt_wdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    mt_wstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mt_rstrobe  : out std_logic;                                -- strobe to write data into the buffer
    mt_rdt      : in std_logic_vector(31 downto 0);            -- buffer write data 
    --
    -- for removing processed (sent) frames by the tx-link
    tx_rf_strobe   : in std_logic;                                  -- finished sending
    tx_rf_tag_len_ptr : in std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
    -- to push-fifo queue of frames to transmit
    tx_pf_enq      : out std_logic;                                     -- enqueue data command
    tx_pf_tag_len_ptr : out std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    tx_pf_full     : in std_logic;                                   -- full fifo indication (must not enqueue more)
    -- status info
    info_rx_frames : in std_logic_vector(31 downto 0);         -- number of correctly received frames
    info_rx_sofs : in std_logic_vector(31 downto 0);            -- number of started frames
    info_rx_ovfs : in std_logic_vector(31 downto 0);            -- number of overflow frames
    info_tx_frames : in std_logic_vector(31 downto 0);             -- number of sent frames
    info_tx_bytes : in std_logic_vector(31 downto 0)               -- number of sent bytes (incl. preamble bytes)
) ;
end entity ; -- loopback


architecture rtl of loopback is

    type state_t is (IDLE, RD_MAC_0, RD_MAC_1, RD_MAC_2, WR_MAC_0, WR_MAC_1, WR_MAC_2,
                    COPY_ETHTYPE, WRT_INFO_0, WRT_INFO_1, WRT_INFO_2, WRT_INFO_3, WRT_INFO_4, COPY_PAYLOAD, DONE);
    
    subtype wordpointer_t is unsigned(FRBUF_MEM_ADDR_W-1 downto 0);       -- wrapping

    type registers_t is record
        state : state_t;
        rx_rptr : wordpointer_t;
        tx_wptr : wordpointer_t;
        tx_base : wordpointer_t;
        tx_bottom : wordpointer_t;
        cnt : wordpointer_t;
        frlen : wordpointer_t;

        dest_mac: std_logic_vector(47 downto 0);
        src_mac: std_logic_vector(47 downto 0);
    end record;

    signal r, rin : registers_t;

begin

    comb: process (r, rst, mr_rdt, rx_pf_frlen, rx_pf_empty, mt_rdt, tx_rf_strobe, tx_rf_tag_len_ptr, tx_pf_full,
                    info_rx_frames, info_rx_sofs, info_rx_ovfs, info_tx_frames, info_tx_bytes)
    variable v : registers_t;
    variable fin_len : wordpointer_t;
    begin
        v := r;

        -- set default values of combinatorial outputs
        mr_rstrobe <= '0';
        rx_rf_strobe <= '0';
        rx_pf_deq <= '0';
        mt_wdt <= (others => '0');
        mt_wstrobe <= '0';
        tx_pf_enq <= '0';
        tx_pf_tag_len_ptr <= (others => '0');


        case v.state is
            when IDLE =>
                if rx_pf_empty = '0' then
                    -- there is a new received frame;
                    v.frlen := unsigned(rx_pf_frlen);
                    v.cnt := unsigned(rx_pf_frlen);
                    v.rx_rptr := v.rx_rptr + 1;
                    mr_rstrobe <= '1';
                    v.state := RD_MAC_0;
                    v.tx_base := v.tx_wptr + 1;
                end if;

            when RD_MAC_0 =>
                -- at this point the first word of destination MAC has been read; remember it in the src_mac field
                v.src_mac(31 downto 0) := mr_rdt;
                v.rx_rptr := v.rx_rptr + 1;
                mr_rstrobe <= '1';
                v.state := RD_MAC_1;

            when RD_MAC_1 =>
                v.src_mac(47 downto 32) := mr_rdt(15 downto 0);
                v.dest_mac(15 downto 0) := mr_rdt(31 downto 16);
                v.rx_rptr := v.rx_rptr + 1;
                mr_rstrobe <= '1';
                v.state := RD_MAC_2;

            when RD_MAC_2 =>
                v.dest_mac(47 downto 16) := mr_rdt(31 downto 0);
                v.state := WR_MAC_0;

            when WR_MAC_0 =>
                mt_wdt <= v.dest_mac(31 downto 0);
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.state := WR_MAC_1;

            when WR_MAC_1 =>
                mt_wdt <= v.src_mac(15 downto 0) & v.dest_mac(47 downto 32);
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.state := WR_MAC_2;

            when WR_MAC_2 =>
                mt_wdt <= v.src_mac(47 downto 16);
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.rx_rptr := v.rx_rptr + 1;
                mr_rstrobe <= '1';
                v.state := COPY_ETHTYPE;

            when COPY_ETHTYPE =>
                -- copy word @ 0x03 
                mt_wdt <= mr_rdt;
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.state := WRT_INFO_0;

            when WRT_INFO_0 =>
                mt_wdt <= info_rx_frames;
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.state := WRT_INFO_1;

            when WRT_INFO_1 =>
                mt_wdt <= info_rx_sofs;
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.state := WRT_INFO_2;

            when WRT_INFO_2 =>
                mt_wdt <= info_rx_ovfs;
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.state := WRT_INFO_3;

            when WRT_INFO_3 =>
                mt_wdt <= info_tx_frames;
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                v.state := WRT_INFO_4;

            when WRT_INFO_4 =>
                mt_wdt <= info_tx_bytes;
                mt_wstrobe <= '1';
                v.tx_wptr := v.tx_wptr + 1;
                
                v.cnt := v.cnt - 9;             -- 9 words has been already written to the destination
                v.rx_rptr := v.rx_rptr + 6;
                if v.cnt /= 0 then
                    mr_rstrobe <= '1';
                end if;
                v.state := COPY_PAYLOAD;

            when COPY_PAYLOAD =>
                if v.cnt /= 0 then
                    mt_wdt <= mr_rdt;
                    mt_wstrobe <= '1';
                    v.tx_wptr := v.tx_wptr + 1;

                    v.cnt := v.cnt - 1;
                    if v.cnt /= 0 then
                        v.rx_rptr := v.rx_rptr + 1;
                        mr_rstrobe <= '1';
                    end if;
                else
                    v.state := DONE;
                end if;

            when DONE =>
                rx_rf_strobe <='1';         -- remove frame in rx buffer
                rx_pf_deq <= '1';           -- ack frame in rx buffer
                tx_pf_enq <= '1';           -- enqueue send frame
                tx_pf_tag_len_ptr(2*FRBUF_MEM_ADDR_W-1 downto FRBUF_MEM_ADDR_W) <= std_logic_vector(v.frlen);
                tx_pf_tag_len_ptr(FRBUF_MEM_ADDR_W-1 downto 0) <= std_logic_vector(v.tx_base);
                v.state := IDLE;

        end case;

        if tx_rf_strobe = '1' then
            -- a frame transmission has been finished
            fin_len := unsigned(tx_rf_tag_len_ptr(2*FRBUF_MEM_ADDR_W-1 downto FRBUF_MEM_ADDR_W));
            v.tx_bottom := v.tx_bottom + fin_len;
        end if;

        if rst = '1' then
            v.state := IDLE;
            v.rx_rptr := (others => '1');
            v.tx_wptr := (others => '1');
            v.tx_base := (others => '0');
            v.tx_bottom := (others => '0');
            v.dest_mac := (others => '0');
            v.src_mac := (others => '0');
            v.cnt := (others => '0');
        end if;

        mr_addr <= std_logic_vector(v.rx_rptr);
        mr_wdt <= (others => '0');
        mr_wstrobe <= '0';
        
        rx_rf_frlen <= std_logic_vector(r.frlen);

        mt_addr <= std_logic_vector(v.tx_wptr);
        mt_rstrobe <= '0';

        rin <= v;
    end process;

    ff: process (clk)
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;

end architecture ; -- rtl
