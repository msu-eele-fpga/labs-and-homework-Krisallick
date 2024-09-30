library ieee;
use ieee.std_logic_1164.all;

entity timed_counter is

generic (
    clk_period : time;	--20ns
    count_time : time
);
port (
    clk : in std_ulogic;
    enable : in boolean;
    done : out boolean
);
end entity timed_counter;

architecture timed_counter_arch of timed_counter is

constant COUNTER_LIMIT : integer:= count_time/clk_period; --ex 40ns/20ns = 2
signal clock_count: integer range 0 to 268435455; --uses 28 bits instead of 32

begin

	counter: process(clk)
	begin
		if (rising_edge(clk)) then
			if enable then
				if (clock_count = COUNTER_LIMIT )then
					done <= true;
					clock_count<=0;
				else
					clock_count<=clock_count+1;
					done<=false;
				end if;
			else
				done<=false;
			end if;
		end if;
	end process;

end architecture;