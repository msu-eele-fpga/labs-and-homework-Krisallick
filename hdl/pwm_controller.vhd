library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pwm_controller is
generic (
CLK_PERIOD : time := 20 ns;
W_PERIOD : UNSIGNED:= 18;
W_DUTY_CYCLE: UNSIGNED:= 12,
);
port (
clk : in std_logic;
rst : in std_logic;
-- PWM repetition period in milliseconds;
-- datatype (W.F) is individually assigned
period : in unsigned(W_PERIOD - 1 downto 0);
-- PWM duty cycle between [0 1]; out-of-range values are hard-limited
-- datatype (W.F) is individually assigned
duty_cycle : in std_logic_vector(W_DUTY_CYCLE - 1 downto 0);
output : out std_logic
);
end entity pwm_controller;

architecture rtl of pwm_controller is
-- convert period from ms to clock cycles
--
-- 


begin



    

end architecture;

