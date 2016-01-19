#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/jara/Xilinx/SDK/2015.3/bin:/home/jara/Xilinx/Vivado/2015.3/ids_lite/ISE/bin/lin64:/home/jara/Xilinx/Vivado/2015.3/bin
else
  PATH=/home/jara/Xilinx/SDK/2015.3/bin:/home/jara/Xilinx/Vivado/2015.3/ids_lite/ISE/bin/lin64:/home/jara/Xilinx/Vivado/2015.3/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/home/jara/Xilinx/Vivado/2015.3/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/home/jara/Xilinx/Vivado/2015.3/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD=/home/jara/ownCloud-pluto/elektronika/etherlink-hdl/vivado_ip/eth100_link_tx/eth100_link_tx/eth100_link_tx.runs/impl_1
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log iptop_eth100_link_tx.vdi -applog -m64 -messageDb vivado.pb -mode batch -source iptop_eth100_link_tx.tcl -notrace


