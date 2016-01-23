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
-- Filename:        rx_fifo.vhd
--
-- Version:         v1.01.a
-- Description:     This module
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library mii_to_rmii_v2_0_8;

-- synopsys translate_off


-- synopsys translate_on

------------------------------------------------------------------------------
-- Port Declaration
------------------------------------------------------------------------------

entity rx_fifo is
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
end rx_fifo;

------------------------------------------------------------------------------
-- Definition of Generics:
--          C_RESET_ACTIVE  --
--
-- Definition of Ports:
--
------------------------------------------------------------------------------

architecture simulation of rx_fifo is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

------------------------------------------------------------------------------
-- Constant Declarations
------------------------------------------------------------------------------
-- Note that global constants and parameters (such as C_RESET_ACTIVE, default
-- values for address and data --widths, initialization values, etc.) should be
-- collected into a global package or include file.
-- Constants are all uppercase.
-- Constants or parameters should be used for all numeric values except for
-- single "0" or "1" values.
-- Constants should also be used when denoting a bit location within a register.
-- If no constants are required, simply lene this in a comment below the file
-- section separation comments.
------------------------------------------------------------------------------

--  No constants in this architecture.

------------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------------

signal  srl_fifo_reset      :  std_logic;
signal  rx_fifo_output_i    :  std_logic_vector(15  downto  0);

------------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------------

component srl_fifo
    generic (
             C_DATA_BITS  :  natural  :=  8;
             C_DEPTH      :  natural  :=  16;
             C_XON        :  boolean  :=  false
            );

    port    (
             Clk          :  in   std_logic;
             Reset        :  in   std_logic;
             FIFO_Write   :  in   std_logic;
             Data_In      :  in   std_logic_vector(0 to C_DATA_BITS-1);
             FIFO_Read    :  in   std_logic;
             Data_Out     :  out  std_logic_vector(0 to C_DATA_BITS-1);
             FIFO_Full    :  out  std_logic;
             Data_Exists  :  out  std_logic;
             Addr         :  out  std_logic_vector(0 to 3) -- Added Addr as a port
            );
end component;

begin

------------------------------------------------------------------------------
-- Component Instantiations
------------------------------------------------------------------------------
-- Lene the function the component is performing with comments
-- Component instantiation names are all uppercase and are of the form:
--          <ENTITY_>I_<#|FUNC>
-- If no components are required, delete this section from the file
------------------------------------------------------------------------------

I_SRL_FIFO : srl_fifo
    generic map (
                 C_DATA_BITS  =>  16,
                 C_DEPTH      =>  16,
                 C_XON        =>  false
                )

    port map    (
                 Clk          =>  Ref_Clk,
                 Reset        =>  srl_fifo_reset,
                 FIFO_Write   =>  Rx_fifo_wr_en,
                 Data_In      =>  Rx_fifo_input,
                 FIFO_Read    =>  Rx_fifo_rd_en,
                 Data_Out     =>  rx_fifo_output_i,
                 FIFO_Full    =>  Rx_fifo_full,
                 Data_Exists  =>  Rx_fifo_mt_n,
                 Addr         =>  open
                );

------------------------------------------------------------------------------
-- RESET_PROCESS
------------------------------------------------------------------------------

RESET_PROCESS : process (Sync_rst_n)
begin
    if (Sync_rst_n = C_RESET_ACTIVE) then
        srl_fifo_reset  <=  '1';
    else
        srl_fifo_reset  <=  '0';
    end if;
end process;

------------------------------------------------------------------------------
-- FIFO_REGISTER_PROCESS
------------------------------------------------------------------------------
-- Include comments about the function of the process
------------------------------------------------------------------------------

FIFO_REGISTER_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then
        if (sync_rst_n = C_RESET_ACTIVE) then
            Rx_fifo_output  <=  (others => '0');
        elsif (Rx_fifo_rd_en = '1') then
            Rx_fifo_output  <=  rx_fifo_output_i;
        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- Concurrent Signal Assignments
------------------------------------------------------------------------------
-- NONE

end simulation;
