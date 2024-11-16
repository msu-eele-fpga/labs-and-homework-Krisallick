library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_controller is
    port (
        clk :       in std_ulogic;
        rst :       in std_ulogic;
        period:     in unsigned(18 downto 0);--18 total 12 fractional 6 integer bits. register
        redDuty:     in std_ulogic_vector(7 downto 0);--register can be unsigned?
        blueDuty:    in std_ulogic_vector(7 downto 0);--register
        greenDuty:   in std_ulogic_vector(7 downto 0);--register
        redOut:     out std_ulogic:='0'; 
        blueOut:    out std_ulogic:='0';
        greenOut:   out std_ulogic:='0'
    );
end entity;

architecture rtl of rgb_controller is

component pwm_controller is
    generic (
        CLK_PERIOD : time := 20 ns;
        W_PERIOD : Integer:= 18; --width of period 18.12 
        W_DUTY_CYCLE: Integer:= 12 --width of duty cycle 12.11
      );
      port (
        clk : in std_logic;
        rst : in std_logic;
        -- PWM repetition period in milliseconds;
        -- datatype (W.F) is individually assigned
        period : in unsigned(W_PERIOD - 1 downto 0);
        -- PWM duty cycle between [0 1]; out-of-range values are hard-limited
        -- datatype (W.F) is individually assigned
        duty_cycle : in unsigned(W_DUTY_CYCLE - 1 downto 0);
      output : out std_logic
      );
end component;

begin

    Red: entity work.pwm_controller
     generic map(
        CLK_PERIOD => 20 ns,
        W_PERIOD => 18,
        W_DUTY_CYCLE => 12
    )
     port map(
        clk => clk,
        rst => rst,
        period => period,
        duty_cycle => redDuty,
        output => redOut
    );
    
    Green: entity work.pwm_controller
    generic map(
       CLK_PERIOD => 20 ns,
       W_PERIOD => 18,
       W_DUTY_CYCLE => 12
   )
    port map(
       clk => clk,
       rst => rst,
       period => period,
       duty_cycle => greenDuty,
       output => greenOut
   );

   Bloo: entity work.pwm_controller
   generic map(
      CLK_PERIOD => 20 ns,
      W_PERIOD => 18,
      W_DUTY_CYCLE => 12
  )
   port map(
      clk => clk,
      rst => rst,
      period => period,
      duty_cycle => blueDuty,
      output => blueOut
  );

end architecture;
