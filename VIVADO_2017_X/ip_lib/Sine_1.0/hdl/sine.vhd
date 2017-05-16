library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
  
    use work.modulator_pkg.all;
entity sine is
    generic(
        depth_g : integer range 1 to 99 := 8; -- the number of samples in one period of the signal
        width_g : integer range 1 to 99 := 12 -- the number of bits used to represent amplitude value
        );
    port(
        clk_in   : in std_logic;                            -- input clock signal
        ampl_cnt : in std_logic_vector(depth_g-1 downto 0); -- address value for the sine waveform ROM
        sine_outo : out std_logic_vector(width_g-1 downto 0); -- current amplitude value of the sine signal
        sine_out : out std_logic_vector(width_g-1 downto 0) -- current amplitude value of the sine signal
    );
end entity;
architecture rtl of sine is
    constant sin_ampl_c : vector_t_arr := init_sin_f(depth_g, width_g);    -- returns sine amplitude value
    signal ampl_cnt_s : integer range 0 to 255 := 0;                       -- amplitude counter
    signal sine_s : std_logic_vector(width_g-1 downto 0) := (others=>'0'); -- sine signal
begin
-- Defines a sequential process
-- Fetches amplitude values and frequency -> generates sine
    sine_p : process
    begin
        wait until rising_edge(clk_in);
        -- converts ampl_cnt from std_logic_vector type to integer type
        ampl_cnt_s <= conv_integer(ampl_cnt);
        -- converts sin_ampl_c from integer type to std_logic_vector type
        sine_s <= conv_std_logic_vector(sin_ampl_c(ampl_cnt_s), width_g); -- fetch amplitude
    end process;
    sine_out <= sine_s;
    sine_outo <=sine_s;
end;