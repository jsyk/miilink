onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -pli "/home/jara/Xilinx/Vivado/2015.3/lib/lnx64.o/libxil_vsim.so" -lib xil_defaultlib ZynqDesign_opt

do {wave.do}

view wave
view structure
view signals

do {ZynqDesign.udo}

run -all

quit -force
