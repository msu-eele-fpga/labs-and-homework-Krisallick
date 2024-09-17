library ieee;
use ieee.std_logic_1164.all;


entity led_patterns is
    generic (
        system_clock_period : time := 20 ns
    );
    port (
        clk : in std_ulogic;
        rst : in std_ulogic;
        push_button : in std_ulogic;
        switches : in std_ulogic_vector(3 downto 0);
        hps_led_control : in boolean;
        base_period : in unsigned(7 downto 0);
        led_reg : in std_ulogic_vector(7 downto 0);
        led : out std_ulogic_vector(7 downto 0)
    );
    end entity led_patterns;
architecture led_patterns_arch of led_patterns is

type State_Type is (pattern0, pattern1, pattern2, pattern3, pattern4);
signal current_state, next_state : State_Type;

begin
    State_mem:process (clk)
    begin
        if rising_edge(clk) then
            if(rst='1')then
                --reset conditions
            elsif hps_led_control then
                --code to let the lEDs be controlled by software
            elsif(hps_led_control=false)
                --code to let the LEDs be controlled by state machines
                current_state<=next_state;
            end if;
        end if;
    end process;
------------------------------------------------------------------------------
Next_State_Logic:process (current_state, push_button, switches)
begin
    case (current_state) is 
        
    end case;
end process;
--------------------------------------------------------------------------------
Output_Logic:process (current_state, push_button, switches)
begin
    
end process;
    
end architecture;