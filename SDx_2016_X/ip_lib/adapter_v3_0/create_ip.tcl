#remove any old files from previous run
exec rm -rf component.xml
exec rm -rf xgui

###################################################
#generate HDL files
###########
source -notrace generate.tcl

set num 128

gen_adapter $num
gen_scalar $num
gen_infifo $num
gen_outfifo $num
gen_outbram $num
gen_inbram $num
gen_top $num


###################################################
#create ip
###########
#create project
create_project project_1 . -part xc7z020clg484-1
set_property board_part xilinx.com:zc702:part0:1.2 [current_project]

#set magic settings
#### this one is to enable the fifo_generator instantiation
set_property XPM_LIBRARIES {XPM_FIFO} [current_project]

#add hdl files
add_files ./hdl

#package the project as an IP
ipx::package_project -root_dir ./ -vendor xilinx.com -library user -taxonomy /UserIP

#configure info settings for IP
set_property library ip [ipx::current_core]
set_property name adapter_v3_0 [ipx::current_core]
set_property display_name adapter_v3_0 [ipx::current_core]
set_property description adapter_v3_0 [ipx::current_core]
set_property vendor_display_name {Xilinx Inc.} [ipx::current_core]
set_property company_url http://www.xilinx.com [ipx::current_core]
set_property taxonomy /BaseIP [ipx::current_core]
set_property supported_families {} [ipx::current_core]
set_property supported_families {virtex7 Beta qvirtex7 Beta kintex7 Beta kintex7l Beta qkintex7 Beta qkintex7l Beta artix7 Beta artix7l Beta aartix7 Beta qartix7 Beta zynq Beta qzynq Beta azynq Beta spartan7 Beta virtexu Beta virtexuplus Beta kintexuplus Beta zynquplus Beta kintexu Beta} [ipx::current_core]

#remove any auto-created buses
set existing_buses [ipx::get_bus_interfaces]
for {set idx 0} {$idx < [llength $existing_buses]} {incr idx} {
    set bus [lindex $existing_buses $idx]
    set name [lindex $bus 2]
    #remove any axis fifo buses
    if {[string first "s_axis_fifo_" $name] > -1} {
	ipx::remove_bus_interface $name [ipx::current_core]
    }
    if {[string first "m_axis_fifo_" $name] > -1} {
	ipx::remove_bus_interface $name [ipx::current_core]
    }
    if {[string first "m_axis_bram_" $name] > -1} {
	ipx::remove_bus_interface $name [ipx::current_core]
    }
    if {[string first "s_axis_bram_" $name] > -1} {
	ipx::remove_bus_interface $name [ipx::current_core]
    }
    if {[string first "m_axis_bramio_" $name] > -1} {
	ipx::remove_bus_interface $name [ipx::current_core]
    }
}

#remove associated buses to aclk that have been removed
set_property value {} [ipx::get_bus_parameters ASSOCIATED_BUSIF -of_objects [ipx::get_bus_interfaces aclk -of_objects [ipx::current_core]]]

