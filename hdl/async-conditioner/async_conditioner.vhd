library ieee;
use ieee.std_logic_1164.all;

entity async_conditioner is
    port (
        clk   : in std_ulogic;
        rst : in std_ulogic;
        async : in std_ulogic;
        sync : out std_ulogic
    );
end entity;

architecture async_conditioner_arch of async_conditioner is
    component Synchronizer is
        port (
            clk : in std_ulogic;
            async : in std_ulogic;
            sync : out std_ulogic
        );
        end component Synchronizer;

    component debouncer is
        generic (
            debounce_time: time
        );
        port (
            clk: in std_ulogic;
            rst: in std_ulogic;
            input: in std_ulogic;
            debounced: out std_ulogic
        );
    end component;
    
    component one_pulse is
        port(   
            clk: in std_ulogic;
            rst: in std_ulogic;
            input: in std_ulogic;
            pulse: out std_ulogic
        );
    end component;
signal sync_to_debounce: std_ulogic;
signal debounce_to_pulse: std_ulogic;
begin

    S1: Synchronizer
        port map (
            clk   => clk,
            async => async,
            sync  => sync_to_debounce
        );

    DB1: debouncer
	generic map(
	    debounce_time=>20ns
	)
        port map (
            clk   => clk,
            rst => rst,
            input => sync_to_debounce,
            debounced => debounce_to_pulse
        );
    P1: one_pulse
        port map (
            clk   => clk,
            rst => rst,
            input=>debounce_to_pulse,
            pulse=>sync
        );

end architecture;