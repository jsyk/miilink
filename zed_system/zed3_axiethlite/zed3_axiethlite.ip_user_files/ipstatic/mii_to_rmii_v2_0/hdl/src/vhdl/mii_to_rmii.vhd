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

-- @BEGIN_CHANGELOG EDK_Im_SP1
-- Updated Release For V5 Porting
-- @END_CHANGELOG
------------------------------------------------------------------------------
-- Filename:        mii_to_rmii.vhd
--
-- Version:         v1.01.a
-- Description:     Top level of RMII(reduced media independent interface)
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------
-- include library containing the entities you're configuring
------------------------------------------------------------------------------

library mii_to_rmii_v2_0_8;
use mii_to_rmii_v2_0_8.all;

------------------------------------------------------------------------------
-- Port Declaration
------------------------------------------------------------------------------
-- Definition of Generics:
--          C_INSTANCE      -- Instance name in the system.
--          C_FIXED_SPEED   -- selects a fixed data throughput or agile RX
--                          -- side, TX side is will be fixed either way
--          C_SPEED_100     -- selects speed for TX, RX if C_FIXED_SPEED is
--                          -- selected
--
-- Definition of Ports:
--          rst_n           -- active low reset
--          ref_clk         -- clk, must be 50 MHz
--          mac2rmii_tx_en  -- active high transmit enable, valid txd
--          mac2rmii_txd    -- 4 bits of tx data from MAC
--          mac2rmii_tx_er  -- active high tx error indicator
--          rmii2mac_tx_clk -- 25 or 2.5 MHz clock to MAC
--          rmii2mac_rx_clk -- 25 or 2.5 MHz clock to MAC
--          rmii2mac_col    -- active high colision indicator
--          rmii2mac_crs    -- active high carrier sense
--          rmii2mac_rx_dv  -- active high rx data valid
--          rmii2mac_rx_er  -- acitve high rx error indicator
--          rmii2mac_rxd    -- 4 bits of rx data to MAC
--          phy2rmii_crs_dv -- active high carrier sense / data valid to rmii
--          phy2rmii_rx_er  -- active high rx error indicator
--          phy2rmii_rxd    -- 2 bits of rx data to rmii
--          rmii2phy_txd    -- 2 bits of tx data to phy
--          rmii2phy_tx_en  -- active high tx enable, valid tx to phy
--
------------------------------------------------------------------------------

entity mii_to_rmii is
    generic (
             C_INSTANCE        :  string        :=  "mii_to_rmii_inst";
             C_FIXED_SPEED     :  std_logic     :=  '1';
             C_SPEED_100       :  std_logic     :=  '1'
            );

    port    (
             ------------------  System Signals  ----------------------
             rst_n             : in    std_logic;
             ref_clk           : in    std_logic;
             ------------------  Speed Setting  -----------------------
             --Tx_speed_100      : in    std_logic;      -- add if ever
             --Rx_speed_100      : in    std_logic;      -- auto speed
             ------------------  MAC <--> RMII  -----------------------
             mac2rmii_tx_en    : in    std_logic;
             mac2rmii_txd      : in    std_logic_vector(3  downto  0);
             mac2rmii_tx_er    : in    std_logic;
             rmii2mac_tx_clk   : out   std_logic;
             rmii2mac_rx_clk   : out   std_logic;
             rmii2mac_col      : out   std_logic;
             rmii2mac_crs      : out   std_logic;
             rmii2mac_rx_dv    : out   std_logic;
             rmii2mac_rx_er    : out   std_logic;
             rmii2mac_rxd      : out   std_logic_vector(3  downto  0);
             ------------------  RMII <--> PHY  -----------------------
             phy2rmii_crs_dv   : in    std_logic;
             phy2rmii_rx_er    : in    std_logic;
             phy2rmii_rxd      : in    std_logic_vector(1  downto  0);
             rmii2phy_txd      : out   std_logic_vector(1  downto  0);
             rmii2phy_tx_en    : out   std_logic
            );

    attribute  HDL           :    string;
    attribute  IMP_NETLIST   :    string;
    attribute  IPTYPE        :    string;
    attribute  IP_GROUP      :    string;
    attribute  SIGIS         :    string;
    attribute  STYLE         :    string;
    attribute  XRANGE        :    string;
    attribute  HDL           of   mii_to_rmii:entity     is  "VHDL";
    attribute  IMP_NETLIST   of   mii_to_rmii:entity     is  "TRUE";
    attribute  IPTYPE        of   mii_to_rmii:entity     is  "IP";
    attribute  IP_GROUP      of   mii_to_rmii:entity     is  "LOGICORE";
    attribute  SIGIS         of   ref_clk:signal         is  "CLK";
   -- attribute  SIGIS         of   rmii2mac_tx_clk:signal is  "CLK";
   -- attribute  SIGIS         of   rmii2mac_rx_clk:signal is  "CLK";
    attribute  SIGIS         of   rst_n:signal           is  "RST";
    attribute  STYLE         of   mii_to_rmii:entity     is  "HDL";
    attribute  XRANGE        of   C_FIXED_SPEED:constant is  "('0':'1')";
    attribute  XRANGE        of   C_SPEED_100:constant   is  "('0':'1')";

