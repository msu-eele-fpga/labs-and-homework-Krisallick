library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern4 is
    port(
        clk: in std_ulogic;
        rst: in std_ulogic;
        led: out std_ulogic_vector(6 downto 0):="0001000"
    );
end entity;

architecture rtl of pattern4 is
signal count: natural range 0 to 3:=0;
begin

process(clk)
begin
    if (rst='1') then
        led<="0001000";
    elsif (rising_edge(clk)) then
        if(count = 3) then
            count<=0;
    else 
        count<=count+1;
    end if;
        case count is
            when 0 => led<="0001000";
            when 1 => led<="0010100";
            when 2 => led<="0100010";
            when 3 => led<="1000001";
        end case;
    end if;
end process;
end architecture;