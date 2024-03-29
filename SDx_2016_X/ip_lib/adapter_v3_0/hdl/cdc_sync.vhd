
--Generic Help
--C_CDC_TYPE : Defines the type of CDC needed
--             0 means pulse synchronizer. Used to transfer one clock pulse 
--               from prmry domain to scndry domain.
--             1 means level synchronizer. Used to transfer level signal.
--             2 means level synchronizer with ack. Used to transfer level 
--               signal. Input signal should change only when prmry_ack is detected
--
--C_FLOP_INPUT : when set to 1 adds one flop stage to the input prmry_in signal
--               Set to 0 when incoming signal is purely floped signal.
--
--C_RESET_STATE : Generally sync flops need not have resets. However, in some cases
--                it might be needed.
--              0 means reset not needed for sync flops 
--              1 means reset needed for sync flops. i
--                In this case prmry_resetn should be in prmry clock, 
--                while scndry_reset should be in scndry clock.
--
--C_SINGLE_BIT : CDC should normally be done for single bit signals only. 
--               However, based on design buses can also be CDC'ed.
--               0 means it is a bus. In this case input be connected to prmry_vect_in.
--                 Output is on scndry_vect_out.
--               1 means it is a single bit. In this case input be connected to prmry_in. 
--                 Output is on scndry_out.
--
--C_VECTOR_WIDTH : defines the size of bus. This is irrelevant when C_SINGLE_BIT = 1
--
--C_MTBF_STAGES : Defines the number of sync stages needed. Allowed values are 0 to 6.
--                Value of 0, 1 is allowed only for level CDC.
--                Min value for Pulse CDC is 2
--
--Whenever this file is used following XDC constraint has to be added 

--         set_false_path -to [get_pins -hier *cdc_to*/D]        


--IO Ports 
--
--        prmry_aclk      : clock of originating domain (source domain)
--        prmry_resetn    : sync reset of originating clock domain (source domain)
--        prmry_in        : input signal bit. This should be a pure flop output without 
--                          any combi logic. This is source. 
--        prmry_vect_in   : bus signal. From Source domain.
--        prmry_ack       : Ack signal, valid for one clock period, in prmry_aclk domain.
--                          Used only when C_CDC_TYPE = 2
--        scndry_aclk     : destination clock.
--        scndry_resetn   : sync reset of destination domain
--        scndry_out      : sync'ed output in destination domain. Single bit.
--        scndry_vect_out : sync'ed output in destination domain. bus.




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;



entity  cdc_sync is
    generic (
        C_CDC_TYPE                  : integer range 0 to 2 := 1                 ;
                                    -- 0 is pulse synch
                                    -- 1 is level synch
                                    -- 2 is ack based level sync
        C_RESET_STATE               : integer range 0 to 1 := 0                 ;
                                    -- 0 is reset not needed 
                                    -- 1 is reset needed 
        C_SINGLE_BIT                : integer range 0 to 1 := 1                 ; 
                                    -- 0 is bus input
                                    -- 1 is single bit input
        C_FLOP_INPUT                : integer range 0 to 1 := 0                 ;
        C_VECTOR_WIDTH              : integer range 0 to 32 := 32                             ;
        C_MTBF_STAGES               : integer range 0 to 6 := 2                 
            -- Vector Data witdth
    );

    port (
        prmry_aclk                  : in  std_logic                             ;               --
        prmry_resetn                : in  std_logic                             ;               --
        prmry_in                    : in  std_logic                             ;               --
        prmry_vect_in               : in  std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)           ;               --
        prmry_ack                   : out std_logic                             ;
                                                                                                --
        scndry_aclk                 : in  std_logic                             ;               --
        scndry_resetn               : in  std_logic                             ;               --
                                                                                                --
        -- Primary to Secondary Clock Crossing                                                  --
        scndry_out                  : out std_logic                             ;               --
                                                                                                --
        scndry_vect_out             : out std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)                           --

    );

end cdc_sync;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of cdc_sync is

    attribute DowngradeIPIdentifiedWarnings: string;
    attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- No Functions Declared

-------------------------------------------------------------------------------
-- Constants Declarations
-------------------------------------------------------------------------------

-- No Constants Declared

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin
-- Generate PULSE clock domain crossing
GENERATE_PULSE_P_S_CDC_OPEN_ENDED : if C_CDC_TYPE = 0 generate

