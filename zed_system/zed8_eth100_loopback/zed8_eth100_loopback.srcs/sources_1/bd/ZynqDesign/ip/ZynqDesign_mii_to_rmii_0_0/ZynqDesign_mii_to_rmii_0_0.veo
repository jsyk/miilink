// (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

// IP VLNV: xilinx.com:ip:mii_to_rmii:2.0
// IP Revision: 8

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ZynqDesign_mii_to_rmii_0_0 your_instance_name (
  .rst_n(rst_n),                      // input wire rst_n
  .ref_clk(ref_clk),                  // input wire ref_clk
  .mac2rmii_tx_en(mac2rmii_tx_en),    // input wire mac2rmii_tx_en
  .mac2rmii_txd(mac2rmii_txd),        // input wire [3 : 0] mac2rmii_txd
  .mac2rmii_tx_er(mac2rmii_tx_er),    // input wire mac2rmii_tx_er
  .rmii2mac_tx_clk(rmii2mac_tx_clk),  // output wire rmii2mac_tx_clk
  .rmii2mac_rx_clk(rmii2mac_rx_clk),  // output wire rmii2mac_rx_clk
  .rmii2mac_col(rmii2mac_col),        // output wire rmii2mac_col
  .rmii2mac_crs(rmii2mac_crs),        // output wire rmii2mac_crs
  .rmii2mac_rx_dv(rmii2mac_rx_dv),    // output wire rmii2mac_rx_dv
  .rmii2mac_rx_er(rmii2mac_rx_er),    // output wire rmii2mac_rx_er
  .rmii2mac_rxd(rmii2mac_rxd),        // output wire [3 : 0] rmii2mac_rxd
  .phy2rmii_crs_dv(phy2rmii_crs_dv),  // input wire phy2rmii_crs_dv
  .phy2rmii_rx_er(phy2rmii_rx_er),    // input wire phy2rmii_rx_er
  .phy2rmii_rxd(phy2rmii_rxd),        // input wire [1 : 0] phy2rmii_rxd
  .rmii2phy_txd(rmii2phy_txd),        // output wire [1 : 0] rmii2phy_txd
  .rmii2phy_tx_en(rmii2phy_tx_en)    // output wire rmii2phy_tx_en
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file ZynqDesign_mii_to_rmii_0_0.v when simulating
// the core, ZynqDesign_mii_to_rmii_0_0. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

