// (c) Copyright 1995-2015 Xilinx, Inc. All rights reserved.
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

// IP VLNV: jsykora.info:user:eth100_link_tx:3.0
// IP Revision: 1

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ZynqDesign_eth100_link_tx_0_0 your_instance_name (
  .ref_clk(ref_clk),        // input wire ref_clk
  .rmii_txen(rmii_txen),    // output wire rmii_txen
  .rmii_txdt(rmii_txdt),    // output wire [1 : 0] rmii_txdt
  .clk(clk),                // input wire clk
  .aresetn(aresetn),        // input wire aresetn
  .m1_addr(m1_addr),        // input wire [11 : 0] m1_addr
  .m1_wdt(m1_wdt),          // input wire [31 : 0] m1_wdt
  .m1_wstrobe(m1_wstrobe),  // input wire m1_wstrobe
  .m1_rstrobe(m1_rstrobe),  // input wire m1_rstrobe
  .m1_rdt(m1_rdt),          // output wire [31 : 0] m1_rdt
  .mr_addr(mr_addr),        // input wire [7 : 0] mr_addr
  .mr_wdt(mr_wdt),          // input wire [31 : 0] mr_wdt
  .mr_wstrobe(mr_wstrobe),  // input wire mr_wstrobe
  .mr_rstrobe(mr_rstrobe),  // input wire mr_rstrobe
  .mr_rdt(mr_rdt),          // output wire [31 : 0] mr_rdt
  .irq(irq)                // output wire irq
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

