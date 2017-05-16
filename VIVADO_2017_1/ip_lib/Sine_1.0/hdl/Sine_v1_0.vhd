library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.modulator_pkg.all;

entity Sine_v1_0 is
    generic (
    revision_number             : std_logic_vector(31 downto 0) := x"04142017";
    -- threshold value for counter
    cntampl_value_g             : integer := 255;
    -- it's value should be equal to (2^depth)-1
    -- the number of samples in one period of the signal
    depth_g                     : integer range 1 to 99 := 8;
    -- the number of bits used to represent amplitude
    width_g                     : integer range 1 to 99 := 12;
    C_ctrl_saxi_DATA_WIDTH      : integer    := 32;
    C_ctrl_saxi_ADDR_WIDTH      : integer    := 4);
    port (
    pwm_o                       : out std_logic;
    sine_out                    : out std_logic_vector(width_g-1 downto 0); -- current amplitude value of the
    freq_trig_so                : out std_logic;
    ctrl_saxi_aclk              : in std_logic;
    ctrl_saxi_aresetn           : in std_logic;
    ctrl_saxi_awaddr            : in std_logic_vector(C_ctrl_saxi_ADDR_WIDTH-1 downto 0);
    ctrl_saxi_awprot            : in std_logic_vector(2 downto 0);
    ctrl_saxi_awvalid           : in std_logic;
    ctrl_saxi_awready           : out std_logic;
    ctrl_saxi_wdata             : in std_logic_vector(C_ctrl_saxi_DATA_WIDTH-1 downto 0);
    ctrl_saxi_wstrb             : in std_logic_vector((C_ctrl_saxi_DATA_WIDTH/8)-1 downto 0);
    ctrl_saxi_wvalid            : in std_logic;
    ctrl_saxi_wready            : out std_logic;
    ctrl_saxi_bresp             : out std_logic_vector(1 downto 0);
    ctrl_saxi_bvalid            : out std_logic;
    ctrl_saxi_bready            : in std_logic;
    ctrl_saxi_araddr            : in std_logic_vector(C_ctrl_saxi_ADDR_WIDTH-1 downto 0);
    ctrl_saxi_arprot            : in std_logic_vector(2 downto 0);
    ctrl_saxi_arvalid           : in std_logic;
    ctrl_saxi_arready           : out std_logic;
    ctrl_saxi_rdata             : out std_logic_vector(C_ctrl_saxi_DATA_WIDTH-1 downto 0);
    ctrl_saxi_rresp             : out std_logic_vector(1 downto 0);
    ctrl_saxi_rvalid            : out std_logic;
    ctrl_saxi_rready            : in std_logic);
end Sine_v1_0;
architecture arch_imp of Sine_v1_0 is

    component Sine_v1_0_ctrl_saxi is
    generic (
    C_S_AXI_DATA_WIDTH      : integer    := 32;
    C_S_AXI_ADDR_WIDTH      : integer    := 4);
    port (
    sw0                     : out std_logic;
    div_factor_freqhigh     : out std_logic_vector(31 downto 0);
    div_factor_freqlow      : out std_logic_vector(31 downto 0);
    sine_in                 : in std_logic_vector(31 downto 0);
    pwm                     : in std_logic;
    freq_trig               : in std_logic;
    amplitude_counter       : in std_logic_vector(7 downto 0);
    S_AXI_ACLK              : in std_logic;
    S_AXI_ARESETN           : in std_logic;
    S_AXI_AWADDR            : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWPROT            : in std_logic_vector(2 downto 0);
    S_AXI_AWVALID           : in std_logic;
    S_AXI_AWREADY           : out std_logic;
    S_AXI_WDATA             : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB             : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID            : in std_logic;
    S_AXI_WREADY            : out std_logic;
    S_AXI_BRESP             : out std_logic_vector(1 downto 0);
    S_AXI_BVALID            : out std_logic;
    S_AXI_BREADY            : in std_logic;
    S_AXI_ARADDR            : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARPROT            : in std_logic_vector(2 downto 0);
    S_AXI_ARVALID           : in std_logic;
    S_AXI_ARREADY           : out std_logic;
    S_AXI_RDATA             : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP             : out std_logic_vector(1 downto 0);
    S_AXI_RVALID            : out std_logic;
    S_AXI_RREADY            : in std_logic);
    end component Sine_v1_0_ctrl_saxi;
    component frequency_trigger is
    port (
        clk_in                  : in std_logic;
        sw0                     : in std_logic;
        div_factor_freqhigh     : in std_logic_vector(31 downto 0);
        div_factor_freqlow      : in std_logic_vector(31 downto 0);
        freq_trig               : out std_logic);
    end component frequency_trigger;
    
    component sine is
    generic (
        depth_g                 : integer range 1 to 99 := 8;
        width_g                 : integer range 1 to 99 := 12);
    port (
        clk_in                  : in std_logic;
        ampl_cnt                : in std_logic_vector(depth_g - 1 downto 0);
        sine_outo               : out std_logic_vector(width_g - 1 downto 0);
        sine_out                : out std_logic_vector(width_g - 1 downto 0));
    end component sine;
    
    component counter is
    generic (
        cnt_value_g             : integer;
        depth_g                 : integer);
    port (
        clk_in                  : in std_logic;
        cnt_en                  : in std_logic;
        cnt_out                 : out std_logic_vector (depth_g - 1 downto 0));
    end component counter;  
    component pwm is
    generic (
        width_g             : integer);
    port (
        clk_in              : in std_logic;                       -- input clock signal
        sw0                 : in std_logic;                       -- signal made for selecting frequency
        sine_ampl           : in std_logic_vector(width_g-1 downto 0); -- current amplitude value of the
                                                                       -- sine signal
        div_factor_freqhigh : in std_logic_vector(31 downto 0);   -- input clock division when sw0 = '1'
        div_factor_freqlow  : in std_logic_vector(31 downto 0);   -- input clock division when sw0 = '0'
        pwm_out             : out std_logic );                      -- pulse width modulated signal
    end component pwm;      
    ----------------------------------------------
    --\ frequency_trigger
    ----------------------------------------------
    constant sw                 :  std_logic := '1'; 
    constant freqhigh           :  std_logic_vector(31 downto 0):= X"000000FF"; -- threshold value for high frequency
    constant freqlow            :  std_logic_vector(31 downto 0):= X"0000000F"; -- threshold value for low frequency   
    signal board_name_g         :  string := "zedboard";
    signal design_setting_g     :  design_setting_t_rec := design_setting_c;
    signal ampl_cnt_s           :  std_logic_vector(depth_g-1 downto 0) := (others=>'0'); -- amplitude counter
    signal freq_trig_s          :  std_logic := '0';
    signal pwm_s                :  std_logic := '0';    
    
    ----------------------------------------------
    --\ frequency_trigger
    ----------------------------------------------
    signal sw0                  :  std_logic := '0';         -- signal used for selecting frequency
    signal div_factor_freqhigh  :  std_logic_vector(31 downto 0):= X"000000FF"; -- threshold value for high frequency
    signal div_factor_freqlow   :  std_logic_vector(31 downto 0):= X"0000000F"; -- threshold value for low frequency    
    signal sine_in              :  std_logic_vector(31 downto 0);    
    signal sine_outo            :  std_logic_vector(width_g-1 downto 0);  
    signal GNDs                 :  std_logic_vector(19 downto 0) := (others=>'0'); -- amplitude counter    
    
