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
-- Filename:        rmii_rx_agile.vhd
--
-- Version:         v1.01.a
-- Description:     Top level of RMII(reduced media independent interface)
--
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
--          C_GEN1          -- description of generic, if description doesn't fit
--                          -- align with first part of description
--          C_GEN2          -- description of generic
--
-- Definition of Ports:
--          Port_name1      -- description of port, indicate source or destination
--          Port_name2      -- description of port
--
------------------------------------------------------------------------------
entity rmii_rx_agile is
    generic (
            C_RESET_ACTIVE    : std_logic
            );

    port    (
            Rx_speed_100      : in    std_logic;
            ------------------  System Signals  -------------------------------
            Sync_rst_n        : in    std_logic;
            Ref_Clk           : in    std_logic;
            ------------------  MII <--> RMII  --------------------------------
            Rmii2Mac_rx_clk   : out   std_logic;
            Rmii2Mac_crs      : out   std_logic;
            Rmii2Mac_rx_dv    : out   std_logic;
            Rmii2Mac_rx_er    : out   std_logic;
            Rmii2Mac_rxd      : out   std_logic_vector(3  downto  0);
            ------------------  RMII <--> PHY  --------------------------------
            Phy2Rmii_crs_dv   : in    std_logic;
            Phy2Rmii_rx_er    : in    std_logic;
            Phy2Rmii_rxd      : in    std_logic_vector(1  downto  0)
            );
end rmii_rx_agile;

------------------------------------------------------------------------------
-- Configurations
------------------------------------------------------------------------------
-- No Configurations

------------------------------------------------------------------------------
-- Architecture
------------------------------------------------------------------------------

architecture simulation of rmii_rx_agile is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

------------------------------------------------------------------------------
-- Components
------------------------------------------------------------------------------

component rx_fifo_loader
    generic (
            C_RESET_ACTIVE    :  std_logic
            );

    port    (
            Sync_rst_n        :  in   std_logic;
            Ref_Clk           :  in   std_logic;
            Phy2Rmii_crs_dv   :  in   std_logic;
            Phy2Rmii_rx_er    :  in   std_logic;
            Phy2Rmii_rxd      :  in   std_logic_vector(1  downto  0);
            Rx_fifo_wr_en     :  out  std_logic;
            Rx_10             :  out  std_logic;
            Rx_100            :  out  std_logic;
            Rx_data           :  out  std_logic_vector(7  downto  0);
            Rx_error          :  out  std_logic;
            Rx_data_valid     :  out  std_logic;
            Rx_cary_sense     :  out  std_logic;
            Rx_end_of_packet  :  out  std_logic
            );
end component;

component rx_fifo
    generic (
            C_RESET_ACTIVE    :  std_logic
            );

    port    (
            Sync_rst_n        :  in   std_logic;
            Ref_Clk           :  in   std_logic;
            Rx_fifo_wr_en     :  in   std_logic;
            Rx_fifo_rd_en     :  in   std_logic;
            Rx_fifo_input     :  in   std_logic_vector(15  downto  0);
            Rx_fifo_mt_n      :  out  std_logic;
            Rx_fifo_full      :  out  std_logic;
            Rx_fifo_output    :  out  std_logic_vector(15  downto  0)
            );
end component;

component rx_fifo_disposer
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
end component;

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
-- No Constant Declarations

------------------------------------------------------------------------------
-- Signal and Type Declarations
------------------------------------------------------------------------------

signal  rx_fifo_wr_en     :  std_logic;
signal  rx_fifo_rd_en     :  std_logic;
signal  rx_fifo_full      :  std_logic;
signal  rx_fifo_mt_n      :  std_logic;
signal  rx_10             :  std_logic;
signal  rx_100            :  std_logic;
signal  rx_data           :  std_logic_vector(7  downto  0);
signal  rx_data_valid     :  std_logic;
signal  rx_cary_sense     :  std_logic;
signal  rx_error          :  std_logic;
signal  rx_end_of_packet  :  std_logic;
signal  rx_mii_eop        :  std_logic_vector(1  downto  0);
signal  rx_mii_crs        :  std_logic_vector(1  downto  0);
signal  rx_mii_er         :  std_logic_vector(1  downto  0);
signal  rx_mii_dv         :  std_logic_vector(1  downto  0);
signal  rx_mii_data       :  std_logic_vector(7  downto  0);

begin

------------------------------------------------------------------------------
-- Concurrent Signal Assignments
------------------------------------------------------------------------------

Rmii2Mac_crs <= rx_cary_sense;

------------------------------------------------------------------------------
-- Component Instantiations
------------------------------------------------------------------------------