-- Primary to Secondary
signal s_out_d1_cdc_to          : std_logic := '0';
signal s_out_d2             : std_logic := '0';
signal s_out_d3             : std_logic := '0';
signal s_out_d4             : std_logic := '0';
signal s_out_d5             : std_logic := '0';
signal s_out_d6             : std_logic := '0';
signal s_out_d7             : std_logic := '0';
signal s_out_re             : std_logic := '0';
signal prmry_in_xored           : std_logic := '0';
signal p_in_d1_cdc_from     : std_logic := '0';



 -----------------------------------------------------------------------------
  -- ATTRIBUTE Declarations
  -----------------------------------------------------------------------------
  -- Prevent x-propagation on clock-domain crossing register
  ATTRIBUTE async_reg                       : STRING;
  ATTRIBUTE async_reg OF s_out_d1_cdc_to    : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_out_d2       : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_out_d3       : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_out_d4       : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_out_d5       : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_out_d6       : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_out_d7       : SIGNAL IS "true"; 

begin

    --*****************************************************************************
    --**                  Asynchronous Pulse Clock Crossing                      **
    --**                  PRIMARY TO SECONDARY OPEN-ENDED                        **
    --*****************************************************************************

scndry_vect_out <= (others => '0');
prmry_ack <= '0';

prmry_in_xored <= prmry_in xor p_in_d1_cdc_from;
 
    REG_P_IN : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0')then
                    p_in_d1_cdc_from  <= '0';
                else
                    p_in_d1_cdc_from  <= prmry_in_xored;
                end if;
            end if;
        end process REG_P_IN;


    P_IN_CROSS2SCNDRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0' and C_RESET_STATE = 1)then
                    s_out_d1_cdc_to     <= '0';
                    s_out_d2        <= '0';
                    s_out_d3        <= '0';
                    s_out_d4        <= '0';
                    s_out_d5        <= '0';
                    s_out_d6        <= '0';
                    s_out_d7        <= '0';
                    scndry_out          <= '0';
                else
                    s_out_d1_cdc_to     <= p_in_d1_cdc_from;
                    s_out_d2        <= s_out_d1_cdc_to;
                    s_out_d3        <= s_out_d2;
                    s_out_d4        <= s_out_d3;
                    s_out_d5        <= s_out_d4;
                    s_out_d6        <= s_out_d5;
                    s_out_d7        <= s_out_d6;
                    scndry_out          <= s_out_re;
                end if;
            end if;
        end process P_IN_CROSS2SCNDRY;

MTBF_2 : if C_MTBF_STAGES = 2 generate
begin
                    s_out_re  <= s_out_d2 xor s_out_d3;

end generate MTBF_2;

MTBF_3 : if C_MTBF_STAGES = 3 generate
begin
                    s_out_re  <= s_out_d3 xor s_out_d4;

end generate MTBF_3;

MTBF_4 : if C_MTBF_STAGES = 4 generate
begin
                    s_out_re  <= s_out_d4 xor s_out_d5;

end generate MTBF_4;

MTBF_5 : if C_MTBF_STAGES = 5 generate
begin
                    s_out_re  <= s_out_d5 xor s_out_d6;

end generate MTBF_5;

MTBF_6 : if C_MTBF_STAGES = 6 generate
begin
                    s_out_re  <= s_out_d6 xor s_out_d7;

end generate MTBF_6;

   -- Feed secondary pulse out

end generate GENERATE_PULSE_P_S_CDC_OPEN_ENDED;


-- Generate LEVEL clock domain crossing with reset state = 0
GENERATE_LEVEL_P_S_CDC : if C_CDC_TYPE = 1 generate
begin
-- Primary to Secondary

SINGLE_BIT : if C_SINGLE_BIT = 1 generate 

signal p_level_in_d1_cdc_from        : std_logic := '0';
signal p_level_in_int        : std_logic := '0';
signal s_level_out_d1_cdc_to       : std_logic := '0';
signal s_level_out_d2       : std_logic := '0';
signal s_level_out_d3       : std_logic := '0';
signal s_level_out_d4       : std_logic := '0';
signal s_level_out_d5       : std_logic := '0';
signal s_level_out_d6       : std_logic := '0';
 -----------------------------------------------------------------------------
  -- ATTRIBUTE Declarations
  -----------------------------------------------------------------------------
  -- Prevent x-propagation on clock-domain crossing register
  ATTRIBUTE async_reg                      : STRING;
  ATTRIBUTE async_reg OF s_level_out_d1_cdc_to  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d2  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d3  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d4  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d5  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d6  : SIGNAL IS "true"; 

begin

    --*****************************************************************************
    --**                  Asynchronous Level Clock Crossing                      **
    --**                        PRIMARY TO SECONDARY                             **
    --*****************************************************************************
    -- register is scndry to provide clean ff output to clock crossing logic

