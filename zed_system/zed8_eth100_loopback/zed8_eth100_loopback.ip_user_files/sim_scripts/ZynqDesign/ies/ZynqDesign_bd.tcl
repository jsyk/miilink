
################################################################
# This is a generated script based on design: ZynqDesign
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source ZynqDesign_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name ZynqDesign

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set btns_5bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 btns_5bits ]
  set leds_8bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 leds_8bits ]
  set sws_8bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 sws_8bits ]

  # Create ports
  set ref_clk_i [ create_bd_port -dir I -type clk ref_clk_i ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {50000000} \
 ] $ref_clk_i
  set ref_clk_o [ create_bd_port -dir O -type clk ref_clk_o ]
  set rmii_crs_dv [ create_bd_port -dir I rmii_crs_dv ]
  set rmii_rxd [ create_bd_port -dir I -from 1 -to 0 rmii_rxd ]
  set rmii_tx_en [ create_bd_port -dir O rmii_tx_en ]
  set rmii_txd [ create_bd_port -dir O -from 1 -to 0 rmii_txd ]

  # Create instance: axi_eth100_regs_0, and set properties
  set axi_eth100_regs_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_eth100_regs_0 ]
  set_property -dict [ list \
CONFIG.ECC_TYPE {0} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_eth100_regs_0

  # Create instance: axi_eth100_rxbuf_0, and set properties
  set axi_eth100_rxbuf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_eth100_rxbuf_0 ]
  set_property -dict [ list \
CONFIG.DATA_WIDTH {32} \
CONFIG.ECC_TYPE {0} \
CONFIG.PROTOCOL {AXI4LITE} \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_eth100_rxbuf_0

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {192.113} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50} \
CONFIG.CLKOUT1_REQUESTED_PHASE {180} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} \
CONFIG.MMCM_CLKOUT0_PHASE {180.000} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
 ] $clk_wiz_0

  # Create instance: eth100_link_rx_0, and set properties
  set eth100_link_rx_0 [ create_bd_cell -type ip -vlnv jsykora.info:user:eth100_link_rx:4.0 eth100_link_rx_0 ]
  set_property -dict [ list \
CONFIG.FRBUF_MEMBYTE_ADDR_W {12} \
 ] $eth100_link_rx_0

  # Create instance: ethernetlite_0, and set properties
  set ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 ethernetlite_0 ]
  set_property -dict [ list \
CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {1} \
CONFIG.C_INCLUDE_MDIO {0} \
 ] $ethernetlite_0

  # Create instance: gpio_btns, and set properties
  set gpio_btns [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_btns ]
  set_property -dict [ list \
CONFIG.GPIO_BOARD_INTERFACE {btns_5bits} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_btns

  # Create instance: gpio_leds, and set properties
  set gpio_leds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_leds ]
  set_property -dict [ list \
CONFIG.GPIO_BOARD_INTERFACE {leds_8bits} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_leds

  # Create instance: gpio_sws, and set properties
  set gpio_sws [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 gpio_sws ]
  set_property -dict [ list \
CONFIG.GPIO_BOARD_INTERFACE {sws_8bits} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $gpio_sws

  # Create instance: mii_to_rmii_0, and set properties
  set mii_to_rmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0 ]

  # Create instance: ps7, and set properties
  set ps7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps7 ]
  set_property -dict [ list \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {50} \
CONFIG.preset {ZedBoard} \
 ] $ps7

  # Create instance: ps7_axi_periph, and set properties
  set ps7_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps7_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {6} \
 ] $ps7_axi_periph

  # Create instance: rst_ps7_100M, and set properties
  set rst_ps7_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps7_100M ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_gpio_0_GPIO [get_bd_intf_ports sws_8bits] [get_bd_intf_pins gpio_sws/GPIO]
  connect_bd_intf_net -intf_net ethernetlite_0_MII [get_bd_intf_pins ethernetlite_0/MII] [get_bd_intf_pins mii_to_rmii_0/MII]
  connect_bd_intf_net -intf_net gpio_btns_GPIO [get_bd_intf_ports btns_5bits] [get_bd_intf_pins gpio_btns/GPIO]
  connect_bd_intf_net -intf_net gpio_leds_GPIO [get_bd_intf_ports leds_8bits] [get_bd_intf_pins gpio_leds/GPIO]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps7/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps7/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins ps7/M_AXI_GP0] [get_bd_intf_pins ps7_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins gpio_sws/S_AXI] [get_bd_intf_pins ps7_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps7_axi_periph_M01_AXI [get_bd_intf_pins gpio_leds/S_AXI] [get_bd_intf_pins ps7_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps7_axi_periph_M02_AXI [get_bd_intf_pins gpio_btns/S_AXI] [get_bd_intf_pins ps7_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps7_axi_periph_M03_AXI [get_bd_intf_pins ethernetlite_0/S_AXI] [get_bd_intf_pins ps7_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps7_axi_periph_M04_AXI [get_bd_intf_pins axi_eth100_rxbuf_0/S_AXI] [get_bd_intf_pins ps7_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps7_axi_periph_M05_AXI [get_bd_intf_pins axi_eth100_regs_0/S_AXI] [get_bd_intf_pins ps7_axi_periph/M05_AXI]

  # Create port connections
  connect_bd_net -net axi_eth100_regs_0_bram_addr_a [get_bd_pins axi_eth100_regs_0/bram_addr_a] [get_bd_pins eth100_link_rx_0/mr_addr]
  connect_bd_net -net axi_eth100_regs_0_bram_en_a [get_bd_pins axi_eth100_regs_0/bram_en_a] [get_bd_pins eth100_link_rx_0/mr_rstrobe]
  connect_bd_net -net axi_eth100_regs_0_bram_we_a [get_bd_pins axi_eth100_regs_0/bram_we_a] [get_bd_pins eth100_link_rx_0/mr_wstrobe]
  connect_bd_net -net axi_eth100_regs_0_bram_wrdata_a [get_bd_pins axi_eth100_regs_0/bram_wrdata_a] [get_bd_pins eth100_link_rx_0/mr_wdt]
  connect_bd_net -net axi_eth100_rxbuf_0_bram_addr_a [get_bd_pins axi_eth100_rxbuf_0/bram_addr_a] [get_bd_pins eth100_link_rx_0/m2_addr]
  connect_bd_net -net axi_eth100_rxbuf_0_bram_en_a [get_bd_pins axi_eth100_rxbuf_0/bram_en_a] [get_bd_pins eth100_link_rx_0/m2_rstrobe]
  connect_bd_net -net axi_eth100_rxbuf_0_bram_we_a [get_bd_pins axi_eth100_rxbuf_0/bram_we_a] [get_bd_pins eth100_link_rx_0/m2_wstrobe]
  connect_bd_net -net axi_eth100_rxbuf_0_bram_wrdata_a [get_bd_pins axi_eth100_rxbuf_0/bram_wrdata_a] [get_bd_pins eth100_link_rx_0/m2_wdt]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins eth100_link_rx_0/ref_clk] [get_bd_pins mii_to_rmii_0/ref_clk]
  connect_bd_net -net eth100_link_rx_0_m2_rdt [get_bd_pins axi_eth100_rxbuf_0/bram_rddata_a] [get_bd_pins eth100_link_rx_0/m2_rdt]
  connect_bd_net -net eth100_link_rx_0_mr_rdt [get_bd_pins axi_eth100_regs_0/bram_rddata_a] [get_bd_pins eth100_link_rx_0/mr_rdt]
  connect_bd_net -net ethernetlite_0_phy_rst_n [get_bd_pins ethernetlite_0/phy_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net mii_to_rmii_0_rmii2phy_tx_en [get_bd_ports rmii_tx_en] [get_bd_pins eth100_link_rx_0/rmii_rxdv] [get_bd_pins mii_to_rmii_0/rmii2phy_tx_en]
  connect_bd_net -net mii_to_rmii_0_rmii2phy_txd [get_bd_ports rmii_txd] [get_bd_pins eth100_link_rx_0/rmii_rxdt] [get_bd_pins mii_to_rmii_0/rmii2phy_txd]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_eth100_regs_0/s_axi_aclk] [get_bd_pins axi_eth100_rxbuf_0/s_axi_aclk] [get_bd_pins eth100_link_rx_0/clk] [get_bd_pins ethernetlite_0/s_axi_aclk] [get_bd_pins gpio_btns/s_axi_aclk] [get_bd_pins gpio_leds/s_axi_aclk] [get_bd_pins gpio_sws/s_axi_aclk] [get_bd_pins ps7/FCLK_CLK0] [get_bd_pins ps7/M_AXI_GP0_ACLK] [get_bd_pins ps7_axi_periph/ACLK] [get_bd_pins ps7_axi_periph/M00_ACLK] [get_bd_pins ps7_axi_periph/M01_ACLK] [get_bd_pins ps7_axi_periph/M02_ACLK] [get_bd_pins ps7_axi_periph/M03_ACLK] [get_bd_pins ps7_axi_periph/M04_ACLK] [get_bd_pins ps7_axi_periph/M05_ACLK] [get_bd_pins ps7_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins ps7/FCLK_RESET0_N] [get_bd_pins rst_ps7_100M/ext_reset_in]
  connect_bd_net -net ps7_FCLK_CLK1 [get_bd_ports ref_clk_o] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins ps7/FCLK_CLK1]
  connect_bd_net -net rmii_crs_dv_1 [get_bd_ports rmii_crs_dv] [get_bd_pins mii_to_rmii_0/phy2rmii_crs_dv]
  connect_bd_net -net rmii_rxd_1 [get_bd_ports rmii_rxd] [get_bd_pins mii_to_rmii_0/phy2rmii_rxd]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins ps7_axi_periph/ARESETN] [get_bd_pins rst_ps7_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_eth100_regs_0/s_axi_aresetn] [get_bd_pins axi_eth100_rxbuf_0/s_axi_aresetn] [get_bd_pins eth100_link_rx_0/aresetn] [get_bd_pins ethernetlite_0/s_axi_aresetn] [get_bd_pins gpio_btns/s_axi_aresetn] [get_bd_pins gpio_leds/s_axi_aresetn] [get_bd_pins gpio_sws/s_axi_aresetn] [get_bd_pins ps7_axi_periph/M00_ARESETN] [get_bd_pins ps7_axi_periph/M01_ARESETN] [get_bd_pins ps7_axi_periph/M02_ARESETN] [get_bd_pins ps7_axi_periph/M03_ARESETN] [get_bd_pins ps7_axi_periph/M04_ARESETN] [get_bd_pins ps7_axi_periph/M05_ARESETN] [get_bd_pins ps7_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_100M/peripheral_aresetn]
  connect_bd_net -net rst_ps7_100M_bus_struct_reset [get_bd_pins clk_wiz_0/reset] [get_bd_pins rst_ps7_100M/bus_struct_reset]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins mii_to_rmii_0/phy2rmii_rx_er] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x1000 -offset 0x40000000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs axi_eth100_rxbuf_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x1000 -offset 0x42000000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs axi_eth100_regs_0/S_AXI/Mem0] SEG_axi_eth100_regs_0_Mem0
  create_bd_addr_seg -range 0x10000 -offset 0x40E00000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs ethernetlite_0/S_AXI/Reg] SEG_axi_ethernetlite_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs gpio_sws/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x41220000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs gpio_btns/S_AXI/Reg] SEG_axi_gpio_0_Reg1
  create_bd_addr_seg -range 0x10000 -offset 0x41210000 [get_bd_addr_spaces ps7/Data] [get_bd_addr_segs gpio_leds/S_AXI/Reg] SEG_gpio_leds_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y -400 -defaultsOSRD
