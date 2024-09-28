library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity pattern_tb is 
end entity;

architecture testbench of pattern_tb is
component pattern3 is
    port (
        clk   : in std_ulogic;
        rst : in std_ulogic;
        led : out std_ulogic_vector(6 downto 0)
    );
end component;

signal clk_tb: std_ulogic:='0';
signal rst_tb: std_ulogic:='0';
signal led_out: std_ulogic_vector(6 downto 0):="0000000";


begin
    
clk_tb <= not clk_tb after CLK_PERIOD / 2;

dut: pattern3
    port map (
        clk   => clk_tb,
        rst => rst_tb,
        led=>led_out
    );


end architecture;