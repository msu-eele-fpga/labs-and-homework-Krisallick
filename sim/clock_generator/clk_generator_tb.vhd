library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity clk_generator_tb is
end entity;

architecture tb of clk_generator_tb is
component clk_generator is
    port (
        clk   : in std_ulogic;
        rst : in std_ulogic;
        cnt: in unsigned(29 downto 0);
        eighth_base_rate:out std_ulogic;
        quarter_base_rate: out std_ulogic;
        half_base_rate: out std_ulogic;
        twice_base_rate: out std_ulogic;
        four_base_rate: out std_ulogic
    );
end component;


    signal clk_tb: std_ulogic:='0';
    signal rst_tb: std_ulogic:='0';
    signal cnt_tb: unsigned(29 downto 0):=to_unsigned(16, 30);
    signal eighth_tb: std_ulogic;
    signal quarter_tb: std_ulogic;
    signal half_tb: std_ulogic;
    signal twice_tb: std_ulogic;
    signal four_tb: std_ulogic;

begin
    dut: clk_generator
        -- generic map (
        --     cnt=>cnt_tb
        -- )
        port map (
            clk   => clk_tb,
            rst => rst_tb,
            cnt=>cnt_tb,
            eighth_base_rate=>eighth_tb,
            quarter_base_rate=>quarter_tb,
            half_base_rate=>half_tb,
            twice_base_rate=>twice_tb,
            four_base_rate=>four_tb
        );


    clk_tb <= not clk_tb after CLK_PERIOD / 2;
    

end architecture;
