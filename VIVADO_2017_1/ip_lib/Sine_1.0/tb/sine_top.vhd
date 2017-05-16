library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.modulator_pkg.all;
entity sine_top is
generic (
    cntampl_value_g : integer := 255;
    depth_g : integer range 1 to 99 := 8;
    width_g : integer range 1 to 99 := 12);
port (
    clk_in : in std_logic;
    sw0 : in std_logic;
    div_factor_freqhigh : in std_logic_vector(31 downto 0);
    div_factor_freqlow : in std_logic_vector(31 downto 0);
    sine_out : out std_logic_vector(width_g - 1 downto 0));
end entity;
architecture rtl of sine_top is

	component frequency_trigger is
    port (
        clk_in : in std_logic;
        sw0 : in std_logic;
        div_factor_freqhigh : in std_logic_vector(31 downto 0);
        div_factor_freqlow : in std_logic_vector(31 downto 0);
        freq_trig : out std_logic);
	end component frequency_trigger;
	
	component sine is
    generic (
        depth_g : integer range 1 to 99 := 8;
        width_g : integer range 1 to 99 := 12);
    port (
        clk_in : in std_logic;
        ampl_cnt : in std_logic_vector(depth_g - 1 downto 0);
        sine_outo : out std_logic_vector(width_g - 1 downto 0);
        sine_out : out std_logic_vector(width_g - 1 downto 0));
	end component sine;
	
	component counter is
    generic (
        cnt_value_g : integer;
        depth_g : integer);
    port (
        clk_in  : in std_logic;
        cnt_en  : in std_logic;
        cnt_out : out std_logic_vector (depth_g - 1 downto 0));
	end component counter;
	
	signal ampl_cnt_s  : std_logic_vector(depth_g - 1 downto 0) := (others => '0'); 
	signal freq_trig_s : std_logic := '0';
	
begin

	freq_ceu: frequency_trigger
	port map(
        clk_in              => clk_in,
        sw0                 => sw0,
        div_factor_freqhigh => div_factor_freqhigh,
        div_factor_freqlow  => div_factor_freqlow,
        freq_trig           => freq_trig_s);
	
	counteramplu: counter
	generic map(
        cnt_value_g => cntampl_value_g,
        depth_g     => depth_g)
	port map(
        clk_in  => clk_in,
        cnt_en  => freq_trig_s,
        cnt_out => ampl_cnt_s);
	
	sineu: sine
	generic map(
        depth_g  => depth_g,
        width_g  => width_g)
	port map(
        clk_in   => clk_in,
        ampl_cnt => ampl_cnt_s,
        sine_out => sine_out);

	end;