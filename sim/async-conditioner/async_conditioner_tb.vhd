library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity async_conditioner_tb is
end entity;


architecture testbench of async_conditioner_tb is

component async_conditioner is
    port (
        clk   : in std_logic;
        rst : in std_logic;
        async : in std_ulogic;
        sync : out std_ulogic
    );
end component;

constant BOUNCE_PERIOD : time := 100 ns;

    signal clk_tb     : std_ulogic := '0';
    signal rst_tb     : std_ulogic := '0';
    signal async_tb : std_ulogic:= '0';
    signal sync_tb: std_ulogic;

    procedure bounce_signal (
    signal bounce          : out std_ulogic;
    constant BOUNCE_PERIOD : time;
    constant BOUNCE_CYCLES : natural;
    constant FINAL_VALUE   : std_ulogic
  ) is

    -- If BOUNCE_CYCLES is not an integer multiple of 4, the division
    -- operation will only return the integer part (i.e., perform a floor
    -- operation). Thus, we need to calculate how many cycles are remaining
    -- after waiting for 3 * BOUNCE_CYCLES_BY_4 BOUNCE_PERIODs. If BOUNCE_CYCLES
    -- is an integer multiple of 4, then REMAINING_CYCLES will be equal to
    -- BOUNCE_CYCLES_BY_4.
    constant BOUNCE_CYCLES_BY_4 : natural := BOUNCE_CYCLES / 4;
    constant REMAINING_CYCLES   : natural := BOUNCE_CYCLES - (3 * BOUNCE_CYCLES_BY_4);

  begin

    -- Toggle the bouncing input quickly for ~1/4 of the debounce time
    for i in 1 to BOUNCE_CYCLES_BY_4 loop
      bounce <= not bounce;
      wait for BOUNCE_PERIOD;
    end loop;

    -- Toggle the bouncing input slowly for ~1/2 of the debounce time
    for i in 1 to BOUNCE_CYCLES_BY_4 loop
      bounce <= not bounce;
      wait for 2 * BOUNCE_PERIOD;
    end loop;

    -- Settle at the final value for the rest of the debounce time
    bounce <= FINAL_VALUE;
    wait for REMAINING_CYCLES * BOUNCE_PERIOD;

  end procedure bounce_signal;

begin
dut: async_conditioner
    port map (
        clk   => clk_tb,
        rst => rst_tb,
        async=>async_tb,
        sync=>sync_tb
    );

    clk_tb <= not clk_tb after CLK_PERIOD / 2;

    stimuli_generator : process is
    begin
        -- for i in 0 to 10 loop
    -- Reset at the beginning of the tests to make sure the debouncers
      -- are in their reset/idle state.
      rst_tb <= '1', '0' after 50 ns;

      -- Let the input sit low for a while
      wait_for_clock_edges(clk_tb, 20);

      -- Transition the bouncing signal on the falling edges of the clock
      wait for CLK_PERIOD / 2;

      -- Press the button
      bounce_signal(async_tb, BOUNCE_PERIOD, 1000 ns/BOUNCE_PERIOD, '1');

      -- Hold the button for an extra debounce time
    --   wait_for_clock_edges(clk_tb, '0');

      -- Transition the bouncing signal on the falling edges of the clock
      wait for CLK_PERIOD / 2;

      -- Release the button
      bounce_signal(async_tb, BOUNCE_PERIOD, 1000 ns/BOUNCE_PERIOD, '0');
      -- Keep the button unpressed for an extra debounce time
    --   wait_for_clock_edges(clk_tb, '0');

      -- Transition the bouncing signal on the falling edges of the clock
      wait for CLK_PERIOD / 2;

      -- Press the button again, but release it right after the deboucne time
      -- is up; this makes sure the debouncer is not debouncing for longer than
      -- it is supposed to.
      bounce_signal(async_tb, BOUNCE_PERIOD, 1000 ns/BOUNCE_PERIOD, '1');
      bounce_signal(async_tb, BOUNCE_PERIOD, 1000 ns/BOUNCE_PERIOD, '0');

      -- Wait a few clock cycles to allow for the release debounce time to be done
      wait_for_clock_edges(clk_tb, 10);

      -- Make sure the debouncer works even if the final value during the
      -- initial-press debounce time is 0 (e.g., the button was pressed
      -- and released before the debounce time was up, or somehow settled
      -- in an unpressed state). In other words, make sure the debouncer
      -- output stays high for the whole debounce time, .
      -- NOTE: this test relies on the fact that async_tb = '0' right before
      -- running this procedure, that way the first toggle sets async_tb = '1'.
      bounce_signal(async_tb, BOUNCE_PERIOD, 1000 ns/BOUNCE_PERIOD, '0');
        -- end loop;
    end process;
    std.env.finish;
end architecture;

    
    
