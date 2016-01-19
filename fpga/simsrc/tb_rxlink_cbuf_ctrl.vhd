library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_rxlink_cbuf_ctrl is
end entity ; -- tb_rxlink_cbuf_ctrl

architecture behav of tb_rxlink_cbuf_ctrl is

    constant MEM_ADDR_W : natural := 8;           -- buffer address width

    signal clk         :  std_logic;
    signal rst         :  std_logic;
    -- 
    -- interface to rxlink FSM
    signal b_restart   :  std_logic;        -- open new buffer
    signal b_enq       :  std_logic;        -- enqueu byte to buffer
    signal b_dt        :  std_logic_vector(7 downto 0);     -- data to enqueue
    signal b_commit    :  std_logic;        -- commit buffer & close
    signal b_overflowed : std_logic;      -- buffer enque has caused overflow (must cancel buffer and discard frame)
    -- 
    -- to buffer memory
    signal m_addr      :  std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    signal m_wdt       :  std_logic_vector(31 downto 0);            -- buffer write data 
    signal m_wstrobe   :  std_logic;                                -- strobe to write data into the buffer
    -- 
    -- to push-fifo queue
    signal pf_enq      :  std_logic;                        -- enqueue to the push-fifo
    signal pf_frlen    :  std_logic_vector(MEM_ADDR_W-1 downto 0);     -- data to enqueue: received frame length
    signal pf_full     :  std_logic;                         -- feedback that push-fifo is full and cannot accept input
    -- 
    -- to remove-fifo queue
    signal rf_strobe   :  std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rf_frlen    :  std_logic_vector(MEM_ADDR_W-1 downto 0);      -- remove length

    signal eos : boolean := false;

