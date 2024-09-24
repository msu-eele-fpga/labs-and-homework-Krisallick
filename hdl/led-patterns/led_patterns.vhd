library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


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
        base_period : in unsigned(7 downto 0); --4 int bits 4 frac bits
        led_reg : in std_ulogic_vector(7 downto 0);
        led : out std_ulogic_vector(7 downto 0):="00000000"
    );
    end entity led_patterns;
architecture led_patterns_arch of led_patterns is
    component timed_counter is
            generic (
                clk_period : time;	--20ns
                count_time : time
            );
            port (
                clk : in std_ulogic;
                enable : in boolean;
                done : out boolean
            );
    end component;

type State_Type is (pattern0, pattern1, pattern2, pattern3, pattern4);
signal current_state, next_state : State_Type;
signal P0_init: std_ulogic:='0'; --if high, we have completed our initial set up for Pattern0

--consat celi(log2(1sec/systemclock))
--cycles/sec  * base period = number of clocks


-- number of bits required to represent the system clock freq using unsigned ints
-- constant N_BITS_SYS_CLK_FREQ: natural:=ceil(log2(1 sec/ SYSTEM_CLK_PERIOD)); only use this if you have the math library otherwise 
-- hard code to 26 bits because our clock never changes
constant SYS_CLK_FREQ: unsigned(25 downto 0):= (to_unsigned((1 sec / system_clock_period), 26)); 

--number of bits required to represent the multiplication of SYS_CLK_FREQ*base_period, including fractional bits of base period
constant N_BITS_CLK_CYCLES_FULL: natural :=34; --26+8 or N_BITS_SYS_CLK_FREQ +8

--number of bits required to represent the integer part of SYS_CLK_FREQ*base_period
constant N_BITS_CLK_CYCLES: natural :=30; --26+4 or N_BITS_SYS_CLK_FREQ +4

-- number of clock cycles in one base period. this signal has the same number of fractional bits as
-- base_period, thus it can represent a fractional number of clock cycles (which isn't feasible to implement)
signal period_base_clk_full_prec:  unsigned(N_BITS_CLK_CYCLES_FULL-1 downto 0);
-- number of clock cycles in one base_period. this signal will only represent an *integer* number of clock cycles
signal period_base_clk: unsigned(N_BITS_CLK_CYCLES-1 downto 0);

-- signal timer_en: boolean;
signal timer_done: boolean;

signal clockCounter: integer range 0 to 268435455;--ranging for using 28 bits and keep it positive


begin

period_base_clk_full_prec<= SYS_CLK_FREQ*base_period;

--get rid of the fractional bits of SYS_CLK_FREQ * base_period so we have an int nmber of clock cycles for one second
-- period_base_clk<= period_base_clk_full_prec(N_BITS_CLK_CYCLES_FULL-1 downto 4);--use for counters
period_base_clk<=to_unsigned(4, 30); --FOR TESTING!!!
-- timer: timed_counter
-- generic map (
--     clk_period => 20 ns,	--20ns
--     count_time => 
-- )
-- port map (
--     clk   => clk,
--     enable=> timer_en,
--     done=> timer_done
-- );
-----------------------------------------------------------------------
    State_mem:process (clk)
    begin
        if rising_edge(clk) then
            if(rst='1')then
                --reset conditions
            elsif hps_led_control then
                --code to let the lEDs be controlled by software
            elsif(hps_led_control=false) then
                --code to let the LEDs be controlled by state machines
                current_state<=next_state;
            end if;
        end if;
    end process;
------------------------------------------------------------------------------
Next_State_Logic:process (clk, current_state, push_button, switches)
begin
    if rising_edge(clk) then
        if(push_button='1') then
    --         case (switches) is 
                            
    -- end case;
        end if;
    end if;

end process;
--------------------------------------------------------------------------------
-- P0:process (clk, current_state)
-- begin
--     if(rising_edge(clk))then --clock will be at 1/2base_rate seconds
--         if(P0_init='0') then --set up the LEDs to an starting state
--             led<="1000000";
--             P0_init<='1';
--         end if;
--         -- shift_right(led, 1); -- every clock (1/2 base_rate) shift LED right 
--     end if;
-- end process;

LED7:process(clk, period_base_clk)
begin
    if(rising_edge(clk)) then
        if (clockCounter = period_base_clk)then
            timer_done <= true;
            clockCounter<=0;
            led(7) <= not led(7);
        else
            clockCounter<=clockCounter+1;
            timer_done<=false;
        end if;
    end if;
end process;
end architecture;