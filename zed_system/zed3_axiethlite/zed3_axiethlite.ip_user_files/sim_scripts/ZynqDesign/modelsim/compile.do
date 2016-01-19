vlib work
vlib msim

vlib msim/xil_defaultlib
vlib msim/axi_lite_ipif_v3_0_3
vlib msim/lib_cdc_v1_0_2
vlib msim/interrupt_control_v3_1_2
vlib msim/axi_gpio_v2_0_8
vlib msim/proc_sys_reset_v5_0_8
vlib msim/generic_baseblocks_v2_1_0
vlib msim/axi_infrastructure_v1_1_0
vlib msim/axi_register_slice_v2_1_6
vlib msim/fifo_generator_v13_0_0
vlib msim/axi_data_fifo_v2_1_5
vlib msim/axi_crossbar_v2_1_7
vlib msim/blk_mem_gen_v8_3_0
vlib msim/lib_bmg_v1_0_2
vlib msim/lib_fifo_v1_0_3
vlib msim/axi_ethernetlite_v3_0_4
vlib msim/mii_to_rmii_v2_0_8
vlib msim/axi_bram_ctrl_v4_0_5
vlib msim/axi_protocol_converter_v2_1_6

vmap xil_defaultlib msim/xil_defaultlib
vmap axi_lite_ipif_v3_0_3 msim/axi_lite_ipif_v3_0_3
vmap lib_cdc_v1_0_2 msim/lib_cdc_v1_0_2
vmap interrupt_control_v3_1_2 msim/interrupt_control_v3_1_2
vmap axi_gpio_v2_0_8 msim/axi_gpio_v2_0_8
vmap proc_sys_reset_v5_0_8 msim/proc_sys_reset_v5_0_8
vmap generic_baseblocks_v2_1_0 msim/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_6 msim/axi_register_slice_v2_1_6
vmap fifo_generator_v13_0_0 msim/fifo_generator_v13_0_0
vmap axi_data_fifo_v2_1_5 msim/axi_data_fifo_v2_1_5
vmap axi_crossbar_v2_1_7 msim/axi_crossbar_v2_1_7
vmap blk_mem_gen_v8_3_0 msim/blk_mem_gen_v8_3_0
vmap lib_bmg_v1_0_2 msim/lib_bmg_v1_0_2
vmap lib_fifo_v1_0_3 msim/lib_fifo_v1_0_3
vmap axi_ethernetlite_v3_0_4 msim/axi_ethernetlite_v3_0_4
vmap mii_to_rmii_v2_0_8 msim/mii_to_rmii_v2_0_8
vmap axi_bram_ctrl_v4_0_5 msim/axi_bram_ctrl_v4_0_5
vmap axi_protocol_converter_v2_1_6 msim/axi_protocol_converter_v2_1_6

vlog -work xil_defaultlib -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_arb_wr.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_arb_rd.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_arb_wr_4.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_arb_rd_4.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_arb_hp2_3.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_arb_hp0_1.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_ssw_hp.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_sparse_mem.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_reg_map.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_ocm_mem.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_intr_wr_mem.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_intr_rd_mem.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_fmsw_gp.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_regc.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_ocmc.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_interconnect_model.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_gen_reset.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_gen_clock.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_ddrc.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_axi_slave.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_axi_master.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_afi_slave.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl/processing_system7_bfm_v2_0_processing_system7_bfm.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0/sim/ZynqDesign_processing_system7_0_0.v" \
"./../../../bd/ZynqDesign/hdl/ZynqDesign.v" \

vcom -work axi_lite_ipif_v3_0_3 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/ipif_pkg.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/pselect_f.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/address_decoder.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/slave_attachment.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_lite_ipif_v3_0/hdl/src/vhdl/axi_lite_ipif.vhd" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/lib_cdc_v1_0/hdl/src/vhdl/cdc_sync.vhd" \

vcom -work interrupt_control_v3_1_2 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/interrupt_control_v3_1/hdl/src/vhdl/interrupt_control.vhd" \