begin
    dut: rxlink_cbuf_ctrl
    generic map (
        MEM_ADDR_W  -- : natural := 9           -- buffer address width
    )
    port map (
        clk,          --: in std_logic;
        rst,         --: in std_logic;
        -- 
        -- interface to rxlink FSM
        b_restart,   --: in std_logic;        -- open new buffer
        b_enq,       --: in std_logic;        -- enqueu byte to buffer
        b_dt,        --: in std_logic_vector(7 downto 0);     -- data to enqueue
        b_commit,    --: in std_logic;        -- commit buffer & close
        b_overflowed, --: out std_logic;      -- buffer enque has caused overflow (must cancel buffer and discard frame)
        -- 
        -- to buffer memory
        m_addr,      --: out std_logic_vector(MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m_wdt,       --: out std_logic_vector(31 downto 0);            -- buffer write data 
        m_wstrobe,   --: out std_logic;                                -- strobe to write data into the buffer
        -- 
        -- to push-fifo queue
        pf_enq,      --: out std_logic;                        -- enqueue to the push-fifo
        pf_frlen,    --: out std_logic_vector(8 downto 0);     -- data to enqueue: received frame length
        pf_full,     --: in std_logic;                         -- feedback that push-fifo is full and cannot accept input
        -- 
        -- to remove-fifo queue
        rf_strobe,
        rf_frlen    --: in std_logic_vector(8 downto 0);      -- dequeued data
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
        b_restart <= '0';
        b_enq <= '0';
        b_dt <= X"00";
        b_commit <= '0';
        pf_full <= '0';
        rf_frlen <= X"00";
        rf_strobe <= '0';
        wait for 10 ns;
        rst <= '0';

        -- idle state
        assert m_wstrobe = '0' severity failure;
        assert pf_enq = '0' severity failure;

        -- restart
        b_restart <= '1';
        wait for 10 ns;
        b_restart <= '0';

        -- insert some bytes
        b_enq <= '1';
        b_dt <= X"01";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"02";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"03";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"04";
        wait for 10 ns;

        assert m_wstrobe = '1' severity failure;
        assert m_wdt = X"04030201" severity failure;
        assert m_addr = X"00" severity failure;

        b_dt <= X"05";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"06";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"07";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"08";
        wait for 10 ns;

        assert m_wstrobe = '1' severity failure;
        assert m_wdt = X"08070605" severity failure;
        assert m_addr = X"01" severity failure;

        b_enq <= '0';
        b_commit <= '1';
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;
        assert pf_enq = '1' severity failure;
        assert pf_frlen = X"02" severity failure;

        b_commit <= '0';
        b_restart <= '1';
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;
        assert pf_enq = '0' severity failure;


        b_restart <= '0';
        b_enq <= '1';

        b_dt <= X"09";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"0A";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"0B";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"0C";
        wait for 10 ns;

        assert m_wstrobe = '1' severity failure;
        assert m_wdt = X"0C0B0A09" severity failure;
        assert m_addr = X"02" severity failure;

        b_enq <= '0';
        b_commit <= '1';
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;
        assert pf_enq = '1' severity failure;
        assert pf_frlen = X"01" severity failure;

        b_commit <= '0';
        b_restart <= '1';
        wait for 10 ns;


        -- insert 100 words
        b_restart <= '0';
        b_enq <= '1';
        for i in 0 to 99 loop
            b_dt <= X"10";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"11";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"12";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"13";
            wait for 10 ns;

            assert m_wstrobe = '1' severity failure;
            assert m_wdt = X"13121110" severity failure;
            assert m_addr = std_logic_vector(to_unsigned(3+i, 8)) severity failure;
        end loop;

        b_enq <= '0';
        b_commit <= '1';
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;
        assert pf_enq = '1' severity failure;
        assert pf_frlen = X"64" severity failure;

        b_commit <= '0';
        b_restart <= '1';
        wait for 10 ns;


        -- insert 152 words - fill buffer completely
        b_restart <= '0';
        b_enq <= '1';
        for i in 0 to 151 loop
            b_dt <= X"10";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"11";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"12";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"13";
            wait for 10 ns;

            assert b_overflowed = '0' severity failure;
            assert m_wstrobe = '1' severity failure;
            assert m_wdt = X"13121110" severity failure;
            assert m_addr = std_logic_vector(to_unsigned(103+i, 8)) severity failure;
        end loop;

        -- overflow the buffer
        b_dt <= X"10";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"11";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"12";
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;

        b_dt <= X"13";
        wait for 10 ns;

        assert b_overflowed = '1' severity failure;
        assert m_wstrobe = '0' severity failure;

        -- commit should be ineffective because we overflowed
        b_enq <= '0';
        b_commit <= '1';
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;
        -- no pf_enq because we overflowed!
        assert pf_enq = '0' severity failure;
        

        b_commit <= '0';
        b_restart <= '1';
        wait for 10 ns;

        assert b_overflowed = '0' severity failure;

        b_restart <= '0';

        -- remove 5 words from the buffer
        rf_frlen <= X"05";
        rf_strobe <= '1';
        wait for 10 ns;

        rf_strobe <= '0';
        
        wait for 10 ns;



        -- insert 157 words - fill buffer completely
        b_restart <= '0';
        b_enq <= '1';
        for i in 0 to 156 loop
            b_dt <= X"10";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"11";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"12";
            wait for 10 ns;

            assert m_wstrobe = '0' severity failure;

            b_dt <= X"13";
            wait for 10 ns;

            assert b_overflowed = '0' severity failure;
            assert m_wstrobe = '1' severity failure;
            assert m_wdt = X"13121110" severity failure;
            assert m_addr = std_logic_vector(to_unsigned(103+i, 8)) severity failure;
        end loop;

        b_enq <= '0';
        b_commit <= '1';
        wait for 10 ns;

        assert m_wstrobe = '0' severity failure;
        assert pf_enq = '1' severity failure;
        assert pf_frlen = X"9D" severity failure;

        b_commit <= '0';
        b_restart <= '1';
        wait for 10 ns;



        -- epilog
        b_commit <= '0';
        b_enq <= '0';
        wait for 100 ns;
        eos <= true;
        wait;
    end process;

end architecture ; -- behav
