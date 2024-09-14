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

begin


end architecture;