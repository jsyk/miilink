# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "FRBUF_MEMBYTE_ADDR_W" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RXFIFO_DEPTH_W" -parent ${Page_0}


}

proc update_PARAM_VALUE.FRBUF_MEMBYTE_ADDR_W { PARAM_VALUE.FRBUF_MEMBYTE_ADDR_W } {
	# Procedure called to update FRBUF_MEMBYTE_ADDR_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FRBUF_MEMBYTE_ADDR_W { PARAM_VALUE.FRBUF_MEMBYTE_ADDR_W } {
	# Procedure called to validate FRBUF_MEMBYTE_ADDR_W
	return true
}

proc update_PARAM_VALUE.RXFIFO_DEPTH_W { PARAM_VALUE.RXFIFO_DEPTH_W } {
	# Procedure called to update RXFIFO_DEPTH_W when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RXFIFO_DEPTH_W { PARAM_VALUE.RXFIFO_DEPTH_W } {
	# Procedure called to validate RXFIFO_DEPTH_W
	return true
}


proc update_MODELPARAM_VALUE.FRBUF_MEMBYTE_ADDR_W { MODELPARAM_VALUE.FRBUF_MEMBYTE_ADDR_W PARAM_VALUE.FRBUF_MEMBYTE_ADDR_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FRBUF_MEMBYTE_ADDR_W}] ${MODELPARAM_VALUE.FRBUF_MEMBYTE_ADDR_W}
}

proc update_MODELPARAM_VALUE.RXFIFO_DEPTH_W { MODELPARAM_VALUE.RXFIFO_DEPTH_W PARAM_VALUE.RXFIFO_DEPTH_W } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RXFIFO_DEPTH_W}] ${MODELPARAM_VALUE.RXFIFO_DEPTH_W}
}

