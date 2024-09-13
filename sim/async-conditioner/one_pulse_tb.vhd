library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity one_pulse_tb is
end entity;

architecture testbench of one_pulse_tb is
signal clk_tb: std_ulogic:='0';
signal rst_tb: std_ulogic:='0';
signal input_tb: std_ulogic:='0';
signal pulse_tb: std_ulogic;
signal pulse_expected: std_ulogic;


component one_pulse is
	port(   clk: in std_ulogic;
		rst: in std_ulogic;
		input: in std_ulogic;
		pulse: out std_ulogic
	);
end component;

begin
dut : component one_pulse
	port map(
		  clk=>clk_tb,
		  rst=>rst_tb,
		  input=>input_tb,
		  pulse=>pulse_tb
	);

clk_gen:process is
begin
clk_tb<=not clk_tb;
wait for CLK_PERIOD/2;
end process clk_gen;

input_gen: process is
begin
	wait for CLK_PERIOD*3;
	input_tb<='1';
	
	wait for CLK_PERIOD*3;
	input_tb<='0';

	wait for CLK_PERIOD*2;
	input_tb<='1';
	
	wait for CLK_PERIOD*2;
	input_tb<='0';

	wait for CLK_PERIOD*5;
	input_tb<='1';
	
	wait for CLK_PERIOD*5;
	input_tb<='0';

end process;

expected_pulse: process is
begin

	wait for CLK_PERIOD*3;
	pulse_expected<='1';
	wait for CLK_PERIOD/2;
	pulse_expected<='0';
	wait for CLK_PERIOD*2.5;

	wait for CLK_PERIOD*2;
	pulse_expected<='1';
	wait for CLK_PERIOD/2;
	pulse_expected<='0';
	wait for CLK_PERIOD*1.5;

	wait for CLK_PERIOD*5;
	pulse_expected<='1';
	wait for CLK_PERIOD/2;
	pulse_expected<='0';
`	wait for CLK_PERIOD*5.5;
end process;
end architecture;