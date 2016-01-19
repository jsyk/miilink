#!/bin/bash -f
xv_path="/home/jara/Xilinx/Vivado/2015.3"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 2b837effdd90478d893ffae854d25771 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L axi_lite_ipif_v3_0_3 -L lib_cdc_v1_0_2 -L interrupt_control_v3_1_2 -L axi_gpio_v2_0_8 -L proc_sys_reset_v5_0_8 -L generic_baseblocks_v2_1_0 -L axi_infrastructure_v1_1_0 -L axi_register_slice_v2_1_6 -L fifo_generator_v13_0_0 -L axi_data_fifo_v2_1_5 -L axi_crossbar_v2_1_7 -L blk_mem_gen_v8_3_0 -L lib_bmg_v1_0_2 -L lib_fifo_v1_0_3 -L axi_ethernetlite_v3_0_4 -L mii_to_rmii_v2_0_8 -L axi_protocol_converter_v2_1_6 -L unisims_ver -L unimacro_ver -L secureip --snapshot ZynqDesign_wrapper_behav xil_defaultlib.ZynqDesign_wrapper xil_defaultlib.glbl -log elaborate.log