vcom -work axi_gpio_v2_0_8 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_gpio_v2_0/hdl/src/vhdl/gpio_core.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_gpio_v2_0/hdl/src/vhdl/axi_gpio.vhd" \

vcom -work xil_defaultlib -64 -93 \
"./../../../bd/ZynqDesign/ip/ZynqDesign_axi_gpio_0_0/sim/ZynqDesign_axi_gpio_0_0.vhd" \

vcom -work proc_sys_reset_v5_0_8 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/upcnt_n.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/sequence_psr.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/lpf.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/proc_sys_reset_v5_0/hdl/src/vhdl/proc_sys_reset.vhd" \

vcom -work xil_defaultlib -64 -93 \
"./../../../bd/ZynqDesign/ip/ZynqDesign_rst_processing_system7_0_100M_0/sim/ZynqDesign_rst_processing_system7_0_100M_0.vhd" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_axi_gpio_0_1/sim/ZynqDesign_axi_gpio_0_1.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_and.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_latch_and.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_latch_or.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry_or.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_carry.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_command_fifo.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_mask_static.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_mask.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_mask_static.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_mask.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel_static.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_sel.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator_static.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_comparator.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_mux_enc.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_mux.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/generic_baseblocks_v2_1/hdl/verilog/generic_baseblocks_v2_1_nto1_mux.v" \

vlog -work axi_infrastructure_v1_1_0 -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog/axi_infrastructure_v1_1_axi2vector.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog/axi_infrastructure_v1_1_axic_srl_fifo.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog/axi_infrastructure_v1_1_vector2axi.v" \

vlog -work axi_register_slice_v2_1_6 -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_register_slice_v2_1/hdl/verilog/axi_register_slice_v2_1_axic_register_slice.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_register_slice_v2_1/hdl/verilog/axi_register_slice_v2_1_axi_register_slice.v" \

vcom -work fifo_generator_v13_0_0 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/fifo_generator_v13_0/simulation/fifo_generator_vhdl_beh.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/fifo_generator_v13_0/hdl/fifo_generator_v13_0_rfs.vhd" \

vlog -work axi_data_fifo_v2_1_5 -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axic_fifo.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_fifo_gen.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axic_srl_fifo.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axic_reg_srl_fifo.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_ndeep_srl.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_data_fifo_v2_1/hdl/verilog/axi_data_fifo_v2_1_axi_data_fifo.v" \

vlog -work axi_crossbar_v2_1_7 -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_addr_arbiter_sasd.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_addr_arbiter.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_addr_decoder.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_arbiter_resp.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_crossbar_sasd.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_crossbar.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_decerr_slave.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_si_transactor.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_splitter.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_wdata_mux.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_wdata_router.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_crossbar_v2_1/hdl/verilog/axi_crossbar_v2_1_axi_crossbar.v" \

vlog -work xil_defaultlib -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_xbar_0/sim/ZynqDesign_xbar_0.v" \

vcom -work xil_defaultlib -64 -93 \
"./../../../bd/ZynqDesign/ip/ZynqDesign_axi_gpio_0_2/sim/ZynqDesign_axi_gpio_0_2.vhd" \

vcom -work blk_mem_gen_v8_3_0 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/blk_mem_gen_v8_3/simulation/blk_mem_gen_v8_3.vhd" \

vcom -work lib_bmg_v1_0_2 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/lib_bmg_v1_0/hdl/src/vhdl/blk_mem_gen_wrapper.vhd" \

vcom -work lib_fifo_v1_0_3 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/lib_fifo_v1_0/hdl/src/vhdl/async_fifo_fg.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/lib_fifo_v1_0/hdl/src/vhdl/sync_fifo_fg.vhd" \

vcom -work axi_ethernetlite_v3_0_4 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/ld_arith_reg.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/mux_onehot_f.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/mac_pkg.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/lfsr16.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/defer_state.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/crcnibshiftreg.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/cntr5bit.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/tx_statemachine.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/tx_intrfce.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/rx_statemachine.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/rx_intrfce.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/ram16x4.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/msh_cnt.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/deferral.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/crcgentx.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/crcgenrx.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/bocntr.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/transmit.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/receive.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/macaddrram.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/mdio_if.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/emac_dpram.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/emac.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/xemac.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/axi_interface.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_ethernetlite_v3_0/hdl/src/vhdl/axi_ethernetlite.vhd" \

