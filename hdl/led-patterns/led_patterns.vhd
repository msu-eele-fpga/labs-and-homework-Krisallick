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

    component clk_generator is
        port (
            clk   : in std_ulogic;
            rst : in std_ulogic;
            cnt: in unsigned(29 downto 0);
            eighth_base_rate:out std_ulogic;
            quarter_base_rate: out std_ulogic;
            half_base_rate: out std_ulogic;
            twice_base_rate: out std_ulogic;
            four_base_rate: out std_ulogic
        );
    end component;

    component pattern0 is
        port (
            clk: in std_ulogic;
            rst: in std_ulogic;
            led: out std_ulogic_vector(6 downto 0):="1000000"
        );
    end component;
        
    component pattern1 is
        port (
            clk: in std_ulogic;
            rst: in std_ulogic;
            led: out std_ulogic_vector(6 downto 0):="0000011"
        );
    end component;
        
    component pattern2 is
        port (
            clk: in std_ulogic;
            rst: in std_ulogic;
            led: out std_ulogic_vector(6 downto 0):="0000000"
        );
    end component;
        
    component pattern3 is
        port (
            clk: in std_ulogic;
            rst: in std_ulogic;
            led: out std_ulogic_vector(6 downto 0):="1111111"
        );
    end component;
        
    component pattern4 is
        port (
            clk: in std_ulogic;
            rst: in std_ulogic;
            led: out std_ulogic_vector(6 downto 0):="0001000"
        );
    end component;

type State_Type is (display, patternS0, patternS1, patternS2, patternS3, patternS4);
signal current_state: State_type:=display;
signal next_state, prev_state : State_Type;
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

signal timer_en: boolean;
signal timer_done: boolean;

signal clockCounter: integer range 0 to 268435455;--ranging for using 28 bits and keep it positive

signal eighth_clock: std_ulogic;
signal quarter_clock: std_ulogic; 
signal half_clock: std_ulogic; 
signal twice_clock: std_ulogic; 
signal four_clock: std_ulogic; 

signal pattern0_out: std_ulogic_vector(6 downto 0);
signal pattern1_out: std_ulogic_vector(6 downto 0);
signal pattern2_out: std_ulogic_vector(6 downto 0);
signal pattern3_out: std_ulogic_vector(6 downto 0);
signal pattern4_out: std_ulogic_vector(6 downto 0);

signal led7_mid:std_ulogic:='0';

begin

period_base_clk_full_prec<= SYS_CLK_FREQ*base_period;

--get rid of the fractional bits of SYS_CLK_FREQ * base_period so we have an int nmber of clock cycles for one second
period_base_clk<= period_base_clk_full_prec(N_BITS_CLK_CYCLES_FULL-1 downto 4);--use for counters
-- period_base_clk<=to_unsigned(4, 30); --FOR TESTING!!!

clk_gen: clk_generator
    port map (
        clk   => clk,
        rst => rst,
        cnt=>period_base_clk,
        eighth_base_rate => eighth_clock,
        quarter_base_rate => quarter_clock,
        half_base_rate => half_clock,
        twice_base_rate => twice_clock,
        four_base_rate => four_clock
    );

pattern0_inst: entity work.pattern0
 port map(
    clk => half_clock,
    rst => rst,
    led => pattern0_out
);
pattern1_inst: entity work.pattern1
 port map(
    clk => quarter_clock,
    rst => rst,
    led => pattern1_out
);

pattern2_inst: entity work.pattern2
 port map(
    clk => twice_clock,
    rst => rst,
    led => pattern2_out
);
pattern3_inst: entity work.pattern3
 port map(
    clk => eighth_clock,
    rst => rst,
    led => pattern3_out
);
pattern4_inst: entity work.pattern4
 port map(
    clk => four_clock,
    rst => rst,
    led => pattern4_out
);

timed_counter_inst: timed_counter
    generic map (
        clk_period=>20 ns,
        count_time=>1 sec
    )
    port map (
        clk   => clk,
        enable=>timer_en,
        done=>timer_done
    );
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
Next_State_Logic:process (current_state, prev_state, push_button, switches)
begin
    if(push_button='1') then
        next_state<=display;
    
    --     next_state<=current_state;
    
    -- if current_state=display then
    else
        if timer_done then
            case switches is
                when "0000" => next_state<= patternS0;
                when "0001" => next_state<= patternS1;
                when "0010" => next_state<= patternS2;
                when "0011" => next_state<= patternS3;
                when "0100" => next_state<= patternS4;
                when others => next_state<= prev_state;
            end case;
        -- else
        --     next_state<=current_state;
        end if;
    end if;
end process;
--------------------------------------------------------------------------------
OUTPUT_LOGIC: process(current_state, switches)
begin

    case current_state is
        when display => led(3 downto 0)<=switches;
                        led(6 downto 4)<="000";
                        timer_en<=true;
        when patternS0 =>   led(6 downto 0)<=pattern0_out;
                            timer_en<=false;
                            prev_state<=current_state;
        when patternS1 =>   led(6 downto 0)<=pattern1_out;
                            timer_en<=false;
                            prev_state<=current_state;
        when patternS2 =>   led(6 downto 0)<=pattern2_out;
                            timer_en<=false;
                            prev_state<=current_state;
        when patternS3 =>   led(6 downto 0)<=pattern3_out;
                            timer_en<=false;
                            prev_state<=current_state;
        when patternS4 =>   led(6 downto 0)<=pattern4_out;
                            timer_en<=false;
                            prev_state<=current_state;
        when others=>null;
    end case;
end process;

LED7:process(clk, period_base_clk)
begin
    if(rising_edge(clk)) then
        if (clockCounter = period_base_clk)then
            clockCounter<=0;
            led7_mid <= not led7_mid;
        else
            clockCounter<=clockCounter+1;
        end if;
    end if;
    led(7)<=led7_mid;
end process;

end architecture;