end mii_to_rmii;

------------------------------------------------------------------------------
-- Configurations
------------------------------------------------------------------------------

-- No Configurations

------------------------------------------------------------------------------
-- Architecture
------------------------------------------------------------------------------

architecture simulation of mii_to_rmii is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

function chr(sl: std_logic) return character is
    variable c: character;
    begin
      case sl is
         when 'U' => c:= 'U';
         when 'X' => c:= 'X';
         when '0' => c:= '0';
         when '1' => c:= '1';
         when 'Z' => c:= 'Z';
         when 'W' => c:= 'W';
         when 'L' => c:= 'L';
         when 'H' => c:= 'H';
         when '-' => c:= '-';
      end case;
    return c;
   end chr;


function str(sl: std_logic) return string is
    variable s: string(1 to 1);
    begin
        s(1) := chr(sl);
        return s;
   end str;



  constant C_CORE_GENERATION_INFO : string := C_INSTANCE & ",mii_to_rmii,{" 
                & "c_instance = "     & C_INSTANCE 
                & ",c_fixed_speed = " & str(C_FIXED_SPEED) 
		& ",c_speed_100 = "   & str(C_SPEED_100)
		& "}";

  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of simulation : architecture is C_CORE_GENERATION_INFO;
		
------------------------------------------------------------------------------
-- Constant Declarations
------------------------------------------------------------------------------

constant  RESET_ACTIVE      :  std_logic    := '0';

------------------------------------------------------------------------------
-- Signal and Type Declarations
------------------------------------------------------------------------------

signal  tx_speed_100_i      :   std_logic;
signal  rx_speed_100_i      :   std_logic;
signal  sync_rst_n          :   std_logic;
signal  rst_n_d             :   std_logic_vector(1   downto   0);
signal  mac2Rmii_tx_en_d2   :   std_logic;
signal  mac2Rmii_tx_en_d1   :   std_logic;
signal  mac2Rmii_txd_d2     :   std_logic_vector(3   downto   0);
signal  mac2Rmii_txd_d1     :   std_logic_vector(3   downto   0);
signal  mac2Rmii_tx_er_d2   :   std_logic;
signal  mac2Rmii_tx_er_d1   :   std_logic;
signal  rmii2Mac_tx_clk_i   :   std_logic;
signal  rmii2Mac_rx_clk_i   :   std_logic;
signal  rmii2Mac_crs_i      :   std_logic;
signal  rmii2Mac_rx_dv_i    :   std_logic;
signal  rmii2Mac_rx_er_i    :   std_logic;
signal  rmii2Mac_rxd_i      :   std_logic_vector(3  downto  0);
signal  phy2Rmii_crs_dv_d2  :   std_logic;
signal  phy2Rmii_crs_dv_d1  :   std_logic;
signal  phy2Rmii_rx_er_d2   :   std_logic;
signal  phy2Rmii_rx_er_d1   :   std_logic;
signal  phy2Rmii_rxd_d2     :   std_logic_vector(1  downto  0);
signal  phy2Rmii_rxd_d1     :   std_logic_vector(1  downto  0);
signal  rmii2Phy_txd_i      :   std_logic_vector(1  downto  0);
signal  rmii2Phy_tx_en_i    :   std_logic;

begin

------------------------------------------------------------------------------
-- SYNC_RST_N_PROCESS
------------------------------------------------------------------------------

SYNC_RST_N_PROCESS : process (
                             ref_clk,
                             rst_n,
                             rst_n_d
                             )