vcom -work xil_defaultlib -64 -93 \
"./../../../bd/ZynqDesign/ip/ZynqDesign_axi_ethernetlite_0_0/sim/ZynqDesign_axi_ethernetlite_0_0.vhd" \

vcom -work mii_to_rmii_v2_0_8 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/rx_fifo_loader.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/rx_fifo_disposer.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/rx_fifo.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/srl_fifo.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/rmii_tx_fixed.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/rmii_tx_agile.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/rmii_rx_fixed.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/rmii_rx_agile.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/mii_to_rmii_v2_0/hdl/src/vhdl/mii_to_rmii.vhd" \

vcom -work xil_defaultlib -64 -93 \
"./../../../bd/ZynqDesign/ip/ZynqDesign_mii_to_rmii_0_0/sim/ZynqDesign_mii_to_rmii_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../bd/ZynqDesign/ipshared/xilinx.com/xlconstant_v1_1/xlconstant.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_xlconstant_0_0/sim/ZynqDesign_xlconstant_0_0.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_clk_wiz_0_0/ZynqDesign_clk_wiz_0_0_clk_wiz.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_clk_wiz_0_0/ZynqDesign_clk_wiz_0_0.v" \

vcom -work axi_bram_ctrl_v4_0_5 -64 -93 \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/srl_fifo.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/axi_bram_ctrl_funcs.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/coregen_comp_defs.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/axi_lite_if.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/checkbit_handler_64.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/checkbit_handler.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/correct_one_bit_64.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/correct_one_bit.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/xor18.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/parity.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/ecc_gen.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/lite_ecc_reg.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/axi_lite.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/sng_port_arb.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/ua_narrow.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/wrap_brst.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/rd_chnl.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/wr_chnl.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/full_axi.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/axi_bram_ctrl_top.vhd" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_bram_ctrl_v4_0/hdl/vhdl/axi_bram_ctrl.vhd" \

vcom -work xil_defaultlib -64 -93 \
"./../../../bd/ZynqDesign/ip/ZynqDesign_axi_bram_ctrl_0_0/sim/ZynqDesign_axi_bram_ctrl_0_0.vhd" \

vlog -work axi_protocol_converter_v2_1_6 -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_a_axi3_conv.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_axi3_conv.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_axilite_conv.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_r_axi3_conv.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_w_axi3_conv.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b_downsizer.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_decerr_slave.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_simple_fifo.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_wrap_cmd.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_incr_cmd.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_wr_cmd_fsm.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_rd_cmd_fsm.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_cmd_translator.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_b_channel.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_r_channel.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_aw_channel.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s_ar_channel.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_b2s.v" \
"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_protocol_converter_v2_1/hdl/verilog/axi_protocol_converter_v2_1_axi_protocol_converter.v" \

vlog -work xil_defaultlib -64 -incr +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/axi_infrastructure_v1_1/hdl/verilog" +incdir+"../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ipshared/xilinx.com/processing_system7_bfm_v2_0/hdl" +incdir+"../../../bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../../zed3_eth.srcs/sources_1/bd/ZynqDesign/ip/ZynqDesign_processing_system7_0_0" +incdir+"./../../../ipstatic/axi_infrastructure_v1_1/hdl/verilog" +incdir+"./../../../ipstatic/processing_system7_bfm_v2_0/hdl" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_auto_pc_0/sim/ZynqDesign_auto_pc_0.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_auto_pc_1/sim/ZynqDesign_auto_pc_1.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_auto_pc_2/sim/ZynqDesign_auto_pc_2.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_auto_pc_3/sim/ZynqDesign_auto_pc_3.v" \
"./../../../bd/ZynqDesign/ip/ZynqDesign_auto_pc_4/sim/ZynqDesign_auto_pc_4.v" \

vlog -work xil_defaultlib "glbl.v"