I_RX_FIFO_LOADER : rx_fifo_loader
    generic map(
               C_RESET_ACTIVE      =>  C_RESET_ACTIVE
               )

    port map   (
               Sync_rst_n          =>  Sync_rst_n,
               Ref_Clk             =>  Ref_Clk,
               Phy2Rmii_crs_dv     =>  Phy2Rmii_crs_dv,
               Phy2Rmii_rx_er      =>  Phy2Rmii_rx_er,
               Phy2Rmii_rxd        =>  Phy2Rmii_rxd,
               Rx_fifo_wr_en       =>  rx_fifo_wr_en,
               Rx_10               =>  rx_10,
               Rx_100              =>  rx_100,
               Rx_data             =>  rx_data,
               Rx_error            =>  rx_error,
               Rx_data_valid       =>  rx_data_valid,
               Rx_cary_sense       =>  rx_cary_sense,
               Rx_end_of_packet    =>  rx_end_of_packet
               );

I_RX_FIFO : rx_fifo
    generic map(
               C_RESET_ACTIVE      =>  C_RESET_ACTIVE
               )

    port map   (
               Sync_rst_n          =>  Sync_rst_n,
               Ref_Clk             =>  Ref_Clk,
               Rx_fifo_wr_en       =>  rx_fifo_wr_en,
               Rx_fifo_rd_en       =>  rx_fifo_rd_en,
               Rx_fifo_input(15)   =>  rx_end_of_packet,
               Rx_fifo_input(14)   =>  rx_cary_sense,
               Rx_fifo_input(13)   =>  rx_error,
               Rx_fifo_input(12)   =>  rx_data_valid,
               Rx_fifo_input(11)   =>  rx_data(7),
               Rx_fifo_input(10)   =>  rx_data(6),
               Rx_fifo_input(9)    =>  rx_data(5),
               Rx_fifo_input(8)    =>  rx_data(4),
               Rx_fifo_input(7)    =>  rx_end_of_packet,
               Rx_fifo_input(6)    =>  rx_cary_sense,
               Rx_fifo_input(5)    =>  rx_error,
               Rx_fifo_input(4)    =>  rx_data_valid,
               Rx_fifo_input(3)    =>  rx_data(3),
               Rx_fifo_input(2)    =>  rx_data(2),
               Rx_fifo_input(1)    =>  rx_data(1),
               Rx_fifo_input(0)    =>  rx_data(0),
               Rx_fifo_mt_n        =>  rx_fifo_mt_n,
               Rx_fifo_full        =>  rx_fifo_full,
               Rx_fifo_output(15)  =>  rx_mii_eop(1),
               Rx_fifo_output(14)  =>  rx_mii_crs(1),
               Rx_fifo_output(13)  =>  rx_mii_er(1),
               Rx_fifo_output(12)  =>  rx_mii_dv(1),
               Rx_fifo_output(11)  =>  rx_mii_data(7),
               Rx_fifo_output(10)  =>  rx_mii_data(6),
               Rx_fifo_output(9)   =>  rx_mii_data(5),
               Rx_fifo_output(8)   =>  rx_mii_data(4),
               Rx_fifo_output(7)   =>  rx_mii_eop(0),
               Rx_fifo_output(6)   =>  rx_mii_crs(0),
               Rx_fifo_output(5)   =>  rx_mii_er(0),
               Rx_fifo_output(4)   =>  rx_mii_dv(0),
               Rx_fifo_output(3)   =>  rx_mii_data(3),
               Rx_fifo_output(2)   =>  rx_mii_data(2),
               Rx_fifo_output(1)   =>  rx_mii_data(1),
               Rx_fifo_output(0)   =>  rx_mii_data(0)
               );

I_RX_FIFO_DISPOSER : rx_fifo_disposer
    generic map(
               C_RESET_ACTIVE      =>  C_RESET_ACTIVE
               )

    port map   (
               Sync_rst_n          =>  Sync_rst_n,
               Ref_Clk             =>  Ref_Clk,
               Rx_10               =>  rx_10,
               Rx_100              =>  rx_100,
               Rmii_rx_eop         =>  rx_mii_eop,
               Rmii_rx_crs         =>  rx_mii_crs,
               Rmii_rx_er          =>  rx_mii_er,
               Rmii_rx_dv          =>  rx_mii_dv,
               Rmii_rx_data        =>  rx_mii_data,
               Rx_fifo_mt_n        =>  rx_fifo_mt_n,
               Rx_fifo_rd_en       =>  rx_fifo_rd_en,
            --   Rmii2mac_crs        =>  Rmii2mac_crs,
               Rmii2mac_crs        =>  open,
               Rmii2mac_rx_clk     =>  Rmii2mac_rx_clk,
               Rmii2mac_rx_er      =>  Rmii2mac_rx_er,
               Rmii2mac_rx_dv      =>  Rmii2mac_rx_dv,
               Rmii2mac_rxd        =>  Rmii2mac_rxd
               );

end simulation;
