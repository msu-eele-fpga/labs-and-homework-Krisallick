library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity pwm_controller_tb is
end entity;

architecture tb of pwm_controller_tb is
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

signal clk_tb: std_logic:='0';
signal rst_tb: std_logic:='0';
signal period_tb: unsigned(18-1 downto 0):="000001000000000000"; --1ms
signal duty_cycle_tb: unsigned(12-1 downto 0):="000100000000"; --0.125
signal output_tb: std_logic:='0';



begin
dut: entity work.pwm_controller
 generic map(
    CLK_PERIOD => 20 ns,
    W_PERIOD => 18,
    W_DUTY_CYCLE => 12
)
 port map(
    clk => clk_tb,
    rst => rst_tb,
    period => period_tb,
    duty_cycle => duty_cycle_tb,
    output => output_tb
);

    clk_tb <= not clk_tb after CLK_PERIOD / 2;

end architecture;