preplace port leds_8bits -pg 1 -y 70 -defaultsOSRD
preplace port sws_8bits -pg 1 -y -160 -defaultsOSRD
preplace port rmii_crs_dv -pg 1 -y 450 -defaultsOSRD -right
preplace port btns_5bits -pg 1 -y 200 -defaultsOSRD
preplace port rmii_tx_en -pg 1 -y 520 -defaultsOSRD
preplace port ref_clk_i -pg 1 -y 700 -defaultsOSRD -right
preplace port FIXED_IO -pg 1 -y -370 -defaultsOSRD
preplace port ref_clk_o -pg 1 -y 320 -defaultsOSRD
preplace portBus rmii_rxd -pg 1 -y 490 -defaultsOSRD -right
preplace portBus rmii_txd -pg 1 -y 540 -defaultsOSRD
preplace inst axi_eth100_regs_0 -pg 1 -lvl 4 -y 1270 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 5 -y 610 -defaultsOSRD
preplace inst gpio_leds -pg 1 -lvl 4 -y 70 -defaultsOSRD
preplace inst ps7 -pg 1 -lvl 1 -y -250 -defaultsOSRD
preplace inst eth100_link_rx_0 -pg 1 -lvl 5 -y 980 -defaultsOSRD
preplace inst rst_ps7_100M -pg 1 -lvl 2 -y -120 -defaultsOSRD
preplace inst mii_to_rmii_0 -pg 1 -lvl 5 -y 450 -defaultsOSRD
preplace inst ps7_axi_periph -pg 1 -lvl 3 -y -160 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 5 -y 710 -defaultsOSRD
preplace inst ethernetlite_0 -pg 1 -lvl 4 -y 550 -defaultsOSRD
preplace inst gpio_btns -pg 1 -lvl 4 -y 200 -defaultsOSRD
preplace inst axi_eth100_rxbuf_0 -pg 1 -lvl 4 -y 930 -defaultsOSRD
preplace inst gpio_sws -pg 1 -lvl 4 -y -160 -defaultsOSRD
preplace netloc gpio_leds_GPIO 1 4 2 NJ 70 N
preplace netloc processing_system7_0_DDR 1 1 5 NJ -430 NJ -430 NJ -430 NJ -430 NJ
preplace netloc ps7_axi_periph_M02_AXI 1 3 1 1230
preplace netloc axi_eth100_regs_0_bram_en_a 1 4 1 1640
preplace netloc mii_to_rmii_0_rmii2phy_tx_en 1 4 2 1620 550 1930
preplace netloc ps7_axi_periph_M05_AXI 1 3 1 1180
preplace netloc axi_eth100_regs_0_bram_addr_a 1 4 1 1610
preplace netloc axi_eth100_rxbuf_0_bram_we_a 1 4 1 N
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 3 1 1250
preplace netloc axi_eth100_rxbuf_0_bram_en_a 1 4 1 1570
preplace netloc processing_system7_0_M_AXI_GP0 1 1 2 NJ -320 N
preplace netloc eth100_link_rx_0_mr_rdt 1 4 2 N 1280 1910
preplace netloc rmii_crs_dv_1 1 5 1 1940
preplace netloc processing_system7_0_FCLK_RESET0_N 1 1 1 200
preplace netloc eth100_link_rx_0_m2_rdt 1 4 2 1580 1150 1930
preplace netloc ethernetlite_0_phy_rst_n 1 4 1 1570
preplace netloc axi_eth100_regs_0_bram_we_a 1 4 1 1630
preplace netloc ps7_FCLK_CLK1 1 1 5 NJ -410 NJ -410 NJ -410 NJ 320 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 2 3 820 -390 1220 1060 1600
preplace netloc ps7_axi_periph_M01_AXI 1 3 1 1240
preplace netloc mii_to_rmii_0_rmii2phy_txd 1 4 2 1640 560 1920
preplace netloc xlconstant_0_dout 1 5 1 1910
preplace netloc gpio_btns_GPIO 1 4 2 NJ 200 N
preplace netloc processing_system7_0_FIXED_IO 1 1 5 NJ -420 NJ -420 NJ -420 NJ -420 NJ
preplace netloc axi_eth100_regs_0_bram_wrdata_a 1 4 1 1620
preplace netloc clk_wiz_0_clk_out1 1 4 2 1610 770 1910
preplace netloc rmii_rxd_1 1 5 1 1940
preplace netloc axi_gpio_0_GPIO 1 4 2 NJ -160 N
preplace netloc ethernetlite_0_MII 1 4 1 1560
preplace netloc axi_eth100_rxbuf_0_bram_wrdata_a 1 4 1 1560
preplace netloc ps7_axi_periph_M04_AXI 1 3 1 1190
preplace netloc rst_ps7_100M_bus_struct_reset 1 2 3 NJ -400 NJ -400 1580
preplace netloc processing_system7_0_FCLK_CLK0 1 0 5 -210 -110 220 -210 840 -380 1210 1050 1590
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 2 1 830
preplace netloc ps7_axi_periph_M03_AXI 1 3 1 1200
preplace netloc axi_eth100_rxbuf_0_bram_addr_a 1 4 1 1610
levelinfo -pg 1 -230 -10 640 1030 1410 1790 1960 -top -440 -bot 1370
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


