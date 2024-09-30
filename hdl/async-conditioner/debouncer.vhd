library ieee;
use ieee.std_logic_1164.all;


entity debouncer is
    generic (
        clk_period : time :=20 ns;
        debounce_time: time
    );
port(
    clk: in std_ulogic;
    rst: in std_ulogic;
    input: in std_ulogic;
    debounced: out std_ulogic
);
end entity debouncer;
architecture debouncer_arch of debouncer is

constant wait_clocks: integer:=debounce_time/clk_period;
signal clock_count: integer range 0 to 268435455;
signal enable: boolean;
signal prev_input: std_ulogic;
signal debounce_out: std_ulogic;


begin
process(clk, input, rst)
begin
	if(rising_edge(clk)) then
		if(rst='1')then
			enable<=true;
			clock_count<=0;
			debounced<='0';
		end if;
	end if;
	if (rising_edge(clk))then
		prev_input<= input;
		if enable then
			if(input='1' and prev_input='0')then
				debounced<='1';
				enable<=false;
			elsif(input='0' and prev_input='1') then
				debounced<='0';
				enable<=false;
			end if;
		else 
			if(clock_count = wait_clocks-2) then
				clock_count<=0;
				enable<=true;
			else
				clock_count<=clock_count+1;
				
			end if;
		end if;
	end if;
	-- debounced<=debounce_out;
end process;
end architecture;
    