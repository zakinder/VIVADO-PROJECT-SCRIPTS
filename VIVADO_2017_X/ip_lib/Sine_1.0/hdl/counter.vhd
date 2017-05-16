library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
entity counter is
    generic(
        cnt_value_g : integer; -- threshold value for counter
        depth_g     : integer  -- the number of samples in one period of the signal
        );
    port(
        clk_in  : in std_logic;                               -- input clock signal
        cnt_en  : in std_logic;                               -- counter enable
        cnt_out : out std_logic_vector (depth_g - 1 downto 0) -- current counter value
        );
end entity;
architecture rtl of counter is
    signal cnt_out_s : std_logic_vector (depth_g - 1 downto 0) := (others => '0'); -- current counter value
begin
-- Defines a sequential process
-- This will be universal (generic) counter
     counter_p: process
     begin
        wait until rising_edge(clk_in);
            if (cnt_en = '1') then
                -- conv_std_logic_vector function converts integer type to std_logic_vector type
                if (cnt_out_s = conv_std_logic_vector (cnt_value_g, depth_g)) then
                    cnt_out_s <= (others => '0'); -- counter reset
                else
                    cnt_out_s <= cnt_out_s + 1;   -- counter
                end if;
            end if;
    end process;
    cnt_out <= cnt_out_s;
end;