begin
    sync_rst_n  <=  rst_n_d(1);
    if (ref_clk'event and ref_clk = '1') then
        rst_n_d  <=  rst_n_d(0)  &  rst_n;
    end if;
end process;

------------------------------------------------------------------------------
-- INPUT_PIPELINE_PROCESS
------------------------------------------------------------------------------

INPUT_PIPELINE_PROCESS : process ( ref_clk )
begin
    if (ref_clk'event and ref_clk = '1') then
        if ( sync_rst_n =  '0' ) then
            mac2Rmii_tx_en_d2  <=  '0';
            mac2Rmii_tx_en_d1  <=  '0';
            mac2Rmii_txd_d2    <=  "0000";
            mac2Rmii_txd_d1    <=  "0000";
            mac2Rmii_tx_er_d2  <=  '0';
            mac2Rmii_tx_er_d1  <=  '0';
            phy2Rmii_crs_dv_d2 <=  '0';
            phy2Rmii_crs_dv_d1 <=  '0';
            phy2Rmii_rx_er_d2  <=  '0';
            phy2Rmii_rx_er_d1  <=  '0';
            phy2Rmii_rxd_d2    <=  "00";
            phy2Rmii_rxd_d1    <=  "00";
        else
            mac2Rmii_tx_en_d2  <=  mac2Rmii_tx_en_d1;
            mac2Rmii_tx_en_d1  <=  mac2rmii_tx_en;
            mac2Rmii_txd_d2    <=  mac2Rmii_txd_d1;
            mac2Rmii_txd_d1    <=  mac2rmii_txd;
            mac2Rmii_tx_er_d2  <=  mac2Rmii_tx_er_d1;
            mac2Rmii_tx_er_d1  <=  mac2rmii_tx_er;
            phy2Rmii_crs_dv_d2 <=  phy2Rmii_crs_dv_d1;
            phy2Rmii_crs_dv_d1 <=  phy2rmii_crs_dv;
            phy2Rmii_rx_er_d2  <=  phy2Rmii_rx_er_d1;
            phy2Rmii_rx_er_d1  <=  phy2rmii_rx_er;
            phy2Rmii_rxd_d2    <=  phy2Rmii_rxd_d1;
            phy2Rmii_rxd_d1    <=  phy2rmii_rxd;
        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- OUTPUT_PIPELINE_PROCESS
------------------------------------------------------------------------------

OUTPUT_PIPELINE_PROCESS : process ( ref_clk )
begin
    if (ref_clk'event and ref_clk = '1') then
        if ( sync_rst_n =  '0' ) then
            rmii2mac_tx_clk   <=  '0';
            rmii2mac_rx_clk   <=  '0';
            rmii2mac_col      <=  '0';
            rmii2mac_crs      <=  '0';
            rmii2mac_rx_dv    <=  '0';
            rmii2mac_rx_er    <=  '0';
            rmii2mac_rxd      <=  "0000";
            rmii2phy_txd      <=  "00";
            rmii2phy_tx_en    <=  '0';
        else
            rmii2mac_tx_clk   <=  rmii2Mac_tx_clk_i;
            rmii2mac_rx_clk   <=  rmii2Mac_rx_clk_i;
            rmii2mac_col      <=  rmii2Mac_crs_i  and  mac2Rmii_tx_en_d2;
            rmii2mac_crs      <=  rmii2Mac_crs_i;
            rmii2mac_rx_dv    <=  rmii2Mac_rx_dv_i;
            rmii2mac_rx_er    <=  rmii2Mac_rx_er_i;
            rmii2mac_rxd      <=  rmii2Mac_rxd_i;
            rmii2phy_txd      <=  rmii2Phy_txd_i;
            rmii2phy_tx_en    <=  rmii2Phy_tx_en_i;
        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- Concurrent signal assignments
------------------------------------------------------------------------------

tx_speed_100_i  <= C_SPEED_100;
rx_speed_100_i  <= C_SPEED_100;

------------------------------------------------------------------------------
--
-- Conditional Generate for AGILE speed throughput
--
------------------------------------------------------------------------------

RMII_AGILE : if (C_FIXED_SPEED = '0') generate

begin

    --------------------------------------------------------------------------
    -- Component Instatiations
    --------------------------------------------------------------------------

    I_TX : entity mii_to_rmii_v2_0_8.rmii_tx_agile(simulation)
        generic map(
                   C_RESET_ACTIVE    => RESET_ACTIVE
                   )

        port map   (
                   Tx_speed_100      => tx_speed_100_i,
                   ------------------  System Signals  -------------
                   Sync_rst_n        => sync_rst_n,           -- in
                   ref_clk           => ref_clk,              -- in
                   ------------------  MII  <-->  RMII  ------------
                   mac2rmii_tx_en    => mac2Rmii_tx_en_d2,    -- in
                   mac2rmii_txd      => mac2Rmii_txd_d2,      -- in
                   mac2rmii_tx_er    => mac2Rmii_tx_er_d2,    -- in
                   rmii2mac_tx_clk   => rmii2Mac_tx_clk_i,    -- out
                   ------------------  RMII  <-->  PHY  ------------
                   rmii2phy_txd      => rmii2Phy_txd_i,       -- out
                   rmii2phy_tx_en    => rmii2Phy_tx_en_i      -- out
                   );

    I_RX : entity mii_to_rmii_v2_0_8.rmii_rx_agile(simulation)
        generic map(
                   C_RESET_ACTIVE   => RESET_ACTIVE
                   )

        port map   (
                   Rx_speed_100      => rx_speed_100_i,
                   ------------------  System Signals  -------------
                   Sync_rst_n        => sync_rst_n,           -- in
                   ref_clk           => ref_clk,              -- in
                   ------------------  MII  <-->  RMII  ------------
                   rmii2mac_rx_clk   => rmii2Mac_rx_clk_i,    -- out
                   rmii2mac_crs      => rmii2Mac_crs_i,       -- out
                   rmii2mac_rx_dv    => rmii2Mac_rx_dv_i,     -- out
                   rmii2mac_rx_er    => rmii2Mac_rx_er_i,     -- out
                   rmii2mac_rxd      => rmii2Mac_rxd_i,       -- out
                   ------------------  RMII  <-->  PHY  ------------
                   phy2rmii_crs_dv   => phy2Rmii_crs_dv_d2,   -- in
                   phy2rmii_rx_er    => phy2Rmii_rx_er_d2,    -- in
                   phy2rmii_rxd      => phy2Rmii_rxd_d2       -- in
                   );

end generate RMII_AGILE;

------------------------------------------------------------------------------
--
-- Conditional Generate for FIXED speed throughput
--
------------------------------------------------------------------------------

RMII_FIXED : if (C_FIXED_SPEED = '1') generate

begin

    --------------------------------------------------------------------------
    -- Component Instatiations
    --------------------------------------------------------------------------

    I_TX : entity mii_to_rmii_v2_0_8.rmii_tx_fixed(simulation)
        generic map(
                   C_RESET_ACTIVE    => RESET_ACTIVE
                   )

        port map   (
                   Tx_speed_100      => tx_speed_100_i,
                   ------------------  System Signals  -------------
                   Sync_rst_n        => sync_rst_n,           -- in
                   ref_clk           => ref_clk,              -- in
                   ------------------  MII  <-->  RMII  ------------
                   mac2rmii_tx_en    => mac2Rmii_tx_en_d2,    -- in
                   mac2rmii_txd      => mac2Rmii_txd_d2,      -- in
                   mac2rmii_tx_er    => mac2Rmii_tx_er_d2,    -- in
                   rmii2mac_tx_clk   => rmii2Mac_tx_clk_i,    -- out
                   ------------------  RMII  <-->  PHY  ------------
                   rmii2phy_txd      => rmii2Phy_txd_i,       -- out
                   rmii2phy_tx_en    => rmii2Phy_tx_en_i      -- out
                   );

    I_RX : entity mii_to_rmii_v2_0_8.rmii_rx_fixed(simulation)
        generic map(
                   C_RESET_ACTIVE    => RESET_ACTIVE,
                   C_SPEED_100       => C_SPEED_100
                   )

        port map   (
                   Rx_speed_100      => rx_speed_100_i,
                   ------------------  System Signals  -------------
                   Sync_rst_n        => sync_rst_n,           -- in
                   ref_clk           => ref_clk,              -- in
                   ------------------  MII  <-->  RMII  ------------
                   rmii2mac_rx_clk   => rmii2Mac_rx_clk_i,    -- out
                   rmii2mac_crs      => rmii2Mac_crs_i,       -- out
                   rmii2mac_rx_dv    => rmii2Mac_rx_dv_i,     -- out
                   rmii2mac_rx_er    => rmii2Mac_rx_er_i,     -- out
                   rmii2mac_rxd      => rmii2Mac_rxd_i,       -- out
                   ------------------  RMII  <-->  PHY  ------------
                   phy2rmii_crs_dv   => phy2Rmii_crs_dv_d2,   -- in
                   phy2rmii_rx_er    => phy2Rmii_rx_er_d2,    -- in
                   phy2rmii_rxd      => phy2Rmii_rxd_d2       -- in
                   );

end generate RMII_FIXED;

end simulation;