scndry_vect_out <= (others => '0');
prmry_ack <= '0';


INPUT_FLOP : if C_FLOP_INPUT = 1 generate
begin

    REG_PLEVEL_IN : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0' and C_RESET_STATE = 1)then
                    p_level_in_d1_cdc_from  <= '0';
                else
                    p_level_in_d1_cdc_from  <= prmry_in;
                end if;
            end if;
        end process REG_PLEVEL_IN;

         p_level_in_int <= p_level_in_d1_cdc_from;

end generate INPUT_FLOP;


NO_INPUT_FLOP : if C_FLOP_INPUT = 0 generate
begin

       p_level_in_int <= prmry_in;

end generate NO_INPUT_FLOP;

    CROSS_PLEVEL_IN2SCNDRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0' and C_RESET_STATE = 1)then
                    s_level_out_d1_cdc_to  <= '0';
                    s_level_out_d2  <= '0';
                    s_level_out_d3  <= '0';
                    s_level_out_d4  <= '0';
                    s_level_out_d5  <= '0';
                    s_level_out_d6  <= '0';
                else
                    s_level_out_d1_cdc_to  <= p_level_in_int;
                    s_level_out_d2  <= s_level_out_d1_cdc_to;
                    s_level_out_d3  <= s_level_out_d2;
                    s_level_out_d4  <= s_level_out_d3;
                    s_level_out_d5  <= s_level_out_d4;
                    s_level_out_d6  <= s_level_out_d5;
                end if;
            end if;
        end process CROSS_PLEVEL_IN2SCNDRY;




MTBF_L1 : if C_MTBF_STAGES = 1 generate
begin
    scndry_out <= s_level_out_d1_cdc_to;
                   

end generate MTBF_L1;

MTBF_L2 : if C_MTBF_STAGES = 2 generate
begin

    scndry_out <= s_level_out_d2;
                   

end generate MTBF_L2;

MTBF_L3 : if C_MTBF_STAGES = 3 generate
begin
    
   scndry_out <= s_level_out_d3;



end generate MTBF_L3;

MTBF_L4 : if C_MTBF_STAGES = 4 generate
begin
    scndry_out <= s_level_out_d4;

               

end generate MTBF_L4;

MTBF_L5 : if C_MTBF_STAGES = 5 generate
begin

    scndry_out <= s_level_out_d5;
             

end generate MTBF_L5;

MTBF_L6 : if C_MTBF_STAGES = 6 generate
begin

    scndry_out <= s_level_out_d6;
           

end generate MTBF_L6;

end generate SINGLE_BIT;



MULTI_BIT : if C_SINGLE_BIT = 0 generate 

signal p_level_in_bus_int : std_logic_vector (C_VECTOR_WIDTH - 1 downto 0);
signal p_level_in_bus_d1_cdc_from      : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
signal s_level_out_bus_d1_cdc_to       : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
signal s_level_out_bus_d1_cdc_tig       : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
signal s_level_out_bus_d2       : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
signal s_level_out_bus_d3       : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
signal s_level_out_bus_d4       : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
signal s_level_out_bus_d5       : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
signal s_level_out_bus_d6       : std_logic_vector(C_VECTOR_WIDTH - 1 downto 0);
 -----------------------------------------------------------------------------
  -- ATTRIBUTE Declarations
  -----------------------------------------------------------------------------
  -- Prevent x-propagation on clock-domain crossing register
  ATTRIBUTE async_reg                      : STRING;
  ATTRIBUTE async_reg OF s_level_out_bus_d1_cdc_to  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_bus_d2  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_bus_d3  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_bus_d4  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_bus_d5  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_bus_d6  : SIGNAL IS "true"; 

begin

    --*****************************************************************************
    --**                  Asynchronous Level Clock Crossing                      **
    --**                        PRIMARY TO SECONDARY                             **
    --*****************************************************************************
    -- register is scndry to provide clean ff output to clock crossing logic

scndry_out <= '0';
prmry_ack <= '0';


INPUT_FLOP_BUS : if C_FLOP_INPUT = 1 generate
begin
    REG_PLEVEL_IN : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0' and C_RESET_STATE = 1)then
                    p_level_in_bus_d1_cdc_from  <= (others => '0');
                else
                    p_level_in_bus_d1_cdc_from  <= prmry_vect_in;
                end if;
            end if;
        end process REG_PLEVEL_IN;

            p_level_in_bus_int <= p_level_in_bus_d1_cdc_from;

