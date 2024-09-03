library IEEE;
use IEEE.std_logic_1164.all;
entity synchronizer is
port (
	clk : in std_ulogic;
	async : in std_ulogic;
	sync : out std_ulogic
);
end entity synchronizer;

architecture synchronizer_arch of synchronizer is
signal D : std_ulogic;
begin


	D1: process(clk)
	begin
		if rising_edge(clk) then
			D <= async;
		end if;
	end process;

	D2: process(clk)
	begin
		if rising_edge(clk) then
			sync<=D;
		end if;
	end process;

end architecture;