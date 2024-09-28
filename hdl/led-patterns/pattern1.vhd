library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern1 is
    port(
        clk: in std_ulogic;
        rst: in std_ulogic;
        led: out std_ulogic_vector(6 downto 0):="0000011"
    );
end entity;

architecture rtl of pattern1 is
signal count: natural range 0 to 10:=0;
begin

process(clk)
begin
    if (rst='1') then
        led<="0000011";
    elsif (rising_edge(clk)) then
        if count=6 then
            led<="0000011";
            count<=0;
        else
            led<=(led sll 1);
            count<=count+1;
        end if;
        
    end if;
end process;
end architecture;