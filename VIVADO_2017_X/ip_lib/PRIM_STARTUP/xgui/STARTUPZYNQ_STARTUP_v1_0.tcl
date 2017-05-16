# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "Component_Name" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_CLK_BUF_TYPE" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_INCLUDE_INTF" -parent ${Page_0}
}
proc update_PARAM_VALUE.C_CLK_BUF_TYPE { PARAM_VALUE.C_CLK_BUF_TYPE } {
	# Procedure called to update C_CLK_BUF_TYPE when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_CLK_BUF_TYPE { PARAM_VALUE.C_CLK_BUF_TYPE } {
	# Procedure called to validate C_CLK_BUF_TYPE
	return true
}
proc update_PARAM_VALUE.C_INCLUDE_INTF { PARAM_VALUE.C_INCLUDE_INTF } {
	# Procedure called to update C_INCLUDE_INTF when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_INCLUDE_INTF { PARAM_VALUE.C_INCLUDE_INTF } {
	# Procedure called to validate C_INCLUDE_INTF
	return true
}
proc update_MODELPARAM_VALUE.C_CLK_BUF_TYPE { MODELPARAM_VALUE.C_CLK_BUF_TYPE PARAM_VALUE.C_CLK_BUF_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CLK_BUF_TYPE}] ${MODELPARAM_VALUE.C_CLK_BUF_TYPE}
}
proc update_MODELPARAM_VALUE.C_INCLUDE_INTF { MODELPARAM_VALUE.C_INCLUDE_INTF PARAM_VALUE.C_INCLUDE_INTF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_INCLUDE_INTF}] ${MODELPARAM_VALUE.C_INCLUDE_INTF}
}