begin

    u1_Sine: Sine_v1_0_ctrl_saxi
    generic map (
    C_S_AXI_DATA_WIDTH    => C_ctrl_saxi_DATA_WIDTH,
    C_S_AXI_ADDR_WIDTH    => C_ctrl_saxi_ADDR_WIDTH)
    port map (
    -----------------------------------------------------
    sw0                 => sw0,
    div_factor_freqhigh => div_factor_freqhigh,
    div_factor_freqlow  => div_factor_freqlow,
    sine_in             => sine_in,
    pwm                 => pwm_s,
    freq_trig           => freq_trig_s,
    amplitude_counter   => ampl_cnt_s,
    -----------------------------------------------------
    S_AXI_ACLK          => ctrl_saxi_aclk,
    S_AXI_ARESETN       => ctrl_saxi_aresetn,
    S_AXI_AWADDR        => ctrl_saxi_awaddr,
    S_AXI_AWPROT        => ctrl_saxi_awprot,
    S_AXI_AWVALID       => ctrl_saxi_awvalid,
    S_AXI_AWREADY       => ctrl_saxi_awready,
    S_AXI_WDATA         => ctrl_saxi_wdata,
    S_AXI_WSTRB         => ctrl_saxi_wstrb,
    S_AXI_WVALID        => ctrl_saxi_wvalid,
    S_AXI_WREADY        => ctrl_saxi_wready,
    S_AXI_BRESP         => ctrl_saxi_bresp,
    S_AXI_BVALID        => ctrl_saxi_bvalid,
    S_AXI_BREADY        => ctrl_saxi_bready,
    S_AXI_ARADDR        => ctrl_saxi_araddr,
    S_AXI_ARPROT        => ctrl_saxi_arprot,
    S_AXI_ARVALID       => ctrl_saxi_arvalid,
    S_AXI_ARREADY       => ctrl_saxi_arready,
    S_AXI_RDATA         => ctrl_saxi_rdata,
    S_AXI_RRESP         => ctrl_saxi_rresp,
    S_AXI_RVALID        => ctrl_saxi_rvalid,
    S_AXI_RREADY        => ctrl_saxi_rready);
    ----------------------------------------------
    --\ frequency_trigger
    ----------------------------------------------
    u2_freq_ce: frequency_trigger
    port map(
    clk_in              => ctrl_saxi_aclk,
    sw0                 => sw0,
    div_factor_freqhigh => div_factor_freqhigh,
    div_factor_freqlow  => div_factor_freqlow,
    freq_trig           => freq_trig_s);
    ----------------------------------------------
    --\ counter
    ----------------------------------------------
    u3_counterampl : counter 
    generic map(
    cnt_value_g  => cntampl_value_g,
    depth_g      => depth_g)
    port map(
    clk_in       => ctrl_saxi_aclk,
    cnt_en       => freq_trig_s,
    cnt_out      => ampl_cnt_s);
    ----------------------------------------------
    --\ sine
    ----------------------------------------------
    u4_sine: sine
    generic map(
    depth_g   => depth_g, -- the number of samples in one period of the signal
    width_g   => width_g) -- the number of bits used to represent amplitude value
    port map(
    clk_in    => ctrl_saxi_aclk,  -- input clock signal
    ampl_cnt  => ampl_cnt_s,      -- address value for the sine waveform ROM
    sine_out  => sine_out,        -- address value for the sine waveform ROM
    sine_outo => sine_outo);      -- current amplitude value of the sine signal
    
    dut2 :pwm
    generic map(
    width_g             => width_g)
    port map(
    clk_in              => ctrl_saxi_aclk,
    sw0                 => sw0,
    sine_ampl           => sine_outo,
    div_factor_freqhigh => div_factor_freqhigh,
    div_factor_freqlow  => div_factor_freqlow,
    pwm_out             => pwm_s);

    sine_in      <= "00000000000000000000" & sine_outo;
    freq_trig_so <= freq_trig_s;
    pwm_o        <= pwm_s;
    
end arch_imp;
