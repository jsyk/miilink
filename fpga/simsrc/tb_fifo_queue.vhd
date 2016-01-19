library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

entity tb_fifo_queue is
end entity ; -- tb_fifo_queue

architecture behav of tb_fifo_queue is

    constant FIFO_DATA_W : integer := 32;
    constant FIFO_DEPTH_W : integer := 2;

    signal        clk          :  std_logic;
    signal        rst          :  std_logic;
        --
    signal        enq_strobe  :  std_logic;                                     -- enqueue data command
    signal        enq_data    :  std_logic_vector(FIFO_DATA_W-1 downto 0);      -- data to enqueue
    signal        deq_strobe  :  std_logic;                                     -- dequeue data command
    signal        deq_data    :  std_logic_vector(FIFO_DATA_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    signal        fifo_full   :  std_logic;                                    -- full fifo indication (must not enqueue more)
    signal        fifo_empty  :  std_logic;                                    -- empty fifo indication (must not dequeue more)
    signal        fifo_level  :  std_logic_vector(FIFO_DEPTH_W downto 0);       -- actual fill level

    signal eos : boolean := false;

begin
    dut: fifo_queue
    generic map (
        FIFO_DATA_W,
        FIFO_DEPTH_W
    )
    port map (
        clk, --         : in std_logic;
        rst, --         : in std_logic;
        --
        enq_strobe, --  : in std_logic;                                     -- enqueue data command
        enq_data, --    : in std_logic_vector(FIFO_DATA_W-1 downto 0);      -- data to enqueue
        deq_strobe, --  : in std_logic;                                     -- dequeue data command
        deq_data, --    : out std_logic_vector(FIFO_DATA_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
        fifo_full, --   : out std_logic;                                    -- full fifo indication (must not enqueue more)
        fifo_empty, --  : out std_logic;                                    -- empty fifo indication (must not dequeue more)
        fifo_level  --: out std_logic_vector(FIFO_DEPTH_W downto 0)       -- actual fill level
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
        enq_strobe <= '0';
        enq_data <= (others => '0');
        deq_strobe <= '0';
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        --

        -- FIFO should be empty after reset
        assert fifo_empty = '1' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "000" severity failure;

        -- enqueue X"00001234"
        enq_data <= X"00001234";
        enq_strobe <= '1';
        wait for 10 ns;
        enq_strobe <= '0';

        -- check output data, not empty, not full
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "001" severity failure;
        assert deq_data = X"00001234" severity failure;

        wait for 10 ns;

        -- no change
        assert deq_data = X"00001234" severity failure;

        wait for 10 ns;

        -- enqueue X"00001235";
        enq_data <= X"00001235";
        enq_strobe <= '1';
        wait for 10 ns;
        enq_strobe <= '0';

        -- check fill level = 2
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "010" severity failure;
        assert deq_data = X"00001234" severity failure;

        -- enqueue X"00001236";
        enq_data <= X"00001236";
        enq_strobe <= '1';
        wait for 10 ns;
        enq_strobe <= '0';

        -- check fill level = 3
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "011" severity failure;
        assert deq_data = X"00001234" severity failure;

        -- enquue X"00001237";
        enq_data <= X"00001237";
        enq_strobe <= '1';
        wait for 10 ns;
        enq_strobe <= '0';

        -- check fill level = 4, full
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '1' severity failure;
        assert fifo_level = "100" severity failure;
        assert deq_data = X"00001234" severity failure;

        -- dequeue
        deq_strobe <= '1';
        wait for 10 ns;
        
        -- check fill level 3
        assert deq_data = X"00001235" severity failure;
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "011" severity failure;

        -- dequeu
        wait for 10 ns;

        -- stop dequeu
        deq_strobe <= '0';

        -- check fill level 2
        assert deq_data = X"00001236" severity failure;
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "010" severity failure;

        -- enqueue more
        enq_data <= X"000A1230";
        enq_strobe <= '1';
        wait for 10 ns;

        -- check fill level 3
        assert deq_data = X"00001236" severity failure;
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "011" severity failure;
        
        -- enqueue more
        enq_data <= X"000A1231";
        enq_strobe <= '1';
        wait for 10 ns;
        enq_strobe <= '0';

        -- check fill level 4
        assert deq_data = X"00001236" severity failure;
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '1' severity failure;
        assert fifo_level = "100" severity failure;

        -- dequeu
        deq_strobe <= '1';
        wait for 10 ns;
        
        -- check fill level 3
        assert deq_data = X"00001237" severity failure;
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "011" severity failure;

        -- enqueue and dequeu simultaneously
        enq_data <= X"000A1232";
        enq_strobe <= '1';
        deq_strobe <= '1';
        wait for 10 ns;

        enq_strobe <= '0';
        deq_strobe <= '0';

        -- check fill level 3
        assert deq_data = X"000A1230" severity failure;
        assert fifo_empty = '0' severity failure;
        assert fifo_full = '0' severity failure;
        assert fifo_level = "011" severity failure;


        eos <= true;
        wait;
    end process;

end architecture ; -- behav
