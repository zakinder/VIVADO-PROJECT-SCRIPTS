----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2013 09:58:03
-- Design Name: 
-- Module Name: TRISTATEIO - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

library UNISIM;
    use UNISIM.VComponents.all;

entity ZYNQ_STARTUP is 
        generic (
            C_CLK_BUF_TYPE : integer range 0 to 3 := 1;
            C_INCLUDE_INTF : boolean := false
      );
        port ( 
        --
        --
        --
        user_clk : out STD_LOGIC; -- User clock optionally buffered with BUFG
        user_clkdiv : out STD_LOGIC; -- User clock divided and optionally buffered with BUFG
        
        user_reset : out STD_LOGIC; 
        user_resetn : out STD_LOGIC;  
        --
        -- STARTUP Primitive full export
        --
        CFGCLK : out STD_LOGIC;
        CFGMCLK : out STD_LOGIC;
        
        USRCCLKO: in STD_LOGIC := '0';
        USRCCLKTS: in STD_LOGIC := '1';

        USRDONEO: in STD_LOGIC := '0';
        USRDONETS: in STD_LOGIC := '1';
        
        CLK: in STD_LOGIC;
        GSR: in STD_LOGIC;
        GTS: in STD_LOGIC;
        
        KEYCLEARB: in STD_LOGIC;
        PACK: in STD_LOGIC;
        PREQ : out STD_LOGIC;
        EOS : out STD_LOGIC
	);

  attribute SIGIS                	: string ;
  attribute SIGIS of user_clk       : signal is "Clk";
  attribute SIGIS of user_clkdiv    : signal is "Clk";  
  attribute SIGIS of user_reset     : signal is "Rst";
  attribute SIGIS of user_resetn    : signal is "Rst";
  
  --attribute SIGIS of ip2intc_irpt  	: signal is "INTR_LEVEL_HIGH";
	
	
end ZYNQ_STARTUP;

architecture Behavioral of ZYNQ_STARTUP is

signal CFGMCLK_i: std_logic;

signal resetn_i: std_logic;
signal reset_i: std_logic;

signal clk_i: std_logic;

begin
   user_clk <= clk_i;
   user_clkdiv  <= clk_i;
   
   
   FDCE_inst : FDCE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')  
   port map (
      Q => resetn_i,      -- Data output
      C => clk_i,      -- Clock input
      CE => '1',    -- Clock enable input
      CLR => '0',  -- Asynchronous clear input
      D => '1'       -- Data input
   );   

   FDPE_inst : FDPE
   generic map (
      INIT => '1') -- Initial value of register ('0' or '1')  
   port map (
      Q => reset_i,      -- Data output
      C => clk_i,      -- Clock input
      CE => '1',    -- Clock enable input
      PRE => '0',  -- Asynchronous preset input
      D => '0'       -- Data input
   );   
   
   
   user_reset  <= '0'; --reset_i;
   user_resetn <= '1'; --resetn_i; 
   
   --
   -- route out
   --
   CFGMCLK <= clk_i;

nobuf_gen: if C_CLK_BUF_TYPE=0 generate
    clk_i     <= CFGMCLK_i;
end generate nobuf_gen;   

   
BUFG_gen: if C_CLK_BUF_TYPE=1 generate

   BUFG_inst : BUFG
   port map (
      O => clk_i, -- 1-bit output: Clock output
      I => CFGMCLK_i  -- 1-bit input: Clock input
   );    
    
end generate BUFG_gen;   

   --
   --
   --  
   STARTUPE2_inst : STARTUPE2
   generic map (
      PROG_USR => "FALSE",  -- Activate program event security feature. Requires encrypted bitstreams.
      SIM_CCLK_FREQ => 0.0  -- Set the Configuration Clock Frequency(ns) for simulation.
   )
   port map (
      CFGCLK    => CFGCLK,       -- 1-bit output: Configuration main clock output
      CFGMCLK   => CFGMCLK_i,     -- 1-bit output: Configuration internal oscillator clock output
      EOS       => EOS,             -- 1-bit output: Active high output signal indicating the End Of Startup.
      PREQ      => PREQ,           -- 1-bit output: PROGRAM request to fabric output
      CLK       => CLK,             -- 1-bit input: User start-up clock input
      GSR       => GSR,             -- 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
      GTS       => GTS,             -- 1-bit input: Global 3-state input (GTS cannot be used for the port name)
      KEYCLEARB => KEYCLEARB, -- 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      PACK      => PACK,           -- 1-bit input: PROGRAM acknowledge input
      USRCCLKO  => USRCCLKO,   -- 1-bit input: User CCLK input
      USRCCLKTS => USRCCLKTS, -- 1-bit input: User CCLK 3-state enable input
      USRDONEO  => USRDONEO,   -- 1-bit input: User DONE pin output control
      USRDONETS => USRDONETS  -- 1-bit input: User DONE 3-state enable output
   );

	
end Behavioral;
