library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern0 is
    port(
        clk: in std_ulogic;
        rst: in std_ulogic;
        led: out std_ulogic_vector(6 downto 0):="1000000"
    );
end entity;

architecture rtl of pattern0 is
signal count: natural range 0 to 10:=0;
begin

process(clk)
begin
    if (rst='1') then
        led<="1000000";
    elsif (rising_edge(clk)) then
        if count=6 then
            led<="1000000";
            count<=0;
        else
            led<=(led srl 1);
            count<=count+1;
        end if;
        
    end if;
end process;
end architecture;
