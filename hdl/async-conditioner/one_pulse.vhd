library ieee;
use ieee.std_logic_1164.all;

entity one_pulse is
	port(   clk: in std_ulogic;
		rst: in std_ulogic;
		input: in std_ulogic;
		pulse: out std_ulogic
	);
end entity one_pulse;

architecture one_pulse_arch of one_pulse is
signal flag: boolean:=false;
begin
process(clk)
begin 
	if(rising_edge(clk))then
		if(rst='1') then
			pulse<='0';
		end if;
		if(flag = false)then
			if (input='1') then
				pulse<='1';
				flag<=true;
			end if;
		else
			if(input='0')then
				flag<=false;
				pulse<='0';
			end if;
			pulse<='0';
		end if;
	end if;
end process;
end architecture;