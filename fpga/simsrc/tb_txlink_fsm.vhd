library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_txlink_fsm is
end entity;

architecture behav of tb_txlink_fsm is

    constant MEM_ADDR_W : natural := 8;           -- buffer address width
    constant IGAP_LEN : natural := 6;            -- inter-frame gap in bytes
    constant FRTAG_W : natural := 0;              -- nr of bits for frame tag that is moved between fifos

    signal clk         : std_logic;
    signal rst         : std_logic;
        -- 
        -- TX byte stream to RMII
    signal t_dv        : std_logic;        -- kept high so long as we are transmitting a frame
    signal t_str_dt    : std_logic;        -- a pulse when t_dt is valid
    signal t_dt        : std_logic_vector(7 downto 0);      -- 1-byte transmit data, valid only during t_str_dt is active
        -- 
        -- push-frame fifo
    signal pf_empty    : std_logic;
    -- signal pf_frlen    : std_logic_vector(MEM_ADDR_W-1 downto 0);
    signal pf_tag_len_ptr : std_logic_vector(FRTAG_W+2*MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    signal pf_deq      : std_logic;
        --
        -- remove-frame output
    signal rf_strobe   : std_logic;
    -- signal rf_frlen    : std_logic_vector(MEM_ADDR_W-1 downto 0);
    signal rf_tag_len_ptr    : std_logic_vector(FRTAG_W+2*MEM_ADDR_W-1 downto 0);

        --
        -- memory interface, 2T read latency
    signal m_rstrobe   : std_logic;
    signal m_addr      : std_logic_vector(MEM_ADDR_W-1 downto 0);
    signal m_rdt, m_rdt1  : std_logic_vector(31 downto 0);

    signal rmii_txen        :  std_logic;
    signal rmii_txdt        :  std_logic_vector(1 downto 0);

    signal r_dv        :  std_logic;        -- kept high so long as we are receiving a frame
    signal r_str_dt    :  std_logic;        -- a pulse when r_dt is valid
    signal r_dt        :  std_logic_vector(7 downto 0);      -- 1-byte received data, valid only during r_str_dt is active

    signal eos : boolean := false;

    type ethframe_t is array (natural range <>) of std_logic_vector(7 downto 0);

    constant TEST_FRAME_1 : ethframe_t := 
    (
            -- X"55", X"55", X"55", X"55", X"55", X"55", X"55", X"D5", -- //start of frame
        X"00", X"0A", X"E6", X"F0", X"05", X"A3", 
        X"00", X"12", X"34", X"56", X"78", X"90", 
        X"08", X"00",        -- EtherType = IP
            --X"00", X"30",           -- EtherLen
        X"00", X"00",
        X"45", X"00", X"00", X"30", X"B3", X"FE", X"00", X"00", X"80", X"11", X"72", X"BA", X"0A", X"00", X"00", X"03", 
        X"0A", X"00", X"00", X"02", X"04", X"00", X"04", X"00", X"00", X"1C", X"89", X"4D", X"00", X"01", X"02", X"03", 
        X"04", X"05", X"06", X"07", X"08", X"09", X"0A", X"0B", X"0C", X"0D", X"0E", X"0F", X"10", X"11", X"12", X"13",
            X"7A", X"D5", X"6B", X"B3"  --//frame checksum (not correct, not part of the buffer)
    );

begin
    dut: txlink_fsm
    generic map (
        MEM_ADDR_W,  --: natural := 9           -- buffer address width
        IGAP_LEN,    --: natural := 6            -- inter-frame gap in bytes
        FRTAG_W
    )
    port map (
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        -- 
        -- TX byte stream to RMII
        t_dv, --        : out std_logic;        -- kept high so long as we are transmitting a frame
        t_str_dt, --    : out std_logic;        -- a pulse when t_dt is valid
        t_dt, --        : out std_logic_vector(7 downto 0);      -- 1-byte transmit data, valid only during t_str_dt is active
        -- 
        -- push-frame fifo
        pf_empty, --    : in std_logic;
        pf_tag_len_ptr,
        pf_deq, --      : out std_logic;
        --
        -- remove-frame output
        rf_strobe, --   : out std_logic;
        rf_tag_len_ptr,
        --
        -- memory interface, 2T read latency
        m_rstrobe, --   : out std_logic;
        m_addr, --      : out std_logic_vector(MEM_ADDR_W-1 downto 0);
        m_rdt      -- : in std_logic_vector(31 downto 0)
    ) ;

    mem: process (clk)
    begin
        if rising_edge(clk) then
            if m_rstrobe = '1' then
                m_rdt1 <= TEST_FRAME_1(4*to_integer(unsigned(m_addr)) + 3)
                        & TEST_FRAME_1(4*to_integer(unsigned(m_addr)) + 2)
                        & TEST_FRAME_1(4*to_integer(unsigned(m_addr)) + 1)
                        & TEST_FRAME_1(4*to_integer(unsigned(m_addr)) + 0);
            end if;
            m_rdt <= m_rdt1;
        end if;
    end process;

    rmii_txdut: bytestream_to_rmii
    port map (
        clk, --         : in std_logic;         -- RMII ref_clk
        rst, --         : in std_logic;
        -- RMII
        rmii_txen, --        : out std_logic;
        rmii_txdt, --        : out std_logic_vector(1 downto 0);
        -- internal byte stream
        t_dv, --        : in std_logic;        -- kept high so long as we are transmitting a frame
        t_str_dt, --    : in std_logic;        -- a pulse when t_dt is valid
        t_dt  --        : in std_logic_vector(7 downto 0)      -- 1-byte send data, valid only during r_str_dt is active
    );

    rmii_rxdut: rmii_to_bytestream
    port map (
        clk, --         : in std_logic;         -- RMII ref_clk
        -- RMII
        rmii_txen,      --  : in std_logic;
        rmii_txdt,      --  : in std_logic_vector(1 downto 0);
        -- internal byte stream
        r_dv,  --        : out std_logic;        -- kept high so long as we are receiving a frame
        r_str_dt, --    : out std_logic;        -- a pulse when r_dt is valid
        r_dt   --     : out std_logic_vector(7 downto 0)      -- 1-byte received data, valid only during r_str_dt is active
    ) ;

    clkgen: process
    begin
        if eos then wait; end if;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;


    tb: process
    begin
        rst <= '1';
        pf_empty <= '1';
        pf_tag_len_ptr <= (others => '0');
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        rst <= '0';
        wait until rising_edge(clk);

        wait until rising_edge(clk);
        -- do not include the FCS in the frame constant buffer
        pf_tag_len_ptr(2*MEM_ADDR_W-1 downto MEM_ADDR_W) <= 
                std_logic_vector(to_unsigned((TEST_FRAME_1'high+1-4) / 4, MEM_ADDR_W));
        pf_empty <= '0';

        wait until rising_edge(clk) and (rf_strobe = '1');
        pf_empty <= '1';

        wait until rising_edge(clk) and (t_dv = '0');

        wait for 100 ns;
        eos <= true;
        wait;
    end process;
end architecture behav;
