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
-- Filename:        rmii_tx_fixed.vhd
--
-- Version:         v1.01.a
-- Description:     Top level of RMII(reduced media independent interface)
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------
-- Include comments indicating reasons why packages are being used
-- Don't use ".all" - indicate which parts of the packages are used in the
-- "use" statement
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- include library containing the entities you're configuring
------------------------------------------------------------------------------

library mii_to_rmii_v2_0_8;

------------------------------------------------------------------------------
-- Port Declaration
------------------------------------------------------------------------------
-- Definition of Generics:
--          C_GEN1       -- description of generic, if description doesn't fit
--                       -- align with first part of description
--          C_GEN2       -- description of generic
--
-- Definition of Ports:
--          Port_name1   -- description of port, indicate source or destination
--          Port_name2   -- description of port
--
------------------------------------------------------------------------------

entity rmii_tx_fixed is
    generic (
            C_RESET_ACTIVE    : std_logic     :=  '0'
            );

    port    (
            Tx_speed_100      : in    std_logic;
            ------------------  System Signals  -------------------------------
            Sync_rst_n        : in    std_logic;
            Ref_Clk           : in    std_logic;
            ------------------  MII <--> RMII  --------------------------------
            Mac2Rmii_tx_en    : in    std_logic;
            Mac2Rmii_txd      : in    std_logic_vector(3  downto  0);
            Mac2Rmii_tx_er    : in    std_logic;
            Rmii2Mac_tx_clk   : out   std_logic;
            ------------------  RMII <--> PHY  --------------------------------
            Rmii2Phy_txd      : out   std_logic_vector(1  downto  0);
            Rmii2Phy_tx_en    : out   std_logic
            );
end rmii_tx_fixed;

------------------------------------------------------------------------------
-- Configurations
------------------------------------------------------------------------------
-- No Configurations

------------------------------------------------------------------------------
-- Architecture
------------------------------------------------------------------------------

architecture simulation of rmii_tx_fixed is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

------------------------------------------------------------------------------
-- Constant Declarations
------------------------------------------------------------------------------
-- Note that global constants and parameters (such as RESET_ACTIVE, default
-- values for address and data --widths, initialization values, etc.) should be
-- collected into a global package or include file.
-- Constants are all uppercase.
-- Constants or parameters should be used for all numeric values except for
-- single "0" or "1" values.
-- Constants should also be used when denoting a bit location within a register.
-- If no constants are required, simply state this in a comment below the file
-- section separation comments.
------------------------------------------------------------------------------
-- No Constants


------------------------------------------------------------------------------
-- Signal and Type Declarations
------------------------------------------------------------------------------

type   STATES_TYPE  is (
                       IDLE_CLK_L,
                       IDLE_CLK_H,
                       TX100_DIBIT_0_CLK_L,
                       TX100_DIBIT_1_CLK_H,
                       TX10_DIBIT_0_CLK_L0,
                       TX10_DIBIT_0_CLK_L1,
                       TX10_DIBIT_0_CLK_L2,
                       TX10_DIBIT_0_CLK_L3,
                       TX10_DIBIT_0_CLK_L4,
                       TX10_DIBIT_0_CLK_L5,
                       TX10_DIBIT_0_CLK_L6,
                       TX10_DIBIT_0_CLK_L7,
                       TX10_DIBIT_0_CLK_L8,
                       TX10_DIBIT_0_CLK_L9,
                       TX10_DIBIT_1_CLK_H0,
                       TX10_DIBIT_1_CLK_H1,
                       TX10_DIBIT_1_CLK_H2,
                       TX10_DIBIT_1_CLK_H3,
                       TX10_DIBIT_1_CLK_H4,
                       TX10_DIBIT_1_CLK_H5,
                       TX10_DIBIT_1_CLK_H6,
                       TX10_DIBIT_1_CLK_H7,
                       TX10_DIBIT_1_CLK_H8,
                       TX10_DIBIT_1_CLK_H9
                       );

signal  present_state     :  STATES_TYPE;
signal  next_state        :  STATES_TYPE;
signal  mac2Rmii_tx_en_d  :  std_logic;
signal  mac2Rmii_txd_d    :  std_logic_vector(3   downto   0);
signal  mac2Rmii_tx_er_d  :  std_logic;
signal  tx_in_reg_en      :  std_logic;
signal  txd_dibit         :  std_logic;
signal  txd_error         :  std_logic;

begin

------------------------------------------------------------------------------
-- TX_IN_REG_PROCESS
------------------------------------------------------------------------------

