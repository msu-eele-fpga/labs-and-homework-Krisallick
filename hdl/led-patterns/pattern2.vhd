library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern2 is
    port(
        clk: in std_ulogic;
        rst: in std_ulogic;
        led: out std_ulogic_vector(6 downto 0):="0000000"
    );
end entity;

architecture rtl of pattern2 is
signal count: unsigned(6 downto 0):="0000000";
begin

process(clk)
begin
    if (rst='1') then
        led<="0000000";
    elsif (rising_edge(clk)) then
        if count="1111111" then
            led<="0000000";
            count<="0000000";
        else
            led<=To_Std_uLogic_Vector(std_logic_vector(count));
            count<=count+1;
        end if;
        
    end if;
end process;
end architecture;