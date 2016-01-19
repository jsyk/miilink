library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.etherlink_pkg.all;

-- 
-- IP top-level entity for 100M ethernet transmit path.
-- 
entity iptop_eth100_link_tx is
generic (
    FRBUF_MEMBYTE_ADDR_W : natural := 11;
    IGAP_LEN : natural := 6;                -- inter-frame gap in bytes
    TXFIFO_DEPTH_W    : natural := 4;       -- fifo depth is 2**FIFO_DEPTH_W elements
    FRTAG_W : natural := 0                  -- nr of bits for frame tag that is moved between fifos
);
port (
    -- RMII
    ref_clk     : in std_logic;         -- RMII ref_clk
    rmii_txen   : out std_logic;
    rmii_txdt   : out std_logic_vector(1 downto 0);
    --
    clk         : in std_logic;
    aresetn     : in std_logic;
    -- access to frame buffer memory
    m1_addr     : in std_logic_vector(FRBUF_MEMBYTE_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
    m1_wdt      : in std_logic_vector(31 downto 0);            -- buffer write data 
    m1_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m1_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    m1_rdt      : out std_logic_vector(31 downto 0);            -- buffer write data 
    --
    -- access to control registers "memory"
    mr_addr     : in std_logic_vector(7 downto 0);          -- register address, granularity 32b words
    mr_wdt      : in std_logic_vector(31 downto 0);            -- reg write data 
    mr_wstrobe  : in std_logic;                                -- strobe to write data into the buffer
    mr_rstrobe  : in std_logic;                                -- strobe to write data into the buffer
    mr_rdt      : out std_logic_vector(31 downto 0);           -- buffer write data 
    -- interupt request (frame transmitted) out, level
    irq         : out std_logic
) ;
end entity ; -- iptop_eth100_link_tx

architecture rtl of iptop_eth100_link_tx is

    constant FRBUF_MEM_ADDR_W : natural := FRBUF_MEMBYTE_ADDR_W - 2;
    constant M1_SUPPORT_READ : boolean := true;      -- whether port 2 is read-write (when true) or read-only (when false)
    constant M1_DELAY : natural := 1;                -- read delay: 2=insert register at inputs

    signal rst, rst1 : std_logic;
    signal rst_shift : std_logic_vector(7 downto 0);

    signal rf_strobe   : std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
    signal rf_tag_len_ptr : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
        -- to push-fifo queue of frames to transmit
    signal pf_enq      :  std_logic;                                     -- enqueue data command
    signal pf_tag_len_ptr : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);      -- encodes (tag,len,ptr)
    signal pf_full     :  std_logic;                                   -- full fifo indication (must not enqueue more)
        -- status info
    signal info_tx_frames :  std_logic_vector(31 downto 0);             -- number of sent frames
    signal info_tx_bytes :  std_logic_vector(31 downto 0);               -- number of sent bytes (incl. preamble bytes)

    -- register (tag,len,ptr) of the last processed frame
    signal r_rf_tag_len_ptr : std_logic_vector(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
    signal r_irq_en : std_logic;
    signal r_irq_st : std_logic;

begin
    linktx: eth100_link_tx
    generic map (
        FRBUF_MEM_ADDR_W, -- : natural := 9;
        IGAP_LEN,       -- : natural := 6;                -- inter-frame gap in bytes
        M1_SUPPORT_READ, -- : boolean := true;      -- whether port 2 is read-write (when true) or read-only (when false)
        M1_DELAY,       -- : natural := 2;                -- read delay: 2=insert register at inputs
        TXFIFO_DEPTH_W,  --  : natural := 4        -- fifo depth is 2**FIFO_DEPTH_W elements
        FRTAG_W         --: natural := 0                  -- nr of bits for frame tag that is moved between fifos
    )
    port map (
        -- RMII
        ref_clk, --     : in std_logic;         -- RMII ref_clk
        rmii_txen, --   : out std_logic;
        rmii_txdt, --   : out std_logic_vector(1 downto 0);
        --
        clk,         --: in std_logic;
        rst,         --: in std_logic;
        -- access to frame buffer memory
        m1_addr(FRBUF_MEMBYTE_ADDR_W-1 downto 2),    -- : in std_logic_vector(FRBUF_MEM_ADDR_W-1 downto 0);  -- buffer address, granularity 32b words
        m1_wdt,      --: in std_logic_vector(31 downto 0);            -- buffer write data 
        m1_wstrobe,  --: in std_logic;                                -- strobe to write data into the buffer
        m1_rstrobe,  --: in std_logic;                                -- strobe to write data into the buffer
        m1_rdt,      --: out std_logic_vector(31 downto 0);            -- buffer write data 
        --
        -- for removing processed (sent) frames by the tx-link
        rf_strobe,   --: out std_logic;                                  -- remove frame of lenght rf_frlen from the bottom of the circular buffer
        rf_tag_len_ptr,
        -- to push-fifo queue of frames to transmit
        pf_enq,      --: in std_logic;                                     -- enqueue data command
        pf_tag_len_ptr,
        pf_full,     --: out std_logic;                                   -- full fifo indication (must not enqueue more)
        -- status info
        info_tx_frames, --: out std_logic_vector(31 downto 0);             -- number of sent frames
        info_tx_bytes   --: out std_logic_vector(31 downto 0)               -- number of sent bytes (incl. preamble bytes)
    ) ;


    ff: process (clk)
    begin
        if rising_edge(clk) then
            -- generate reset
            rst1 <= not(aresetn);
            rst <= rst1;
            if rst_shift /= X"00" then
                rst <= '1';
            end if;
            rst_shift <= '0' & rst_shift(7 downto 1);
            if rst='1' then
                pf_tag_len_ptr <= (others => '0');
                r_rf_tag_len_ptr <= (others => '0');
                r_irq_en <= '0';
                r_irq_st <= '0';
            end if;

            mr_rdt <= (others => '0');
            pf_enq <= '0';

            if mr_rstrobe = '1' then
                if mr_addr = X"00" then
                    -- register X"0": Control/Status flags
                    -- bit 0 = RO: pf_full - send frame queue is full
                    -- bit 1 = R/W: irq_en
                    -- bit 2 = R/W: irq_st
                    -- bits 30:3 = unused
                    -- bit 31 = WO: reset
                    mr_rdt(0) <= pf_full;
                    mr_rdt(1) <= r_irq_en;
                    mr_rdt(2) <= r_irq_st;
                elsif mr_addr = X"04" then
                    -- register X"1": read the last processed (sent) frame
                    mr_rdt <= (others => '0');
                    --mr_rdt(FRBUF_MEM_ADDR_W-1 downto 0) <= std_logic_vector(bottom_ptr);
                    mr_rdt(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0) <= r_rf_tag_len_ptr;
                elsif mr_addr = X"10" then
                    mr_rdt <= info_tx_frames;
                elsif mr_addr = X"14" then
                    mr_rdt <= info_tx_bytes;
                end if;
            end if;

            if mr_wstrobe = '1' then
                if mr_addr = X"00" then
                    -- register X"0": Control/Status flags
                    if mr_wdt(31) = '1' then
                        -- bit 31 - write 1 to reset the core
                        rst_shift(7) <= '1';
                    end if;
                    r_irq_en <= mr_wdt(1);
                    r_irq_st <= mr_wdt(2);
                elsif mr_addr = X"04" then
                    -- register X"1": write to enqueue new frame length
                    pf_enq <= '1';
                    pf_tag_len_ptr <= mr_wdt(FRTAG_W+2*FRBUF_MEM_ADDR_W-1 downto 0);
                end if;
            end if;

            -- the core has finished sending a frame
            if rf_strobe='1' then
                -- catch the tag, length and ptr of the processed frame
                r_rf_tag_len_ptr <= rf_tag_len_ptr;
                r_irq_st <= r_irq_en;
            end if;
        end if;
    end process;

    irq <= r_irq_st;

end architecture ; -- rtl
