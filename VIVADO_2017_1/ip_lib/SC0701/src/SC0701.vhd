----------------------------------------------------------------------------------
-- Company: zynq Electronic GmbH
-- Engineer: Antti Lukats / John Hartfiel 
-- 
-- Create Date: 17.09.2016 xx:xx:xx
-- Design Name: 
-- Module Name: SC0701 - Behavioral
-- Project Name: 
-- Target Devices:  ZQ-Modules with baseboard TE0701
-- Tool Versions: 2016.2
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.1  
-- Additional Comments:
--  Modified Copy from SC0808BF  IP
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity SC0701 is 
    Generic (
      C_CLK_DIV         : integer range 0 to 5          := 0;--Div0,Div2,Div4...
      C_PCB_REV         : integer range 1 to 5          := 1;
      C_CPLD_REV        : integer range 0 to 1          := 0; --0OLD, 1:CC0701_RGPIO_V1
       
      C_LED_CFG         : integer range 0 to 2          := 1; --0:off,1:ON,2user controlled
      C_RGPIO_MODI      : integer range 0 to 2          := 0; --0:OFF,1:ON,2Debug
      
      C_I2C_INTF        : integer range 0 to 2          := 0; --0:Wire,1:Bus,2:OFF
      C_HDMI_I2C_INTF   : integer range 0 to 2          := 0; --0:Wire,1:Bus,2:OFF
      C_HDMI_INTF       : integer range 0 to 2          := 0; --0:OFF ,1:ON
      C_PHY_LED_CFG     : integer range 0 to 1          := 0; --0:OFF ,1:ON
      
      
      --
      C_PMOD_GROUP      : integer range 0 to 1          := 0; --0:OFF ,1:ON
      C_BUTTON_GROUP    : integer range 0 to 1          := 0; --0:OFF ,1:ON
      C_CM_GROUP        : integer range 0 to 1          := 0; --0:OFF ,1:ON
      C_OTHER_GROUP     : integer range 0 to 1          := 0; --0:OFF ,1:ON
      
     
      C_GENERIC  : integer range 0 to 3          := 1
    );
    Port ( 
		-----------------------------------------------------
		--------------------FPGAIO-BUS Ports
		--
		-- HDMI 
		--
    HDMI_CEC_CLK : out std_logic;
    HDMI_CT_HPD  : out std_logic;
    HDMI_LS_OE   : out std_logic;
    HDMI_INT     : in  std_logic;
		--
		-- HDMI I2C
		--
    HDMI_SCL_I : in std_logic;
    HDMI_SCL_O : out std_logic;
    HDMI_SCL_T : out std_logic;
    HDMI_SDA_I : in std_logic;
    HDMI_SDA_O : out std_logic;
    HDMI_SDA_T : out std_logic;
    --
		-- 3 Wire I2C to FMC I2C via cpld
		--
		Y0  : OUT std_logic;   -- fmc i2c scl
		Y1  : IN  std_logic;   -- fmc i2c sda in
		Y5  : OUT std_logic;   -- fmc i2c sda out
		-----------------------------------------------------
		Y6 : OUT std_logic;   -- LED1/RFU
		X6 : OUT std_logic;   -- LED2 :( can not use if FMC disabled!
		-----------------------------------------------------
		--
		-- RGPIO Signals, CPLD is Clock Slave!
		--
		Y2  : OUT std_logic;   --  RGPIO Clock    /PHY_LED1
		Y3  : IN  std_logic;   -- RGPIO RXD        
		Y4  : OUT std_logic;   -- RGPIO TXD /PHY_LED2

		-----------------------------------------------------
		--------------------Fabric Signals
    --
    --Debug ddrspi_master
    --
	  DBG_RGPIO_OUT     : out  std_logic_vector(31 downto 0); --
    DBG_RGPIO_IN      : in  std_logic_vector(31 downto 0); --	    
    --
    --ddrspi_master CLK
    --
  	SYS_CLOCK   : in  std_logic;  -- 
	  SYS_RESETN  : in  std_logic;  -- 
    --
    -- FMC I2C Slave Interface Bus
    --
    SCL_I : OUT std_logic;
    SCL_O : IN std_logic;
    SCL_T : IN std_logic;
    SDA_I : OUT std_logic;
    SDA_O : IN std_logic;
    SDA_T : IN std_logic;
    -- FMC I2C Slave Interface Lanes
    FMC_SCL_O : IN std_logic;
    FMC_SDA_O : IN std_logic;
    FMC_SDA_I : OUT std_logic;
    --
    -- HDMI I2C Slave Interface Bus
    --
    BSCL_I : OUT std_logic;
    BSCL_O : IN std_logic;
    BSCL_T : IN std_logic;
    BSDA_I : OUT std_logic;
    BSDA_O : IN std_logic;
    BSDA_T : IN std_logic;
    --
    --HDMI I2C Slave Interface Lanes
    --
    USR_HDMI_SCL_I : OUT std_logic;
    USR_HDMI_SCL_O : IN std_logic;
    USR_HDMI_SCL_T : IN std_logic;
    USR_HDMI_SDA_I : OUT std_logic;
    USR_HDMI_SDA_O : IN std_logic;
    USR_HDMI_SDA_T : IN std_logic;
		--
		-- USR HDMI 
		--
    USR_HDMI_CEC_CLK : in std_logic;
    USR_HDMI_CT_HPD  : in std_logic;
    USR_HDMI_LS_OE   : in std_logic;
    USR_HDMI_INT     : out  std_logic;
    --
    -- LED
    --                     --   old version --  rgpio rev1
    LED_D1 : in std_logic; --  not NOSEQ    or rgpio_out(0);
    LED_D2 : in std_logic; --  '0'          or rgpio_out(1);
    LED_D3 : in std_logic; --  not BDBUS0   or rgpio_out(2);
    LED_D4 : in std_logic; --  not MIO15    or rgpio_out(3);
    LED_D5 : in std_logic; --  BOOTMODE     or rgpio_out(4);
    LED_D6 : in std_logic; -- '0'           or rgpio_out(5);
    LED_D7 : in std_logic; -- Y6            or rgpio_out(6);
    LED_D8 : in std_logic; -- X6            or rgpio_out(7);
    
    PHY_LED1 : in std_logic; -- Y2          or rgpio_out(8);
    PHY_LED2 : in std_logic; -- Y4          or rgpio_out(9);
    --
    -- Button
    --   
    S1  : out std_logic;
    S2  : out std_logic;
    --
    -- FMC_PWR-SWTICH
    --   
    M2  : out std_logic;
    M1  : out std_logic;
    --
    -- PMOD
    --  
    MIO10 : out std_logic;
    MIO11 : out std_logic;
    MIO12 : out std_logic;
    MIO13 : out std_logic;
    
    MIO14 : out std_logic;
    MIO15 : out std_logic;
    PX6   : out std_logic;
    PX7   : out std_logic;
    --
    -- Others
    --  
    SD_WP     : out std_logic;
    SD_DETECT : out std_logic;
    USB_OC    : out std_logic;
    POK_FMC   : out std_logic;
    
    FMC_PRSNT : out std_logic;
    PGOOD     : out std_logic;
    NOSEQ     : out std_logic;
    
    X6_RB        : out std_logic;
    Y6_RB        : out std_logic;
    SCL_RB       : out std_logic;
    SDA_RB       : out std_logic;
    
    ADBUS7    : out std_logic;
    --
    --Status
    --
	  ERROR       : out std_logic
	);

	
	
end SC0701;

architecture Behavioral of SC0701 is


signal rgpio_clk : std_logic; 		
signal rgpio_txd : std_logic; 		
signal rgpio_rxd : std_logic; 		

signal rgpio_out : std_logic_vector(31 downto 0); 		
signal rgpio_in : std_logic_vector(31 downto 0); 		

signal rgpio_active : std_logic; 	
signal rgpio_active_code : std_logic_vector(3 downto 0) := "1010"; 
	
signal led_i : std_logic_vector(7 downto 0); 		


signal c_sys_clk : std_logic;



begin
--clk selection
clk_0_gen: if(C_CLK_DIV=0) generate
  c_sys_clk <= SYS_CLOCK;
end generate;
clk_greater_gen: if(C_CLK_DIV>0) generate
signal c_clk_div_i : std_logic_vector(C_CLK_DIV-1 downto 0) := (others =>'0');			
begin
  clk_diff_proc: process (SYS_CLOCK)
  begin
    if (rising_edge(SYS_CLOCK)) then
      c_clk_div_i <= c_clk_div_i + std_logic_vector(to_unsigned(1,C_CLK_DIV));
    end if;
  end process;
  c_sys_clk <= c_clk_div_i(C_CLK_DIV-1);
end generate;
---------------------------------------------------------------------
-- Slave CPLD / PHY LED1 and 2
--
  --old rev or rgpio disabled
  --
  phy_only_gen : if (C_CPLD_REV=0 and C_RGPIO_MODI=0) generate
    Y2         <= PHY_LED1;
    Y4         <= PHY_LED2;
  end generate;
  --newer rev or rgpio enabled
  rgpio_only_gen : if (C_CPLD_REV>0 or C_RGPIO_MODI>0) generate
    Y2         <= rgpio_clk;
    Y4         <= rgpio_txd;
  end generate;

    rgpio_rxd  <= Y3;

i_ddrspi_SC2 : entity work.ddrspi_master
port map ( 
  clk           => c_sys_clk,
  resetn        => SYS_RESETN,


  data_in        => rgpio_in,
  data_out       => rgpio_out,
     
  ready          => open,
  valid          => open,
     
  TX_CLK      	=> rgpio_clk,
  RX_DATA       => rgpio_rxd,
  TX_DATA       => rgpio_txd
);
------------------------
-- Modi
--
RGPIO_MODI_DEBUG : if(C_RGPIO_MODI=2) generate
   DBG_RGPIO_OUT <= rgpio_out;
   rgpio_in <= DBG_RGPIO_IN;	    
   rgpio_active <= '1' when (rgpio_out(31 downto 28) = rgpio_active_code) else '0'; 
  -- Status
   ERROR <= not rgpio_active;  
end generate;
RGPIO_MODI_ON : if(C_RGPIO_MODI=1) generate
   DBG_RGPIO_OUT <= (others => '0');
   --activation code
   rgpio_in(31 downto 28) <= rgpio_active_code;	
   rgpio_active <= '1' when (rgpio_out(31 downto 28) = rgpio_active_code) else '0'; 
  -- Status
  ERROR <= not rgpio_active;  
  --CPLD-REV
  CPLD_RGPIO_REV1 : if(C_CPLD_REV=1) generate
    rgpio_in(7 downto 0) <= led_i;
    rgpio_in(8) <= PHY_LED1;
    rgpio_in(9) <= PHY_LED2;
    --
    -- PMOD
    --  
    MIO10 <= rgpio_out(0);
    MIO11 <= rgpio_out(1);
    MIO12 <= rgpio_out(2);
    MIO13 <= rgpio_out(3);
    
    MIO14 <= rgpio_out(4);
    MIO15 <= rgpio_out(5);
    PX6   <= rgpio_out(6);
    PX7   <= rgpio_out(7);
    --
    -- Button
    --   
    S1    <= rgpio_out(8);
    S2    <= rgpio_out(9);
    --
    -- FMC_PWR-SWTICH
    --   
    M2    <= rgpio_out(11);
    M1    <= rgpio_out(10);
    --
    -- Others
    --  
    SD_WP      <= rgpio_out(12);
    SD_DETECT  <= rgpio_out(13);
    USB_OC     <= rgpio_out(14);
    POK_FMC    <= rgpio_out(15);
    
    FMC_PRSNT  <= rgpio_out(16);
    PGOOD      <= rgpio_out(17);
    NOSEQ      <= rgpio_out(18);
    
    X6_RB     <= rgpio_out(19);
    Y6_RB     <= rgpio_out(20);
    SCL_RB    <= rgpio_out(21);
    SDA_RB    <= rgpio_out(22);
    
    ADBUS7     <= rgpio_out(27);
  end generate;
  CPLD_OLD_REV : if(C_CPLD_REV=0) generate
    rgpio_in(27 downto 0) <= (others => '0');
  end generate;
end generate;
RGPIO_MODI_OFF : if(C_RGPIO_MODI=0) generate
   DBG_RGPIO_OUT <= (others => '0');
   rgpio_in <= (others => '0');	  
  -- Status
  ERROR <= '0';  
end generate;

---------------------------------------------------------------------
-- FMC I2C
--
I2CWIRE_GEN : if (C_I2C_INTF=0) generate
  Y0      <= FMC_SCL_O;
  Y5      <= FMC_SDA_O;
  FMC_SDA_I <= Y1;
end generate;
I2CBUS_GEN : if (C_I2C_INTF=1) generate
signal scl : std_logic; 		
begin
    scl   <=  SCL_O when SCL_T='0' else '1';
    SCL_I <= scl;
		Y0    <= scl;   -- i2c scl
		SDA_I <=  Y1   when SDA_T='1' else SDA_O;   -- i2c sda in
		Y5    <= SDA_O when SDA_T='0' else '1';   -- i2c sda out

end generate;
---------------------------------------------------------------------
-- HDMI I2C
--
HDMI2ICWIRE_GEN : if (C_HDMI_I2C_INTF=0) generate	
begin
  USR_HDMI_SCL_I  <= HDMI_SCL_I;
  HDMI_SCL_O      <= USR_HDMI_SCL_O;
  HDMI_SCL_T      <= USR_HDMI_SCL_T;
  USR_HDMI_SDA_I  <= HDMI_SDA_I;
  HDMI_SDA_O      <= USR_HDMI_SDA_O;
  HDMI_SDA_T      <= USR_HDMI_SDA_T;
end generate;
HDMII2CBUS_GEN : if (C_HDMI_I2C_INTF=1) generate
begin
  BSCL_I      <= HDMI_SCL_I;
  HDMI_SCL_O  <= BSCL_O;
  HDMI_SCL_T  <= BSCL_T;
  BSDA_I      <= HDMI_SDA_I;
  HDMI_SDA_O  <= BSDA_O;
  HDMI_SDA_T  <= BSDA_T;
end generate;
---------------------------------------------------------------------
-- HDMI
--
  HDMI_CEC_CLK <= USR_HDMI_CEC_CLK;
  HDMI_CT_HPD  <= USR_HDMI_CT_HPD;
  HDMI_LS_OE   <= USR_HDMI_LS_OE;
  USR_HDMI_INT <= HDMI_INT;
---------------------------------------------------------------------
-- LED Configuration
--
Y6 <= led_i(7);
X6 <= led_i(6);

LED_CFG_0: if C_LED_CFG = 0 generate
   led_i <= x"00";
end generate LED_CFG_0;  
LED_CFG_1: if C_LED_CFG = 1 generate
   led_i <= x"ff";
end generate LED_CFG_1;     

LED_CFG_2: if C_LED_CFG > 1 generate
   led_i <= (LED_D8 & LED_D7 & LED_D6 & LED_D5 & LED_D4 & LED_D3 & LED_D2 & LED_D1);
end generate LED_CFG_2;     

end Behavioral;
