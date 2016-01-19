
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

  # Create instance: ethernetlite_0, and set properties
  set ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 ethernetlite_0 ]
  set_property -dict [ list \
CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {0} \
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
CONFIG.NUM_MI {4} \
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

  # Create port connections
  connect_bd_net -net ethernetlite_0_phy_rst_n [get_bd_pins ethernetlite_0/phy_rst_n] [get_bd_pins mii_to_rmii_0/rst_n]
  connect_bd_net -net mii_to_rmii_0_rmii2phy_tx_en [get_bd_ports rmii_tx_en] [get_bd_pins mii_to_rmii_0/rmii2phy_tx_en]
  connect_bd_net -net mii_to_rmii_0_rmii2phy_txd [get_bd_ports rmii_txd] [get_bd_pins mii_to_rmii_0/rmii2phy_txd]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins ethernetlite_0/s_axi_aclk] [get_bd_pins gpio_btns/s_axi_aclk] [get_bd_pins gpio_leds/s_axi_aclk] [get_bd_pins gpio_sws/s_axi_aclk] [get_bd_pins ps7/FCLK_CLK0] [get_bd_pins ps7/M_AXI_GP0_ACLK] [get_bd_pins ps7_axi_periph/ACLK] [get_bd_pins ps7_axi_periph/M00_ACLK] [get_bd_pins ps7_axi_periph/M01_ACLK] [get_bd_pins ps7_axi_periph/M02_ACLK] [get_bd_pins ps7_axi_periph/M03_ACLK] [get_bd_pins ps7_axi_periph/S00_ACLK] [get_bd_pins rst_ps7_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins ps7/FCLK_RESET0_N] [get_bd_pins rst_ps7_100M/ext_reset_in]
  connect_bd_net -net ps7_ETH_REF_CLK [get_bd_ports ref_clk_o] [get_bd_pins ps7/FCLK_CLK1]
  connect_bd_net -net ref_clk_i_1 [get_bd_ports ref_clk_i] [get_bd_pins mii_to_rmii_0/ref_clk]
  connect_bd_net -net rmii_crs_dv_1 [get_bd_ports rmii_crs_dv] [get_bd_pins mii_to_rmii_0/phy2rmii_crs_dv]
  connect_bd_net -net rmii_rxd_1 [get_bd_ports rmii_rxd] [get_bd_pins mii_to_rmii_0/phy2rmii_rxd]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins ps7_axi_periph/ARESETN] [get_bd_pins rst_ps7_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins ethernetlite_0/s_axi_aresetn] [get_bd_pins gpio_btns/s_axi_aresetn] [get_bd_pins gpio_leds/s_axi_aresetn] [get_bd_pins gpio_sws/s_axi_aresetn] [get_bd_pins ps7_axi_periph/M00_ARESETN] [get_bd_pins ps7_axi_periph/M01_ARESETN] [get_bd_pins ps7_axi_periph/M02_ARESETN] [get_bd_pins ps7_axi_periph/M03_ARESETN] [get_bd_pins ps7_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_100M/peripheral_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins mii_to_rmii_0/phy2rmii_rx_er] [get_bd_pins xlconstant_0/dout]

  # Create address segments
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
preplace inst xlconstant_0 -pg 1 -lvl 5 -y 620 -defaultsOSRD
preplace inst gpio_leds -pg 1 -lvl 4 -y 70 -defaultsOSRD
preplace inst ps7 -pg 1 -lvl 1 -y -250 -defaultsOSRD
preplace inst rst_ps7_100M -pg 1 -lvl 2 -y -120 -defaultsOSRD
preplace inst mii_to_rmii_0 -pg 1 -lvl 5 -y 480 -defaultsOSRD
preplace inst ps7_axi_periph -pg 1 -lvl 3 -y -160 -defaultsOSRD
preplace inst ethernetlite_0 -pg 1 -lvl 4 -y 550 -defaultsOSRD
preplace inst gpio_btns -pg 1 -lvl 4 -y 200 -defaultsOSRD
preplace inst gpio_sws -pg 1 -lvl 4 -y -160 -defaultsOSRD
preplace netloc gpio_leds_GPIO 1 4 2 NJ 70 N
preplace netloc processing_system7_0_DDR 1 1 5 NJ -400 NJ -400 NJ -400 NJ -400 NJ
preplace netloc ps7_axi_periph_M02_AXI 1 3 1 950
preplace netloc mii_to_rmii_0_rmii2phy_tx_en 1 5 1 1500
preplace netloc ref_clk_i_1 1 4 2 NJ 700 N
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 3 1 990
preplace netloc processing_system7_0_M_AXI_GP0 1 1 2 NJ -280 N
preplace netloc rmii_crs_dv_1 1 5 1 N
preplace netloc processing_system7_0_FCLK_RESET0_N 1 1 1 250
preplace netloc ethernetlite_0_phy_rst_n 1 4 1 1240
preplace netloc ps7_ETH_REF_CLK 1 1 5 NJ -370 NJ -370 NJ -370 N -370 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 2 2 640 -340 960
preplace netloc ps7_axi_periph_M01_AXI 1 3 1 970
preplace netloc mii_to_rmii_0_rmii2phy_txd 1 5 1 1500
preplace netloc xlconstant_0_dout 1 5 1 1490
preplace netloc gpio_btns_GPIO 1 4 2 NJ 200 N
preplace netloc processing_system7_0_FIXED_IO 1 1 5 NJ -380 NJ -380 NJ -380 NJ -380 NJ
preplace netloc rmii_rxd_1 1 5 1 N
preplace netloc axi_gpio_0_GPIO 1 4 2 NJ -160 N
preplace netloc ethernetlite_0_MII 1 4 1 1230
preplace netloc processing_system7_0_FCLK_CLK0 1 0 4 -150 -390 270 -360 630 -360 980
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 2 1 620
preplace netloc ps7_axi_periph_M03_AXI 1 3 1 940
levelinfo -pg 1 -170 50 450 790 1110 1370 1520 -top -420 -bot 780
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


