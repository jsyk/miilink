onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc" -t 1ps -pli "/home/jara/Xilinx/Vivado/2015.3/lib/lnx64.o/libxil_vsim.so" -L unisims_ver -L unimacro_ver -L secureip -L xil_defaultlib -L axi_lite_ipif_v3_0_3 -L lib_cdc_v1_0_2 -L interrupt_control_v3_1_2 -L axi_gpio_v2_0_8 -L proc_sys_reset_v5_0_8 -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_6 -L fifo_generator_v13_0_0 -L axi_data_fifo_v2_1_5 -L axi_crossbar_v2_1_7 -L blk_mem_gen_v8_3_0 -L lib_bmg_v1_0_2 -L lib_fifo_v1_0_3 -L axi_ethernetlite_v3_0_4 -L mii_to_rmii_v2_0_8 -L axi_bram_ctrl_v4_0_5 -L axi_protocol_converter_v2_1_6 -lib xil_defaultlib xil_defaultlib.ZynqDesign xil_defaultlib.glbl

do {wave.do}

view wave
view structure
view signals

do {ZynqDesign.udo}

run -all

quit -force
