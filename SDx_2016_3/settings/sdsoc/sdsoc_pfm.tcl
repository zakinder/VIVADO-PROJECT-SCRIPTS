set pfm [sdsoc::create_pfm ${ZQ::VPROJ_NAME}_hw.pfm]
sdsoc::pfm_name        $pfm "em.avnet.com" "xd" "zed" "1.3"
sdsoc::pfm_description $pfm "Zynq ZedBoard"
sdsoc::pfm_clock       $pfm FCLK_CLK0 processing_system7_0 0 false rst_processing_system7_0_50M
sdsoc::pfm_clock       $pfm FCLK_CLK1 processing_system7_0 1 true rst_processing_system7_0_100M
sdsoc::pfm_clock       $pfm FCLK_CLK2 processing_system7_0 2 false rst_processing_system7_0_125M
sdsoc::pfm_clock       $pfm FCLK_CLK3 processing_system7_0 3 false rst_processing_system7_0_25M
sdsoc::pfm_axi_port    $pfm M_AXI_GP0 processing_system7_0 M_AXI_GP
sdsoc::pfm_axi_port    $pfm M_AXI_GP1 processing_system7_0 M_AXI_GP
sdsoc::pfm_axi_port    $pfm S_AXI_ACP processing_system7_0 S_AXI_ACP
sdsoc::pfm_axi_port    $pfm S_AXI_HP0 processing_system7_0 S_AXI_HP
sdsoc::pfm_axi_port    $pfm S_AXI_HP1 processing_system7_0 S_AXI_HP
sdsoc::pfm_axi_port    $pfm S_AXI_HP2 processing_system7_0 S_AXI_HP
sdsoc::pfm_axi_port    $pfm S_AXI_HP3 processing_system7_0 S_AXI_HP
for {set i 0} {$i < 16} {incr i} {
  sdsoc::pfm_irq       $pfm In$i xlconcat
}
sdsoc::generate_hw_pfm $pfm