TX_IN_REG_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if (sync_rst_n = C_RESET_ACTIVE) then
            mac2Rmii_tx_en_d  <=  '0';
            mac2Rmii_txd_d    <=  (others => '0');
            mac2Rmii_tx_er_d  <=  '0';

        elsif (tx_in_reg_en = '1') then
            mac2Rmii_tx_en_d  <=  Mac2Rmii_tx_en;
            mac2Rmii_txd_d    <=  Mac2Rmii_txd;
            mac2Rmii_tx_er_d  <=  Mac2Rmii_tx_er;

        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- TX_OUT_REG_PROCESS
------------------------------------------------------------------------------

TX_OUT_REG_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then

        if (sync_rst_n = C_RESET_ACTIVE) then
            Rmii2Phy_txd(0)  <=  '0';
            Rmii2Phy_txd(1)  <=  '0';
            Rmii2Phy_tx_en   <=  '0';

        elsif (txd_dibit  = '0') then
            Rmii2Phy_txd(0)  <=  mac2Rmii_txd_d(0) xor txd_error;
            Rmii2Phy_txd(1)  <=  mac2Rmii_txd_d(1) or  txd_error;
            Rmii2Phy_tx_en   <=  mac2Rmii_tx_en_d;

        elsif (txd_dibit  = '1') then
            Rmii2Phy_txd(0)  <=  mac2Rmii_txd_d(2) xor txd_error;
            Rmii2Phy_txd(1)  <=  mac2Rmii_txd_d(3) or  txd_error;
            Rmii2Phy_tx_en   <=  mac2Rmii_tx_en_d;

        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- TX_CONTROL_SYNC_PROCESS
------------------------------------------------------------------------------

TX_CONTROL_SYNC_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then
        if (sync_rst_n = C_RESET_ACTIVE) then
            present_state  <=  IDLE_CLK_L;
        else
            present_state  <=  next_state;
        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- TX_CONTROL_NEXT_STATE_PROCESS
------------------------------------------------------------------------------

TX_CONTROL_NEXT_STATE_PROCESS : process (
                                        present_state,
                                        mac2Rmii_tx_er_d,
                                        Tx_speed_100
                                        )

begin
    case present_state is

       when IDLE_CLK_L  =>
           next_state       <=  IDLE_CLK_H;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '1';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when IDLE_CLK_H  =>
           if (Tx_speed_100 = '1') then
               next_state   <=  TX100_DIBIT_0_CLK_L;
           else
               next_state   <=  TX10_DIBIT_0_CLK_L0;
           end if;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX100_DIBIT_0_CLK_L  =>
           next_state       <=  TX100_DIBIT_1_CLK_H;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '1';
           txd_dibit        <=  '1';
           txd_error        <=  mac2Rmii_tx_er_d;

       when TX100_DIBIT_1_CLK_H  =>
           next_state       <=  TX100_DIBIT_0_CLK_L;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  mac2Rmii_tx_er_d;

       when TX10_DIBIT_0_CLK_L0  =>
           next_state       <=  TX10_DIBIT_0_CLK_L1;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L1  =>
           next_state       <=  TX10_DIBIT_0_CLK_L2;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L2  =>
           next_state       <=  TX10_DIBIT_0_CLK_L3;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L3  =>
           next_state       <=  TX10_DIBIT_0_CLK_L4;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L4  =>
           next_state       <=  TX10_DIBIT_0_CLK_L5;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L5  =>
           next_state       <=  TX10_DIBIT_0_CLK_L6;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L6  =>
           next_state       <=  TX10_DIBIT_0_CLK_L7;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L7  =>
           next_state       <=  TX10_DIBIT_0_CLK_L8;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L8  =>
           next_state       <=  TX10_DIBIT_0_CLK_L9;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_0_CLK_L9  =>
           next_state       <=  TX10_DIBIT_1_CLK_H0;
           Rmii2Mac_tx_clk  <=  '0';
           tx_in_reg_en     <=  '1';
           txd_dibit        <=  '1';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H0  =>
           next_state       <=  TX10_DIBIT_1_CLK_H1;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H1  =>
           next_state       <=  TX10_DIBIT_1_CLK_H2;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H2  =>
           next_state       <=  TX10_DIBIT_1_CLK_H3;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H3  =>
           next_state       <=  TX10_DIBIT_1_CLK_H4;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H4  =>
           next_state       <=  TX10_DIBIT_1_CLK_H5;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H5  =>
           next_state       <=  TX10_DIBIT_1_CLK_H6;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H6  =>
           next_state       <=  TX10_DIBIT_1_CLK_H7;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H7  =>
           next_state       <=  TX10_DIBIT_1_CLK_H8;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H8  =>
           next_state       <=  TX10_DIBIT_1_CLK_H9;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';

       when TX10_DIBIT_1_CLK_H9  =>
           next_state       <=  TX10_DIBIT_0_CLK_L0;
           Rmii2Mac_tx_clk  <=  '1';
           tx_in_reg_en     <=  '0';
           txd_dibit        <=  '0';
           txd_error        <=  '0';


    end case;
end process;

end simulation;