end generate INPUT_FLOP_BUS;


NO_INPUT_FLOP_BUS : if C_FLOP_INPUT = 0 generate
begin

p_level_in_bus_int <= prmry_vect_in;

end generate NO_INPUT_FLOP_BUS;

    CROSS_PLEVEL_IN2SCNDRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0' and C_RESET_STATE = 1)then
                    s_level_out_bus_d1_cdc_to  <= (others => '0');
                    s_level_out_bus_d2  <= (others => '0');
                    s_level_out_bus_d3  <= (others => '0');
                    s_level_out_bus_d4  <= (others => '0');
                    s_level_out_bus_d5  <= (others => '0');
                    s_level_out_bus_d6  <= (others => '0');
                else
                    s_level_out_bus_d1_cdc_to  <= p_level_in_bus_int;
                    s_level_out_bus_d2  <= s_level_out_bus_d1_cdc_to;
                    s_level_out_bus_d3  <= s_level_out_bus_d2;
                    s_level_out_bus_d4  <= s_level_out_bus_d3;
                    s_level_out_bus_d5  <= s_level_out_bus_d4;
                    s_level_out_bus_d6  <= s_level_out_bus_d5;
                end if;
            end if;
        end process CROSS_PLEVEL_IN2SCNDRY;



MTBF_L1 : if C_MTBF_STAGES = 1 generate
begin

    scndry_vect_out <= s_level_out_bus_d1_cdc_to;
                   

end generate MTBF_L1;

MTBF_L2 : if C_MTBF_STAGES = 2 generate
begin

    scndry_vect_out <= s_level_out_bus_d2;
                   

end generate MTBF_L2;

MTBF_L3 : if C_MTBF_STAGES = 3 generate
begin
    
   scndry_vect_out <= s_level_out_bus_d3;



end generate MTBF_L3;

MTBF_L4 : if C_MTBF_STAGES = 4 generate
begin
    scndry_vect_out <= s_level_out_bus_d4;

               

end generate MTBF_L4;

MTBF_L5 : if C_MTBF_STAGES = 5 generate
begin

    scndry_vect_out <= s_level_out_bus_d5;
             

end generate MTBF_L5;

MTBF_L6 : if C_MTBF_STAGES = 6 generate
begin

    scndry_vect_out <= s_level_out_bus_d6;
           

end generate MTBF_L6;

end generate MULTI_BIT;


end generate GENERATE_LEVEL_P_S_CDC;


GENERATE_LEVEL_ACK_P_S_CDC : if C_CDC_TYPE = 2 generate
-- Primary to Secondary


signal p_level_in_d1_cdc_from        : std_logic := '0';
signal p_level_in_int              : std_logic := '0';
signal s_level_out_d1_cdc_to       : std_logic := '0';
signal s_level_out_d2       : std_logic := '0';
signal s_level_out_d3       : std_logic := '0';
signal s_level_out_d4       : std_logic := '0';
signal s_level_out_d5       : std_logic := '0';
signal s_level_out_d6       : std_logic := '0';
signal p_level_out_d1_cdc_to       : std_logic := '0';
signal p_level_out_d2       : std_logic := '0';
signal p_level_out_d3       : std_logic := '0';
signal p_level_out_d4       : std_logic := '0';
signal p_level_out_d5       : std_logic := '0';
signal p_level_out_d6       : std_logic := '0';
signal p_level_out_d7       : std_logic := '0';
signal scndry_out_int       : std_logic := '0';
signal prmry_pulse_ack      : std_logic := '0';
 -----------------------------------------------------------------------------
  -- ATTRIBUTE Declarations
  -----------------------------------------------------------------------------
  -- Prevent x-propagation on clock-domain crossing register
  ATTRIBUTE async_reg                      : STRING;
  ATTRIBUTE async_reg OF s_level_out_d1_cdc_to  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d2  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d3  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d4  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d5  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF s_level_out_d6  : SIGNAL IS "true"; 

  ATTRIBUTE async_reg OF p_level_out_d1_cdc_to  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF p_level_out_d2  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF p_level_out_d3  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF p_level_out_d4  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF p_level_out_d5  : SIGNAL IS "true"; 
  ATTRIBUTE async_reg OF p_level_out_d6  : SIGNAL IS "true"; 

begin

    --*****************************************************************************
    --**                  Asynchronous Level Clock Crossing                      **
    --**                        PRIMARY TO SECONDARY                             **
    --*****************************************************************************
    -- register is scndry to provide clean ff output to clock crossing logic
scndry_vect_out <= (others => '0');