#configure ap_ctrl bus
ipx::add_bus_interface ap_ctrl [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:acc_handshake_rtl:1.0 [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:acc_handshake:1.0 [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property display_name ap_ctrl [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property description ap_ctrl [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
ipx::add_port_map start [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property physical_name ap_start [ipx::get_port_maps start -of_objects [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]]
ipx::add_port_map done [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property physical_name ap_done [ipx::get_port_maps done -of_objects [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]]
ipx::add_port_map idle [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property physical_name ap_idle [ipx::get_port_maps idle -of_objects [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]]
ipx::add_port_map ready [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property physical_name ap_ready [ipx::get_port_maps ready -of_objects [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]]
ipx::add_port_map continue [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]
set_property physical_name ap_continue [ipx::get_port_maps continue -of_objects [ipx::get_bus_interfaces ap_ctrl -of_objects [ipx::current_core]]]

#configure input scalar ports
for {set idx 0} {$idx < $num} {incr idx} {
    set portName "ap_iscalar_${idx}_dout"
    set_property driver_value 0 [ipx::get_ports $portName -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_N_INPUT_SCALARS')) > $idx" [ipx::get_ports $portName -of_objects [ipx::current_core]]
}

#configure output scalar ports
for {set idx 0} {$idx < $num} {incr idx} {
    set portName "ap_oscalar_${idx}_din"
    set_property driver_value 0 [ipx::get_ports ${portName} -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_N_OUTPUT_SCALARS')) > $idx" [ipx::get_ports $portName -of_objects [ipx::current_core]]

    set validName "ap_oscalar_${idx}_vld"
    set_property driver_value 0 [ipx::get_ports $validName -of_objects [ipx::current_core]]
    if {$idx == 0} {
	set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_N_OUTPUT_SCALARS')) > $idx and spirit:decode(id('MODELPARAM_VALUE.C_HAS_RETURN')) = 0" [ipx::get_ports $validName -of_objects [ipx::current_core]]
    } else {
	set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_N_OUTPUT_SCALARS')) > $idx" [ipx::get_ports $validName -of_objects [ipx::current_core]]
    }
}

#configure input AXIS_FIFO ports 
for {set idx 0} {$idx < $num} {incr idx} {
    set axis_name "S_AXIS_FIFO_$idx"
    set axis_tdata_name "s_axis_fifo_${idx}_tdata"
    set axis_tvalid_name "s_axis_fifo_${idx}_tvalid"
    set axis_tlast_name "s_axis_fifo_${idx}_tlast"
    set axis_tready_name "s_axis_fifo_${idx}_tready"
    set axis_tstrb_name "s_axis_fifo_${idx}_tstrb"
    set axis_tkeep_name "s_axis_fifo_${idx}_tkeep"

    set fifo_name "AP_FIFO_IARG_${idx}"
    set fifo_dout_name "ap_fifo_iarg_${idx}_dout"
    set fifo_read_name "ap_fifo_iarg_${idx}_read"
    set fifo_empty_name "ap_fifo_iarg_${idx}_empty_n"

    #configure input AXIS interface
    ipx::add_bus_interface $axis_name [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property interface_mode slave [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_INPUT_FIFOs')) > $idx" [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    ipx::associate_bus_interfaces -busif $axis_name -clock s_axi_aclk [ipx::current_core]

    #add input AXIS ports
    ipx::add_port_map TDATA [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tdata_name [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TVALID [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tvalid_name [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TLAST [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tlast_name [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TREADY [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tready_name [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TSTRB [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tstrb_name [ipx::get_port_maps TSTRB -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TKEEP [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tkeep_name [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]

    #configure input FIFO interface
    ipx::add_bus_interface $fifo_name [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:interface:acc_fifo_read_rtl:1.0 [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:interface:acc_fifo_read:1.0 [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property interface_mode slave [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_INPUT_FIFOs')) > $idx" [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]

    #add input FIFO ports
    ipx::add_port_map RD_DATA [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property physical_name $fifo_dout_name [ipx::get_port_maps RD_DATA -of_objects [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]]
    ipx::add_port_map RD_EN [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property physical_name $fifo_read_name [ipx::get_port_maps RD_EN -of_objects [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]]
    ipx::add_port_map EMPTY_N [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property physical_name $fifo_empty_name [ipx::get_port_maps EMPTY_N -of_objects [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]]

    #set default values
    set_property driver_value 0 [ipx::get_ports $fifo_read_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $axis_tdata_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $axis_tvalid_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $axis_tlast_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $axis_tstrb_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $axis_tkeep_name -of_objects [ipx::current_core]]
}

#configure output AXIS_FIFO ports 
for {set idx 0} {$idx < $num} {incr idx} {
    set axis_name "M_AXIS_FIFO_$idx"
    set axis_tdata_name "m_axis_fifo_${idx}_tdata"
    set axis_tvalid_name "m_axis_fifo_${idx}_tvalid"
    set axis_tlast_name "m_axis_fifo_${idx}_tlast"
    set axis_tready_name "m_axis_fifo_${idx}_tready"
    set axis_tstrb_name "m_axis_fifo_${idx}_tstrb"
    set axis_tkeep_name "m_axis_fifo_${idx}_tkeep"

    set fifo_name "AP_FIFO_OARG_${idx}"
    set fifo_dout_name "ap_fifo_oarg_${idx}_din"
    set fifo_read_name "ap_fifo_oarg_${idx}_write"
    set fifo_empty_name "ap_fifo_oarg_${idx}_full_n"

    #configure output AXIS interface
    ipx::add_bus_interface $axis_name [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property interface_mode master [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_OUTPUT_FIFOs')) > $idx" [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    ipx::associate_bus_interfaces -busif $axis_name -clock s_axi_aclk [ipx::current_core]

    #add output AXIS ports
    ipx::add_port_map TDATA [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tdata_name [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TVALID [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tvalid_name [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TLAST [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tlast_name [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TREADY [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tready_name [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TSTRB [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tstrb_name [ipx::get_port_maps TSTRB -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TKEEP [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tkeep_name [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]

    #configure output FIFO interface
    ipx::add_bus_interface $fifo_name [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:interface:acc_fifo_write_rtl:1.0 [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:interface:acc_fifo_write:1.0 [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property interface_mode slave [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_OUTPUT_FIFOs')) > $idx" [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]

    #add output FIFO ports
    ipx::add_port_map WR_DATA [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property physical_name $fifo_dout_name [ipx::get_port_maps WR_DATA -of_objects [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]]
    ipx::add_port_map WR_EN [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property physical_name $fifo_read_name [ipx::get_port_maps WR_EN -of_objects [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]]
    ipx::add_port_map FULL_N [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]
    set_property physical_name $fifo_empty_name [ipx::get_port_maps FULL_N -of_objects [ipx::get_bus_interfaces $fifo_name -of_objects [ipx::current_core]]]

    #set default values
    set_property driver_value 0 [ipx::get_ports $fifo_dout_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $fifo_read_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $axis_tready_name -of_objects [ipx::current_core]]
}

#configure INPUT BRAM ports 
for {set idx 0} {$idx < $num} {incr idx} {
    #set parameters for address bit width
    set_property value_tcl_expr "expr {ceil((log(\${C_INPUT_BRAM_${idx}_DEPTH}) + log(\${C_INPUT_BRAM_${idx}_WIDTH}/8)) / \[expr log(2)\])}" [ipx::get_user_parameters C_INPUT_BRAM_${idx}_ADDR_WIDTH -of_objects [ipx::current_core]]
    set_property enablement_value false [ipx::get_user_parameters C_INPUT_BRAM_${idx}_ADDR_WIDTH -of_objects [ipx::current_core]]

    set s_axis_name "S_AXIS_BRAM_$idx"
    set s_axis_tdata_name "s_axis_bram_${idx}_tdata"
    set s_axis_tvalid_name "s_axis_bram_${idx}_tvalid"
    set s_axis_tlast_name "s_axis_bram_${idx}_tlast"
    set s_axis_tready_name "s_axis_bram_${idx}_tready"
    set s_axis_tstrb_name "s_axis_bram_${idx}_tstrb"
    set s_axis_tkeep_name "s_axis_bram_${idx}_tkeep"

    #configure input AXIS interface
    ipx::add_bus_interface $s_axis_name [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property interface_mode slave [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_INPUT_BRAMs')) > $idx" [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    ipx::associate_bus_interfaces -busif $s_axis_name -clock s_axi_aclk [ipx::current_core]

    #add input AXIS ports
    ipx::add_port_map TDATA [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $s_axis_tdata_name [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TVALID [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $s_axis_tvalid_name [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TLAST [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $s_axis_tlast_name [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TREADY [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $s_axis_tready_name [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TSTRB [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $s_axis_tstrb_name [ipx::get_port_maps TSTRB -of_objects [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TKEEP [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $s_axis_tkeep_name [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces $s_axis_name -of_objects [ipx::current_core]]]  

    #set default values
    set_property driver_value 0 [ipx::get_ports $s_axis_tdata_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $s_axis_tvalid_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $s_axis_tlast_name -of_objects [ipx::current_core]]
    set_property driver_value 0 [ipx::get_ports $s_axis_tstrb_name -of_objects [ipx::current_core]]
    set_property driver_value 1 [ipx::get_ports $s_axis_tkeep_name -of_objects [ipx::current_core]]
    set_property driver_value 1 [ipx::get_ports $s_axis_tstrb_name -of_objects [ipx::current_core]]

    #setup bram ports
    for {set bp 0} {$bp < 2} {incr bp} {
	set bram_name "AP_BRAM_IARG_${idx}_${bp}"
	set bram_din "ap_bram_iarg_${idx}_din${bp}"
	set bram_en "ap_bram_iarg_${idx}_en${bp}"
	set bram_dout "ap_bram_iarg_${idx}_dout${bp}"
	set bram_we "ap_bram_iarg_${idx}_we${bp}"
	set bram_addr "ap_bram_iarg_${idx}_addr${bp}"
	set bram_rst "ap_bram_iarg_${idx}_rst${bp}"
	set bram_clk "ap_bram_iarg_${idx}_clk${bp}"
	
	#setup bram port
	ipx::add_bus_interface $bram_name [ipx::current_core]
	set_property abstraction_type_vlnv xilinx.com:interface:bram_rtl:1.0 [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property bus_type_vlnv xilinx.com:interface:bram:1.0 [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property display_name $bram_name [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property description $bram_name [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_INPUT_BRAMs')) > ${idx} and spirit:decode(id('MODELPARAM_VALUE.C_INPUT_BRAM_${idx}_PORTS')) > ${bp}" [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]

	#add parameters to port
	ipx::add_bus_parameter MASTER_TYPE [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property value BRAM_CTRL [ipx::get_bus_parameters MASTER_TYPE -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]

	#add signals to port
	ipx::add_port_map DIN [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_din [ipx::get_port_maps DIN -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map EN [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_en [ipx::get_port_maps EN -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map DOUT [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_dout [ipx::get_port_maps DOUT -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map WE [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_we [ipx::get_port_maps WE -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map ADDR [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_addr [ipx::get_port_maps ADDR -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map RST [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_rst [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map CLK [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_clk [ipx::get_port_maps CLK -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]

	#set default values
	set_property driver_value 0 [ipx::get_ports $bram_din -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_en -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_we -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_addr -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_rst -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_clk -of_objects [ipx::current_core]]
    }

    set m_axis_name "M_AXIS_BRAMIO_$idx"
    set m_axis_tdata_name "m_axis_bramio_${idx}_tdata"
    set m_axis_tvalid_name "m_axis_bramio_${idx}_tvalid"
    set m_axis_tlast_name "m_axis_bramio_${idx}_tlast"
    set m_axis_tready_name "m_axis_bramio_${idx}_tready"
    set m_axis_tstrb_name "m_axis_bramio_${idx}_tstrb"
    set m_axis_tkeep_name "m_axis_bramio_${idx}_tkeep"

    #configure output AXIS interface
    ipx::add_bus_interface $m_axis_name [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property interface_mode master [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_INPUT_BRAMs')) > $idx and spirit:decode(id('MODELPARAM_VALUE.C_BRAM_${idx}_IS_INOUT')) > 0" [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    ipx::associate_bus_interfaces -busif $m_axis_name -clock s_axi_aclk [ipx::current_core]

    #add output AXIS ports
    ipx::add_port_map TDATA [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $m_axis_tdata_name [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TVALID [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $m_axis_tvalid_name [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TLAST [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $m_axis_tlast_name [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TREADY [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $m_axis_tready_name [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TSTRB [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $m_axis_tstrb_name [ipx::get_port_maps TSTRB -of_objects [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TKEEP [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]
    set_property physical_name $m_axis_tkeep_name [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces $m_axis_name -of_objects [ipx::current_core]]]

    #set default values
    set_property driver_value 0 [ipx::get_ports $m_axis_tready_name -of_objects [ipx::current_core]]
}

#configure OUTPUT BRAM ports 
for {set idx 0} {$idx < $num} {incr idx} {
    #set parameters for address bit width
    set_property value_tcl_expr "expr {ceil((log(\${C_OUTPUT_BRAM_${idx}_DEPTH}) + log(\${C_OUTPUT_BRAM_${idx}_WIDTH}/8)) / \[expr log(2)\])}" [ipx::get_user_parameters C_OUTPUT_BRAM_${idx}_ADDR_WIDTH -of_objects [ipx::current_core]]    
    set_property enablement_value false [ipx::get_user_parameters C_OUTPUT_BRAM_${idx}_ADDR_WIDTH -of_objects [ipx::current_core]]

    set axis_name "M_AXIS_BRAM_$idx"
    set axis_tdata_name "m_axis_bram_${idx}_tdata"
    set axis_tvalid_name "m_axis_bram_${idx}_tvalid"
    set axis_tlast_name "m_axis_bram_${idx}_tlast"
    set axis_tready_name "m_axis_bram_${idx}_tready"
    set axis_tstrb_name "m_axis_bram_${idx}_tstrb"
    set axis_tkeep_name "m_axis_bram_${idx}_tkeep"

    #configure output AXIS interface
    ipx::add_bus_interface $axis_name [ipx::current_core]
    set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property interface_mode master [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_OUTPUT_BRAMs')) > $idx" [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    ipx::associate_bus_interfaces -busif $axis_name -clock s_axi_aclk [ipx::current_core]

    #add output AXIS ports
    ipx::add_port_map TDATA [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tdata_name [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TVALID [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tvalid_name [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TLAST [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tlast_name [ipx::get_port_maps TLAST -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TREADY [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tready_name [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TSTRB [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tstrb_name [ipx::get_port_maps TSTRB -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]
    ipx::add_port_map TKEEP [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]
    set_property physical_name $axis_tkeep_name [ipx::get_port_maps TKEEP -of_objects [ipx::get_bus_interfaces $axis_name -of_objects [ipx::current_core]]]

    #set default values
    set_property driver_value 0 [ipx::get_ports $axis_tready_name -of_objects [ipx::current_core]]

    #setup bram ports
    for {set bp 0} {$bp < 2} {incr bp} {
	set bram_name "AP_BRAM_OARG_${idx}_${bp}"
	set bram_din "ap_bram_oarg_${idx}_din${bp}"
	set bram_en "ap_bram_oarg_${idx}_en${bp}"
	set bram_dout "ap_bram_oarg_${idx}_dout${bp}"
	set bram_we "ap_bram_oarg_${idx}_we${bp}"
	set bram_addr "ap_bram_oarg_${idx}_addr${bp}"
	set bram_rst "ap_bram_oarg_${idx}_rst${bp}"
	set bram_clk "ap_bram_oarg_${idx}_clk${bp}"
	
	#setup bram port
	ipx::add_bus_interface $bram_name [ipx::current_core]
	set_property abstraction_type_vlnv xilinx.com:interface:bram_rtl:1.0 [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property bus_type_vlnv xilinx.com:interface:bram:1.0 [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property display_name $bram_name [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property description $bram_name [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property enablement_dependency "spirit:decode(id('MODELPARAM_VALUE.C_NUM_OUTPUT_BRAMs')) > ${idx} and spirit:decode(id('MODELPARAM_VALUE.C_OUTPUT_BRAM_${idx}_PORTS')) > ${bp}" [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]

	#add parameters to port
	ipx::add_bus_parameter MASTER_TYPE [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property value BRAM_CTRL [ipx::get_bus_parameters MASTER_TYPE -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]

	#add signals to port
	ipx::add_port_map DIN [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_din [ipx::get_port_maps DIN -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map EN [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_en [ipx::get_port_maps EN -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map DOUT [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_dout [ipx::get_port_maps DOUT -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map WE [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_we [ipx::get_port_maps WE -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map ADDR [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_addr [ipx::get_port_maps ADDR -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map RST [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_rst [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]
	ipx::add_port_map CLK [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]
	set_property physical_name $bram_clk [ipx::get_port_maps CLK -of_objects [ipx::get_bus_interfaces $bram_name -of_objects [ipx::current_core]]]

	#set default values
	set_property driver_value 0 [ipx::get_ports $bram_din -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_en -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_we -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_addr -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_rst -of_objects [ipx::current_core]]
	set_property driver_value 0 [ipx::get_ports $bram_clk -of_objects [ipx::current_core]]
    }

}

#configure address range
set_property range 4096 [ipx::get_address_blocks reg0 -of_objects [ipx::get_memory_maps S_AXI -of_objects [ipx::current_core]]]

#hide parameters
#set param_list [list C_NUM_RESET_CYCLES C_ACC_RESET_POLARITY C_NUM_INPUT_ARGS C_NUM_OUTPUT_ARGS C_QUEUE_DEPTH C_NUM_INPUT_SCALARS C_NUM_OUTPUT_SCALARS C_NUM_INSCALARS C_NUM_OUTSCALARS C_FIFO_DEPTH C_HAS_RETURN]
#for {set idx 0} {$idx < [llength $param_list]} {incr idx} {
#    set param [lindex $param_list $idx]
#    ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name $param -component [ipx::current_core]]
#}
#for {set idx 0} {$idx < 8} {incr idx} {
#    ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name C_INSCALAR_${idx}_BITS -component [ipx::current_core]]
#    ipgui::remove_param -component [ipx::current_core] [ipgui::get_guiparamspec -name C_OUTSCALAR_${idx}_BITS -component [ipx::current_core]]
#}

#other misc configuration
set_property core_revision 2 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_p
