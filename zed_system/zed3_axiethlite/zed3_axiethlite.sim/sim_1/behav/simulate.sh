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
ExecStep $xv_path/bin/xsim ZynqDesign_wrapper_behav -key {Behavioral:sim_1:Functional:ZynqDesign_wrapper} -tclbatch ZynqDesign_wrapper.tcl -log simulate.log
