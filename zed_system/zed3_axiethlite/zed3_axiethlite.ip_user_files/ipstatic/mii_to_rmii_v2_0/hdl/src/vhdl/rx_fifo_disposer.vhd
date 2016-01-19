-----------------------------------------------------------------------
    -- (c) Copyright 1984 - 2012 Xilinx, Inc. All rights reserved.
    --
    -- This file contains confidential and proprietary information
    -- of Xilinx, Inc. and is protected under U.S. and
    -- international copyright and other intellectual property
    -- laws.
    --
    -- DISCLAIMER
    -- This disclaimer is not a license and does not grant any
    -- rights to the materials distributed herewith. Except as
    -- otherwise provided in a valid license issued to you by
    -- Xilinx, and to the maximum extent permitted by applicable
    -- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    -- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
    -- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
    -- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    -- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    -- (2) Xilinx shall not be liable (whether in contract or tort,
    -- including negligence, or under any other theory of
    -- liability) for any loss or damage of any kind or nature
    -- related to, arising under or in connection with these
    -- materials, including for any direct, or any indirect,
    -- special, incidental, or consequential loss or damage
    -- (including loss of data, profits, goodwill, or any type of
    -- loss or damage suffered as a result of any action brought
    -- by a third party) even if such damage or loss was
    -- reasonably foreseeable or Xilinx had been advised of the
    -- possibility of the same.
    --
    -- CRITICAL APPLICATIONS
    -- Xilinx products are not designed or intended to be fail-
    -- safe, or for use in any application requiring fail-safe
    -- performance, such as life-support or safety devices or
    -- systems, Class III medical devices, nuclear facilities,
    -- applications related to the deployment of airbags, or any
    -- other applications that could lead to death, personal
    -- injury, or severe property or environmental damage
    -- (individually and collectively, "Critical
    -- Applications"). Customer assumes the sole risk and
    -- liability of any use of Xilinx products in Critical
    -- Applications, subject only to applicable laws and
    -- regulations governing limitations on product liability.
    --
    -- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    -- PART OF THIS FILE AT ALL TIMES.
-----------------------------------------------------------------------
-- Filename:        rx_fifo_disposer.vhd
--
-- Version:         v1.01.a
-- Description:     This
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library mii_to_rmii_v2_0_8;

------------------------------------------------------------------------------
-- Include comments indicating reasons why packages are being used
-- Don't use ".all" - indicate which parts of the packages are used in the
-- "use" statement
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Port Declaration
------------------------------------------------------------------------------

entity rx_fifo_disposer is
    generic (
            C_RESET_ACTIVE    :  std_logic
            );

    port    (
            Sync_rst_n        :  in   std_logic;
            Ref_Clk           :  in   std_logic;
            Rx_10             :  in   std_logic;
            Rx_100            :  in   std_logic;
            Rmii_rx_eop       :  in   std_logic_vector(1  downto  0);
            Rmii_rx_crs       :  in   std_logic_vector(1  downto  0);
            Rmii_rx_er        :  in   std_logic_vector(1  downto  0);
            Rmii_rx_dv        :  in   std_logic_vector(1  downto  0);
            Rmii_rx_data      :  in   std_logic_vector(7  downto  0);
            Rx_fifo_mt_n      :  in   std_logic;
            Rx_fifo_rd_en     :  out  std_logic;
            Rmii2mac_crs      :  out  std_logic;
            Rmii2mac_rx_clk   :  out  std_logic;
            Rmii2mac_rx_er    :  out  std_logic;
            Rmii2mac_rx_dv    :  out  std_logic;
            Rmii2mac_rxd      :  out  std_logic_vector(3  downto  0)
            );
end rx_fifo_disposer;

------------------------------------------------------------------------------
-- Definition of Generics:
--          C_RESET_ACTIVE  -- Assertion level for Reset signal.
--
-- Definition of Ports:
--
------------------------------------------------------------------------------

architecture simulation of rx_fifo_disposer is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

------------------------------------------------------------------------------
-- Signal and Type Declarations
------------------------------------------------------------------------------
-- Signal names begin with a lowercase letter. User defined types and the
-- enumerated values with a type are all uppercase letters.
-- Signals of a user-defined type should be declared after the type declaration
-- Group signals by interfaces
------------------------------------------------------------------------------

type   STATES_TYPE   is  (
                         IDLE_ClK_L,
                         IDLE_ClK_H,
                         RX_100_RD_FIFO_ClK_L,
                         RX_100_NIB_0_CLK_L,
                         RX_100_NIB_0_CLK_H,
                         RX_100_NIB_1_CLK_L,
                         RX_100_NIB_1_CLK_H,
                         RX_100_NIB_1_RD_FIFO_CLK_H,
                         RX_10_RD_FIFO_CLK_L,
                         RX_10_NIB_0_00_CLK_L,
                         RX_10_NIB_0_01_CLK_L,
                         RX_10_NIB_0_02_CLK_L,
                         RX_10_NIB_0_03_CLK_L,
                         RX_10_NIB_0_04_CLK_L,
                         RX_10_NIB_0_05_CLK_L,
                         RX_10_NIB_0_06_CLK_L,
                         RX_10_NIB_0_07_CLK_L,
                         RX_10_NIB_0_08_CLK_L,
                         RX_10_NIB_0_09_CLK_L,
                         RX_10_NIB_0_00_CLK_H,
                         RX_10_NIB_0_01_CLK_H,
                         RX_10_NIB_0_02_CLK_H,
                         RX_10_NIB_0_03_CLK_H,
                         RX_10_NIB_0_04_CLK_H,
                         RX_10_NIB_0_05_CLK_H,
                         RX_10_NIB_0_06_CLK_H,
                         RX_10_NIB_0_07_CLK_H,
                         RX_10_NIB_0_08_CLK_H,
                         RX_10_NIB_0_09_CLK_H,
                         RX_10_NIB_1_00_CLK_L,
                         RX_10_NIB_1_01_CLK_L,
                         RX_10_NIB_1_02_CLK_L,
                         RX_10_NIB_1_03_CLK_L,
                         RX_10_NIB_1_04_CLK_L,
                         RX_10_NIB_1_05_CLK_L,
                         RX_10_NIB_1_06_CLK_L,
                         RX_10_NIB_1_07_CLK_L,
                         RX_10_NIB_1_08_CLK_L,
                         RX_10_NIB_1_09_CLK_L,
                         RX_10_NIB_1_00_CLK_H,
                         RX_10_NIB_1_01_CLK_H,
                         RX_10_NIB_1_02_CLK_H,
                         RX_10_NIB_1_03_CLK_H,
                         RX_10_NIB_1_04_CLK_H,
                         RX_10_NIB_1_05_CLK_H,
                         RX_10_NIB_1_06_CLK_H,
                         RX_10_NIB_1_07_CLK_H,
                         RX_10_NIB_1_08_CLK_H,
                         RX_10_NIB_1_09_CLK_H,
                         RX_10_NIB_1_09_RD_FIFO_CLK_H
                         );

signal  present_state    :  STATES_TYPE;
signal  next_state       :  STATES_TYPE;

begin

------------------------------------------------------------------------------
-- Concurrent Signal Assignments
------------------------------------------------------------------------------
-- No Concurrent Signal Assignments

------------------------------------------------------------------------------
-- State Machine SYNC_PROCESS
------------------------------------------------------------------------------
-- Include comments about the function of the process
------------------------------------------------------------------------------

SYNC_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if (sync_rst_n = C_RESET_ACTIVE) then
            present_state  <=  IDLE_ClK_L;
        else
            present_state  <=  next_state;
        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- State Machine NEXT_STATE_PROCESS
------------------------------------------------------------------------------

NEXT_STATE_PROCESS : process (
                             present_state,
                             Rx_100,
                             Rx_10,
                             RMII_rx_EOP,
                             Rmii_rx_er,
                             Rmii_rx_crs,
                             Rmii_rx_dv,
                             Rmii_rx_data,
			     Rx_fifo_mt_n--new addition of signal
                             )

begin
    case present_state is

        when  IDLE_ClK_L  =>
            if (Rx_100 = '1') then
                next_state  <=  RX_100_RD_FIFO_ClK_L;
            elsif (Rx_10 = '1') then
                next_state  <=  RX_10_RD_FIFO_CLK_L;
            else
                next_state  <=  IDLE_ClK_H;
            end if;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  '0';
            Rmii2mac_crs     <=  '0';
            Rmii2mac_rx_dv   <=  '0';
            Rmii2mac_rxd     <=  (others => '0');

        when  IDLE_ClK_H  =>
            if (Rx_10 = '1') then
                next_state  <=  RX_10_RD_FIFO_CLK_L;
            else
                next_state  <=  IDLE_ClK_L;
            end if;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  '0';
            Rmii2mac_crs     <=  '0';
            Rmii2mac_rx_dv   <=  '0';
            Rmii2mac_rxd     <=  (others => '0');

        when  RX_100_RD_FIFO_ClK_L  =>
            next_state       <=  RX_100_NIB_0_CLK_L;
            Rx_fifo_rd_en    <=  '1';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  '0';
            Rmii2mac_crs     <=  '0';
            Rmii2mac_rx_dv   <=  '0';
            Rmii2mac_rxd     <=  (others => '0');

        when  RX_100_NIB_0_CLK_L  =>
            next_state       <=  RX_100_NIB_0_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_100_NIB_0_CLK_H  =>
            next_state       <=  RX_100_NIB_1_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_100_NIB_1_CLK_L  =>
            if ((RMII_rx_EOP(0) = '1') or (RMII_rx_EOP(1) = '1')) then
                next_state  <=  RX_100_NIB_1_CLK_H;
            else
                next_state  <=  RX_100_NIB_1_RD_FIFO_CLK_H;
            end if;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_100_NIB_1_CLK_H  =>
            next_state       <=  IDLE_ClK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_100_NIB_1_RD_FIFO_CLK_H  =>
            next_state       <=  RX_100_NIB_0_CLK_L;
            Rx_fifo_rd_en    <=  '1';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_RD_FIFO_CLK_L  =>
            next_state       <=  RX_10_NIB_0_00_CLK_L;
            Rx_fifo_rd_en    <=  '1';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  '0';
            Rmii2mac_crs     <=  '0';
            Rmii2mac_rx_dv   <=  '0';
            Rmii2mac_rxd     <=  (others => '0');

        when  RX_10_NIB_0_00_CLK_L  =>
            next_state       <=  RX_10_NIB_0_01_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_01_CLK_L  =>
            next_state       <=  RX_10_NIB_0_02_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_02_CLK_L  =>
            next_state       <=  RX_10_NIB_0_03_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_03_CLK_L  =>
            next_state       <=  RX_10_NIB_0_04_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_04_CLK_L  =>
            next_state       <=  RX_10_NIB_0_05_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_05_CLK_L  =>
            next_state       <=  RX_10_NIB_0_06_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_06_CLK_L  =>
            next_state       <=  RX_10_NIB_0_07_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_07_CLK_L  =>
            next_state       <=  RX_10_NIB_0_08_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_08_CLK_L  =>
            next_state       <=  RX_10_NIB_0_09_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_09_CLK_L  =>
            next_state       <=  RX_10_NIB_0_00_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_00_CLK_H  =>
            next_state       <=  RX_10_NIB_0_01_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_01_CLK_H  =>
            next_state       <=  RX_10_NIB_0_02_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_02_CLK_H  =>
            next_state       <=  RX_10_NIB_0_03_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_03_CLK_H  =>
            next_state       <=  RX_10_NIB_0_04_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_04_CLK_H  =>
            next_state       <=  RX_10_NIB_0_05_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_05_CLK_H  =>
            next_state       <=  RX_10_NIB_0_06_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_06_CLK_H  =>
            next_state       <=  RX_10_NIB_0_07_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_07_CLK_H  =>
            next_state       <=  RX_10_NIB_0_08_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_08_CLK_H  =>
            next_state       <=  RX_10_NIB_0_09_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_0_09_CLK_H  =>
            next_state       <=  RX_10_NIB_1_00_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(0);
            Rmii2mac_crs     <=  Rmii_rx_crs(0);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(3 downto 0);

        when  RX_10_NIB_1_00_CLK_L  =>
            next_state       <=  RX_10_NIB_1_01_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_01_CLK_L  =>
            next_state       <=  RX_10_NIB_1_02_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_02_CLK_L  =>
            next_state       <=  RX_10_NIB_1_03_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_03_CLK_L  =>
            next_state       <=  RX_10_NIB_1_04_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_04_CLK_L  =>
            next_state       <=  RX_10_NIB_1_05_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_05_CLK_L  =>
            next_state       <=  RX_10_NIB_1_06_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_06_CLK_L  =>
            next_state       <=  RX_10_NIB_1_07_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_07_CLK_L  =>
            next_state       <=  RX_10_NIB_1_08_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_08_CLK_L  =>
            next_state       <=  RX_10_NIB_1_09_CLK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_09_CLK_L  =>
            next_state       <=  RX_10_NIB_1_00_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '0';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);


        when  RX_10_NIB_1_00_CLK_H  =>
            next_state       <=  RX_10_NIB_1_01_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_01_CLK_H  =>
            next_state       <=  RX_10_NIB_1_02_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_02_CLK_H  =>
            next_state       <=  RX_10_NIB_1_03_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_03_CLK_H  =>
            next_state       <=  RX_10_NIB_1_04_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_04_CLK_H  =>
            next_state       <=  RX_10_NIB_1_05_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_05_CLK_H  =>
            next_state       <=  RX_10_NIB_1_06_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_06_CLK_H  =>
            next_state       <=  RX_10_NIB_1_07_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_07_CLK_H  =>
            next_state       <=  RX_10_NIB_1_08_CLK_H;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_08_CLK_H  =>
            if ((RMII_rx_EOP(0) = '1') or (RMII_rx_EOP(1) = '1') or (Rx_fifo_mt_n = '0')) then
                next_state  <=  RX_10_NIB_1_09_CLK_H;
            else
                next_state  <=  RX_10_NIB_1_09_RD_FIFO_CLK_H;
            end if;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_09_CLK_H  =>
            next_state       <=  IDLE_ClK_L;
            Rx_fifo_rd_en    <=  '0';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

        when  RX_10_NIB_1_09_RD_FIFO_CLK_H  =>
            next_state       <=  RX_10_NIB_0_00_CLK_L;
            Rx_fifo_rd_en    <=  '1';
            Rmii2Mac_rx_clk  <=  '1';
            Rmii2mac_rx_er   <=  Rmii_rx_er(1);
            Rmii2mac_crs     <=  Rmii_rx_crs(1);
            Rmii2mac_rx_dv   <=  '1';
            Rmii2mac_rxd     <=  Rmii_rx_data(7 downto 4);

    end case;
end process;

end simulation;
