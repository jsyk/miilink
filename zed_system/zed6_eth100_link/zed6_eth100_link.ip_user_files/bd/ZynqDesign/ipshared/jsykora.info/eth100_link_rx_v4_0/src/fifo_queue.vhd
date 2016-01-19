library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 
-- FIFO queue with configurable width and depth.
-- Single clock. Provides full/empty/level indicators.
-- 
entity fifo_queue is
generic (
    FIFO_DATA_W     : natural;                                      -- width of data held in the fifo
    FIFO_DEPTH_W    : natural                                       -- fifo depth is 2**FIFO_DEPTH_W elements
);
port (
    clk         : in std_logic;
    rst         : in std_logic;
    --
    enq_strobe  : in std_logic;                                     -- enqueue data command
    enq_data    : in std_logic_vector(FIFO_DATA_W-1 downto 0);      -- data to enqueue
    deq_strobe  : in std_logic;                                     -- dequeue data command
    deq_data    : out std_logic_vector(FIFO_DATA_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
    fifo_full   : out std_logic;                                    -- full fifo indication (must not enqueue more)
    fifo_empty  : out std_logic;                                    -- empty fifo indication (must not dequeue more)
    fifo_level  : out std_logic_vector(FIFO_DEPTH_W downto 0)       -- actual fill level
) ;
end entity ; -- fifo

architecture rtl of fifo_queue is

    subtype pointer_t is unsigned(FIFO_DEPTH_W-1 downto 0);

    subtype level_t is unsigned(FIFO_DEPTH_W downto 0);         -- one bit wider so that the integer 2**FIFO_DEPTH_W could be represented

    type mem_array_t is array (integer range <>) of std_logic_vector(FIFO_DATA_W-1 downto 0);

    type registers_t is record
        memory      : mem_array_t(0 to 2**FIFO_DEPTH_W-1);
        wptr        : pointer_t;
        rptr        : pointer_t;
        -- 
        deq_data    : std_logic_vector(FIFO_DATA_W-1 downto 0);     -- dequeued data; becomes valid 1T after deq_strobe
        fifo_full   : std_logic;                                    -- full fifo indication (must not enqueue more)
        fifo_empty  : std_logic;                                    -- empty fifo indication (must not dequeue more)
        fifo_level  : level_t;      -- actual fill level
    end record;

    signal r, rin : registers_t;

begin

    comb: process (r, rst, enq_strobe, enq_data, deq_strobe)
    variable v : registers_t;
    begin
        v := r;

        -- dequeue if there is a strobe and fifo is not empty
        if (deq_strobe = '1') and (v.fifo_empty = '0') then
            -- advance read pointer
            v.rptr := v.rptr + 1;
            -- decrease fill level
            v.fifo_level := v.fifo_level - 1;
        end if;

        -- get data that the read pointer is looking at
        v.deq_data := v.memory(to_integer(v.rptr));

        -- enqueue if there is a strobe and fifo is not full
        if (enq_strobe = '1') and (v.fifo_full = '0') then
            -- write to memory at wptr
            v.memory(to_integer(v.wptr)) := enq_data;
            -- consistency bypass: in case we're writing the memory location where rptr has just read
            if v.wptr = v.rptr then
                v.deq_data := enq_data;
            end if;

            -- move write pointer
            v.wptr := v.wptr + 1;
            -- increase fill level
            v.fifo_level := v.fifo_level + 1;
        end if;


        if v.fifo_level = 0 then
            v.fifo_empty := '1';
        else
            v.fifo_empty := '0';
        end if;

        -- if v.fifo_level = 2**FIFO_DEPTH_W then
        if v.fifo_level(FIFO_DEPTH_W) = '1' then
            v.fifo_full := '1';
        else
            v.fifo_full := '0';
        end if;

        if rst='1' then
            v.deq_data := (others => '0');
            v.fifo_full := '0';
            v.fifo_empty := '1';
            v.fifo_level := (others => '0');
            v.wptr := (others => '0');
            v.rptr := (others => '0');
        end if;

        rin <= v;
    end process;

    ff: process (clk)
    begin
        if rising_edge(clk) then
            r <= rin;
        end if;
    end process;

    deq_data <= r.deq_data;
    fifo_full <= r.fifo_full;
    fifo_empty <= r.fifo_empty;
    fifo_level <= std_logic_vector(r.fifo_level);

end architecture ; -- rtl
