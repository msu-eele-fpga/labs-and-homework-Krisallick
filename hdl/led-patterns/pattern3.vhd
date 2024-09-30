library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern3 is
    port(
        clk: in std_ulogic;
        rst: in std_ulogic;
        led: out std_ulogic_vector(6 downto 0):="1111111"
    );
end entity;

architecture rtl of pattern3 is
signal count: unsigned(6 downto 0):="1111111";
begin

process(clk, rst)
begin
    if (rst='1') then
        led<="1111111";
    elsif (rising_edge(clk)) then
        if count="0000000" then
            led<="1111111";
            count<="1111111";
        else
            led<=(std_ulogic_vector(count));
            count<=count-1;
        end if;
        
    end if;
end process;
end architecture;