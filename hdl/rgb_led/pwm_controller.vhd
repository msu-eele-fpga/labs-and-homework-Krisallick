library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity pwm_controller is
generic (
    CLK_PERIOD : time := 20 ns;
    W_PERIOD : Integer:= 18; --width of period 18.12 
    W_DUTY_CYCLE: Integer:= 12 --width of duty cycle 12.11
);
port (
    clk : in std_logic;
    rst : in std_logic;
    -- PWM repetition period in milliseconds;
    -- datatype (W.F) is individually assigned
    period : in unsigned(W_PERIOD - 1 downto 0);
    -- PWM duty cycle between [0 1]; out-of-range values are hard-limited
    -- datatype (W.F) is individually assigned
    duty_cycle : in unsigned(W_DUTY_CYCLE - 1 downto 0);
    output : out std_logic
);
end entity pwm_controller;

architecture rtl of pwm_controller is
    -- --number of bits required for maths-----
    -- convert period from ms to clock cycles
    constant clocksPerMs : unsigned(25 downto 0) := TO_UNSIGNED(1 ms/CLK_PERIOD, 26);
    -- number of bits for clocksPerMs*periodInt
    constant periodClocksBitsFull: natural:= 26+W_PERIOD;
    -- number of bits for the integer portion of periodClocks, 18-12=6
    constant periodClocksBits: natural:=26+6; 
    -- periodClocks full precision
    signal periodClocksFull : unsigned(periodClocksBitsFull-1 downto 0);
    -- periodClocks integer precision
    signal periodClocks : unsigned(periodClocksBits-1 downto 0);
    

    signal PWMClock_full:unsigned((periodClocksBitsFull+W_DUTY_CYCLE)-1 downto 0);--56 bits total because 26+18+12

    signal PWMCLocks:unsigned((periodClocksBits+1)-1 downto 0); --26+6+1 integer bits


    signal PWM: std_logic:='0';
    signal counter: unsigned(34 downto 0):=(others => '0') ; --counter
    signal counter2: unsigned(34 downto 0):= (others => '0') ;
begin
periodClocksFull<=clocksPerMs*period;

periodClocks<=periodClocksFull(periodClocksBitsFull-1 downto 12);--counterlimit for the whole period


PWMClock_full<=periodClocksFull*duty_cycle;--counter for how long to stay high
PWMClocks<=PWMClock_full((periodClocksBitsFull+W_DUTY_CYCLE)-1 downto 23);


outGen: process (clk)
begin
    if rst='1' then
        counter<=(others => '0');
        output<='0';
    elsif rising_edge(clk) then             --first counter, keep on clocking the period
        if counter < periodClocks then
            counter <= counter + 1;
        elsif counter >= periodClocks then
            counter <= (others => '0');
        else 
            counter <= (others => '0');
            
        end if;
        
        if counter < PWMClocks then  --"second counter" only sets output as long as PWMClock counts, because that is as many clocks as it needs to be high
            output <= '1';
        else
            output <= '0';
        end if;
    end if;
end process;
end architecture;

