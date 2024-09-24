library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity led_patterns_tb is
end entity;



architecture testbench of led_patterns_tb is

    component led_patterns is
        generic (
            system_clock_period : time := 20 ns
        );
        port (
            clk   : in std_ulogic;
            rst : in std_ulogic;
            push_button : in std_ulogic;
            switches : in std_ulogic_vector(3 downto 0);
            hps_led_control : in boolean;
            base_period : in unsigned(7 downto 0); --4 int bits 4 frac bits
            led_reg : in std_ulogic_vector(7 downto 0);
            led : out std_ulogic_vector(7 downto 0)
        );
    end component;



    signal clk_tb: std_logic:='0';
    signal rst_tb: std_logic:='0';
    signal push_button_tb: std_ulogic:='0';
    signal switches_tb: std_ulogic_vector(3 downto 0):="0000";
    signal hps_led_control_tb: boolean:=false;
    signal base_period_tb: unsigned(7 downto 0):="00010000";--remember 4ints 4 fracs
    signal led_reg_tb: std_ulogic_vector(7 downto 0):="00000000";
    signal led_tb: std_ulogic_vector(7 downto 0);

begin
    dut:led_patterns
        -- generic map(
        --     system_clock_period : time := 20 ns
        -- );
        port map (
            clk   => clk_tb,
            rst => rst_tb,
            push_button=>push_button_tb,
            switches=>switches_tb,
            hps_led_control=>hps_led_control_tb,
            base_period=> base_period_tb,
            led_reg=>led_reg_tb,
            led=>led_tb
        );

 clk_tb <= not clk_tb after CLK_PERIOD / 2;

end architecture;