INPUT_FLOP : if C_FLOP_INPUT = 1 generate
begin

    REG_PLEVEL_IN : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0' and C_RESET_STATE = 1)then
                    p_level_in_d1_cdc_from  <= '0';
                else
                    p_level_in_d1_cdc_from  <= prmry_in;
                end if;
            end if;
        end process REG_PLEVEL_IN;

    p_level_in_int <= p_level_in_d1_cdc_from;

end generate INPUT_FLOP;


NO_INPUT_FLOP : if C_FLOP_INPUT = 0 generate
begin

    p_level_in_int <= prmry_in;

end generate NO_INPUT_FLOP;

    CROSS_PLEVEL_IN2SCNDRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0' and C_RESET_STATE = 1)then
                    s_level_out_d1_cdc_to  <= '0';
                    s_level_out_d2  <= '0';
                    s_level_out_d3  <= '0';
                    s_level_out_d4  <= '0';
                    s_level_out_d5  <= '0';
                    s_level_out_d6  <= '0';
                else
                    s_level_out_d1_cdc_to  <= p_level_in_int;
                    s_level_out_d2  <= s_level_out_d1_cdc_to;
                    s_level_out_d3  <= s_level_out_d2;
                    s_level_out_d4  <= s_level_out_d3;
                    s_level_out_d5  <= s_level_out_d4;
                    s_level_out_d6  <= s_level_out_d5;
                end if;
            end if;
        end process CROSS_PLEVEL_IN2SCNDRY;


    CROSS_PLEVEL_SCNDRY2PRMRY : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0' and C_RESET_STATE = 1)then
                    p_level_out_d1_cdc_to  <= '0';
                    p_level_out_d2  <= '0';
                    p_level_out_d3  <= '0';
                    p_level_out_d4  <= '0';
                    p_level_out_d5  <= '0';
                    p_level_out_d6  <= '0';
                    p_level_out_d7  <= '0';
                    prmry_ack       <= '0';
                else
                    p_level_out_d1_cdc_to  <= scndry_out_int;
                    p_level_out_d2  <= p_level_out_d1_cdc_to;
                    p_level_out_d3  <= p_level_out_d2;
                    p_level_out_d4  <= p_level_out_d3;
                    p_level_out_d5  <= p_level_out_d4;
                    p_level_out_d6  <= p_level_out_d5;
                    p_level_out_d7  <= p_level_out_d6;
                    prmry_ack       <= prmry_pulse_ack;
                end if;
            end if;
        end process CROSS_PLEVEL_SCNDRY2PRMRY;




MTBF_L2 : if C_MTBF_STAGES = 2 or C_MTBF_STAGES = 1 generate
begin

    scndry_out_int <= s_level_out_d2;
    --prmry_pulse_ack <= p_level_out_d3 xor p_level_out_d2;
    prmry_pulse_ack <= (not p_level_out_d3) and p_level_out_d2;
                   

end generate MTBF_L2;

MTBF_L3 : if C_MTBF_STAGES = 3 generate
begin
    
   scndry_out_int <= s_level_out_d3;
   --prmry_pulse_ack <= p_level_out_d4 xor p_level_out_d3;
   prmry_pulse_ack <= (not p_level_out_d4) and p_level_out_d3;



end generate MTBF_L3;

MTBF_L4 : if C_MTBF_STAGES = 4 generate
begin
    scndry_out_int <= s_level_out_d4;
   --prmry_pulse_ack <= p_level_out_d5 xor p_level_out_d4;
   prmry_pulse_ack <= (not p_level_out_d5) and p_level_out_d4;

               

end generate MTBF_L4;

MTBF_L5 : if C_MTBF_STAGES = 5 generate
begin

    scndry_out_int <= s_level_out_d5;
   --prmry_pulse_ack <= p_level_out_d6 xor p_level_out_d5;
   prmry_pulse_ack <= (not p_level_out_d6) and p_level_out_d5;
             

end generate MTBF_L5;

MTBF_L6 : if C_MTBF_STAGES = 6 generate
begin

    scndry_out_int <= s_level_out_d6;
   --prmry_pulse_ack <= p_level_out_d7 xor p_level_out_d6;
   prmry_pulse_ack <= (not p_level_out_d7) and p_level_out_d6;
           

end generate MTBF_L6;

       scndry_out <= scndry_out_int;


end generate GENERATE_LEVEL_ACK_P_S_CDC;


end implementation;

-- XSIP watermark, do not delete 67d7842dbbe25473c3c32b93c0da8047785f30d78e8a024de1b57352245f9689
