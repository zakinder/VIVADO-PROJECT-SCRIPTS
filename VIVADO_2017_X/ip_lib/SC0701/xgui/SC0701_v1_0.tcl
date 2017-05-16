# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/SC0701_v1_0.gtcl]
# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Revision [ipgui::add_page $IPINST -name "Revision"]
  ipgui::add_param $IPINST -name "C_PCB_REV" -parent ${Revision}
  ipgui::add_param $IPINST -name "C_CPLD_REV" -parent ${Revision} -widget comboBox
  #Adding Page
  set I2C [ipgui::add_page $IPINST -name "I2C" -display_name {Configuration}]
  set_property tooltip {Configuration} ${I2C}
  #Adding Group
  set RGPIO_Controller [ipgui::add_group $IPINST -name "RGPIO Controller" -parent ${I2C}]
  ipgui::add_param $IPINST -name "C_RGPIO_MODI" -parent ${RGPIO_Controller} -widget comboBox
  ipgui::add_param $IPINST -name "C_CLK_DIV" -parent ${RGPIO_Controller} -widget comboBox
  #Adding Group
  set User_Input_Signals [ipgui::add_group $IPINST -name "User Input Signals" -parent ${I2C} -display_name {User Output Group}]
  set_property tooltip {User output group} ${User_Input_Signals}
  set C_BUTTON_GROUP [ipgui::add_param $IPINST -name "C_BUTTON_GROUP" -parent ${User_Input_Signals} -widget comboBox]
  set_property tooltip {S1 can be used as User-RESET, S2 is JTAG- and FPGA-RESET!} ${C_BUTTON_GROUP}
  set C_CM_GROUP [ipgui::add_param $IPINST -name "C_CM_GROUP" -parent ${User_Input_Signals} -widget comboBox]
  set_property tooltip {DIP-Switch Pins for FMC Power} ${C_CM_GROUP}
  ipgui::add_param $IPINST -name "C_OTHER_GROUP" -parent ${User_Input_Signals} -widget comboBox
  ipgui::add_param $IPINST -name "C_PMOD_GROUP" -parent ${User_Input_Signals} -widget comboBox
  #Adding Group
  set User_Output_Group [ipgui::add_group $IPINST -name "User Output Group" -parent ${I2C} -display_name {User Input  Group}]
  set_property tooltip {User Input  Group} ${User_Output_Group}
  set C_LED_CFG [ipgui::add_param $IPINST -name "C_LED_CFG" -parent ${User_Output_Group} -widget comboBox]
  set_property tooltip {TE0701 LED 1..4 must be powered via jumper and power options, LED 5..8 must be powered viad B2B bank power} ${C_LED_CFG}
  ipgui::add_param $IPINST -name "C_PHY_LED_CFG" -parent ${User_Output_Group} -widget comboBox
  #Adding Group
  set User_IO_Signals [ipgui::add_group $IPINST -name "User IO Signals" -parent ${I2C} -display_name {User IO Group}]
  set_property tooltip {User IO Group} ${User_IO_Signals}
  ipgui::add_param $IPINST -name "C_I2C_INTF" -parent ${User_IO_Signals} -widget comboBox
  ipgui::add_param $IPINST -name "C_HDMI_I2C_INTF" -parent ${User_IO_Signals} -widget comboBox
  ipgui::add_param $IPINST -name "C_HDMI_INTF" -parent ${User_IO_Signals} -widget comboBox
}
proc update_PARAM_VALUE.C_CLK_DIV { PARAM_VALUE.C_CLK_DIV PARAM_VALUE.C_RGPIO_MODI } {
	# Procedure called to update C_CLK_DIV when any of the dependent parameters in the arguments change
	set C_CLK_DIV ${PARAM_VALUE.C_CLK_DIV}
	set C_RGPIO_MODI ${PARAM_VALUE.C_RGPIO_MODI}
	set values(C_RGPIO_MODI) [get_property value $C_RGPIO_MODI]
	if { [gen_USERPARAMETER_C_CLK_DIV_ENABLEMENT $values(C_RGPIO_MODI)] } {
		set_property enabled true $C_CLK_DIV
	} else {
		set_property enabled false $C_CLK_DIV
	}
}
proc validate_PARAM_VALUE.C_CLK_DIV { PARAM_VALUE.C_CLK_DIV } {
	# Procedure called to validate C_CLK_DIV
	return true
}
proc update_PARAM_VALUE.C_RGPIO_MODI { PARAM_VALUE.C_RGPIO_MODI PARAM_VALUE.C_CPLD_REV } {
	# Procedure called to update C_RGPIO_MODI when any of the dependent parameters in the arguments change
	set C_RGPIO_MODI ${PARAM_VALUE.C_RGPIO_MODI}
	set C_CPLD_REV ${PARAM_VALUE.C_CPLD_REV}
	set values(C_CPLD_REV) [get_property value $C_CPLD_REV]
	if { [gen_USERPARAMETER_C_RGPIO_MODI_ENABLEMENT $values(C_CPLD_REV)] } {
		set_property enabled true $C_RGPIO_MODI
	} else {
		set_property enabled false $C_RGPIO_MODI
	}
}
proc validate_PARAM_VALUE.C_RGPIO_MODI { PARAM_VALUE.C_RGPIO_MODI } {
	# Procedure called to validate C_RGPIO_MODI
	return true
}
proc update_PARAM_VALUE.C_BUTTON_GROUP { PARAM_VALUE.C_BUTTON_GROUP } {
	# Procedure called to update C_BUTTON_GROUP when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_BUTTON_GROUP { PARAM_VALUE.C_BUTTON_GROUP } {
	# Procedure called to validate C_BUTTON_GROUP
	return true
}
proc update_PARAM_VALUE.C_CM_GROUP { PARAM_VALUE.C_CM_GROUP } {
	# Procedure called to update C_CM_GROUP when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_CM_GROUP { PARAM_VALUE.C_CM_GROUP } {
	# Procedure called to validate C_CM_GROUP
	return true
}
proc update_PARAM_VALUE.C_CPLD_REV { PARAM_VALUE.C_CPLD_REV } {
	# Procedure called to update C_CPLD_REV when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_CPLD_REV { PARAM_VALUE.C_CPLD_REV } {
	# Procedure called to validate C_CPLD_REV
	return true
}
proc update_PARAM_VALUE.C_GENERIC { PARAM_VALUE.C_GENERIC } {
	# Procedure called to update C_GENERIC when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_GENERIC { PARAM_VALUE.C_GENERIC } {
	# Procedure called to validate C_GENERIC
	return true
}
proc update_PARAM_VALUE.C_HDMI_I2C_INTF { PARAM_VALUE.C_HDMI_I2C_INTF } {
	# Procedure called to update C_HDMI_I2C_INTF when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_HDMI_I2C_INTF { PARAM_VALUE.C_HDMI_I2C_INTF } {
	# Procedure called to validate C_HDMI_I2C_INTF
	return true
}
proc update_PARAM_VALUE.C_HDMI_INTF { PARAM_VALUE.C_HDMI_INTF } {
	# Procedure called to update C_HDMI_INTF when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_HDMI_INTF { PARAM_VALUE.C_HDMI_INTF } {
	# Procedure called to validate C_HDMI_INTF
	return true
}
proc update_PARAM_VALUE.C_I2C_INTF { PARAM_VALUE.C_I2C_INTF } {
	# Procedure called to update C_I2C_INTF when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_I2C_INTF { PARAM_VALUE.C_I2C_INTF } {
	# Procedure called to validate C_I2C_INTF
	return true
}
proc update_PARAM_VALUE.C_LED_CFG { PARAM_VALUE.C_LED_CFG } {
	# Procedure called to update C_LED_CFG when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_LED_CFG { PARAM_VALUE.C_LED_CFG } {
	# Procedure called to validate C_LED_CFG
	return true
}
proc update_PARAM_VALUE.C_OTHER_GROUP { PARAM_VALUE.C_OTHER_GROUP } {
	# Procedure called to update C_OTHER_GROUP when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_OTHER_GROUP { PARAM_VALUE.C_OTHER_GROUP } {
	# Procedure called to validate C_OTHER_GROUP
	return true
}
proc update_PARAM_VALUE.C_PCB_REV { PARAM_VALUE.C_PCB_REV } {
	# Procedure called to update C_PCB_REV when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_PCB_REV { PARAM_VALUE.C_PCB_REV } {
	# Procedure called to validate C_PCB_REV
	return true
}
proc update_PARAM_VALUE.C_PHY_LED_CFG { PARAM_VALUE.C_PHY_LED_CFG } {
	# Procedure called to update C_PHY_LED_CFG when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_PHY_LED_CFG { PARAM_VALUE.C_PHY_LED_CFG } {
	# Procedure called to validate C_PHY_LED_CFG
	return true
}
proc update_PARAM_VALUE.C_PMOD_GROUP { PARAM_VALUE.C_PMOD_GROUP } {
	# Procedure called to update C_PMOD_GROUP when any of the dependent parameters in the arguments change
}
proc validate_PARAM_VALUE.C_PMOD_GROUP { PARAM_VALUE.C_PMOD_GROUP } {
	# Procedure called to validate C_PMOD_GROUP
	return true
}
proc update_MODELPARAM_VALUE.C_PCB_REV { MODELPARAM_VALUE.C_PCB_REV PARAM_VALUE.C_PCB_REV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PCB_REV}] ${MODELPARAM_VALUE.C_PCB_REV}
}
proc update_MODELPARAM_VALUE.C_GENERIC { MODELPARAM_VALUE.C_GENERIC PARAM_VALUE.C_GENERIC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_GENERIC}] ${MODELPARAM_VALUE.C_GENERIC}
}
proc update_MODELPARAM_VALUE.C_LED_CFG { MODELPARAM_VALUE.C_LED_CFG PARAM_VALUE.C_LED_CFG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_LED_CFG}] ${MODELPARAM_VALUE.C_LED_CFG}
}
proc update_MODELPARAM_VALUE.C_CPLD_REV { MODELPARAM_VALUE.C_CPLD_REV PARAM_VALUE.C_CPLD_REV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CPLD_REV}] ${MODELPARAM_VALUE.C_CPLD_REV}
}
proc update_MODELPARAM_VALUE.C_I2C_INTF { MODELPARAM_VALUE.C_I2C_INTF PARAM_VALUE.C_I2C_INTF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_I2C_INTF}] ${MODELPARAM_VALUE.C_I2C_INTF}
}
proc update_MODELPARAM_VALUE.C_HDMI_I2C_INTF { MODELPARAM_VALUE.C_HDMI_I2C_INTF PARAM_VALUE.C_HDMI_I2C_INTF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_HDMI_I2C_INTF}] ${MODELPARAM_VALUE.C_HDMI_I2C_INTF}
}
proc update_MODELPARAM_VALUE.C_HDMI_INTF { MODELPARAM_VALUE.C_HDMI_INTF PARAM_VALUE.C_HDMI_INTF } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_HDMI_INTF}] ${MODELPARAM_VALUE.C_HDMI_INTF}
}
proc update_MODELPARAM_VALUE.C_RGPIO_MODI { MODELPARAM_VALUE.C_RGPIO_MODI PARAM_VALUE.C_RGPIO_MODI } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_RGPIO_MODI}] ${MODELPARAM_VALUE.C_RGPIO_MODI}
}
proc update_MODELPARAM_VALUE.C_PHY_LED_CFG { MODELPARAM_VALUE.C_PHY_LED_CFG PARAM_VALUE.C_PHY_LED_CFG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PHY_LED_CFG}] ${MODELPARAM_VALUE.C_PHY_LED_CFG}
}
proc update_MODELPARAM_VALUE.C_CLK_DIV { MODELPARAM_VALUE.C_CLK_DIV PARAM_VALUE.C_CLK_DIV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CLK_DIV}] ${MODELPARAM_VALUE.C_CLK_DIV}
}
proc update_MODELPARAM_VALUE.C_PMOD_GROUP { MODELPARAM_VALUE.C_PMOD_GROUP PARAM_VALUE.C_PMOD_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_PMOD_GROUP}] ${MODELPARAM_VALUE.C_PMOD_GROUP}
}
proc update_MODELPARAM_VALUE.C_BUTTON_GROUP { MODELPARAM_VALUE.C_BUTTON_GROUP PARAM_VALUE.C_BUTTON_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BUTTON_GROUP}] ${MODELPARAM_VALUE.C_BUTTON_GROUP}
}
proc update_MODELPARAM_VALUE.C_CM_GROUP { MODELPARAM_VALUE.C_CM_GROUP PARAM_VALUE.C_CM_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_CM_GROUP}] ${MODELPARAM_VALUE.C_CM_GROUP}
}
proc update_MODELPARAM_VALUE.C_OTHER_GROUP { MODELPARAM_VALUE.C_OTHER_GROUP PARAM_VALUE.C_OTHER_GROUP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_OTHER_GROUP}] ${MODELPARAM_VALUE.C_OTHER_GROUP}
}