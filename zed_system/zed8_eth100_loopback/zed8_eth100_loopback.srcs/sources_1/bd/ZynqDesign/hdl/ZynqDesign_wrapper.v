//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.3 (lin64) Build 1368829 Mon Sep 28 20:06:39 MDT 2015
//Date        : Wed Jan 20 22:18:29 2016
//Host        : megalit.local running 64-bit Fedora release 22 (Twenty Two)
//Command     : generate_target ZynqDesign_wrapper.bd
//Design      : ZynqDesign_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ZynqDesign_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    btns_5bits_tri_i,
    frmwrk,
    leds_8bits_tri_o,
    ref_clk_i,
    ref_clk_o,
    rmii_crs_dv,
    rmii_rxd,
    rmii_tx_en,
    rmii_txd,
    sws_8bits_tri_i);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input [4:0]btns_5bits_tri_i;
  output frmwrk;
  output [7:0]leds_8bits_tri_o;
  input ref_clk_i;
  output ref_clk_o;
  input rmii_crs_dv;
  input [1:0]rmii_rxd;
  output rmii_tx_en;
  output [1:0]rmii_txd;
  input [7:0]sws_8bits_tri_i;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [4:0]btns_5bits_tri_i;
  wire frmwrk;
  wire [7:0]leds_8bits_tri_o;
  wire ref_clk_i;
  wire ref_clk_o;
  wire rmii_crs_dv;
  wire [1:0]rmii_rxd;
  wire rmii_tx_en;
  wire [1:0]rmii_txd;
  wire [7:0]sws_8bits_tri_i;

  ZynqDesign ZynqDesign_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .btns_5bits_tri_i(btns_5bits_tri_i),
        .frmwrk(frmwrk),
        .leds_8bits_tri_o(leds_8bits_tri_o),
        .ref_clk_i(ref_clk_i),
        .ref_clk_o(ref_clk_o),
        .rmii_crs_dv(rmii_crs_dv),
        .rmii_rxd(rmii_rxd),
        .rmii_tx_en(rmii_tx_en),
        .rmii_txd(rmii_txd),
        .sws_8bits_tri_i(sws_8bits_tri_i));
endmodule
