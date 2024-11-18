library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgb_controller is
    port (
        clk :       in std_ulogic;
        rst :       in std_ulogic;
        -- avalon memory-mapped slave interface
        avs_read : in std_logic;
        avs_write : in std_logic;
        avs_address : in std_logic_vector(1 downto 0);
        avs_readdata : out std_logic_vector(31 downto 0);
        avs_writedata : in std_logic_vector(31 downto 0);
        --other ports
        -- period:     in unsigned(18 downto 0);--18 total 12 fractional 6 integer bits. register
        -- redDuty:     in std_ulogic_vector(7 downto 0);--register can be unsigned?
        -- blueDuty:    in std_ulogic_vector(7 downto 0);--register
        -- greenDuty:   in std_ulogic_vector(7 downto 0);--register
        redOut:     out std_ulogic:='0'; 
        blueOut:    out std_ulogic:='0';
        greenOut:   out std_ulogic:='0'
    );
end entity;

architecture rtl of rgb_controller is

component pwm_controller is
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
end component;

    -- Registers
    signal period: unsigned(31 downto 0):="00000000000000000001000000000000";--18 total 12 fractional 6 integer bits.
    signal redDuty: std_ulogic_vector(31 downto 0):=(others => '0');--register
    signal greenDuty: std_ulogic_vector(31 downto 0):=(others => '0');--register
    signal blueDuty:std_ulogic_vector(31 downto 0):=(others => '0');--register
    --End Registers

begin

    Red: entity work.pwm_controller
     generic map(
        CLK_PERIOD => 20 ns,
        W_PERIOD => 18,
        W_DUTY_CYCLE => 12
    )
     port map(
        clk => clk,
        rst => rst,
        period => period(17 downto 0),
        duty_cycle => unsigned(redDuty(11 downto 0)),
        output => redOut
    );
    
    Green: entity work.pwm_controller
    generic map(
       CLK_PERIOD => 20 ns,
       W_PERIOD => 18,
       W_DUTY_CYCLE => 12
   )
    port map(
       clk => clk,
       rst => rst,
       period => period(17 downto 0),
       duty_cycle => unsigned(greenDuty(11 downto 0)),
       output => greenOut
   );

   Bloo: entity work.pwm_controller
   generic map(
      CLK_PERIOD => 20 ns,
      W_PERIOD => 18,
      W_DUTY_CYCLE => 12
  )
   port map(
      clk => clk,
      rst => rst,
      period => period(17 downto 0),
      duty_cycle => unsigned(blueDuty(11 downto 0)),
      output => blueOut
  );

  avalon_register_read: process(clk)
  begin
      if rising_edge(clk) and avs_read= '1' then
          case avs_address is
              when "00" => avs_readdata <= Std_Logic_Vector(period);
              when "01" => avs_readdata <= Std_Logic_Vector(redDuty);
              when "10" => avs_readdata <= Std_Logic_Vector(greenDuty);
              when "11" => avs_readdata <= Std_Logic_Vector(blueDuty);
              when others => avs_readdata <= (others => '0');
          end case;
      end if;
  end process;

avalon_register_write: process(clk, rst)
begin
  if (rst='1') then
    period <= "00000000000000000001000000000000";
    redDuty <= (others => '0');
    greenDuty <= (others => '0');
    blueDuty <= (others => '0');
  elsif rising_edge(clk) and avs_write='1' then
      case avs_address is
          when "00" => period <= unsigned(avs_writedata(31 downto 0));
          when "01" => redDuty <= Std_ULogic_Vector(avs_writedata(31 downto 0));
          when "10" => greenDuty <= Std_ULogic_Vector(avs_writedata(31 downto 0));
          when "11" => blueDuty <= Std_ULogic_Vector(avs_writedata(31 downto 0));
          when others =>
              null;
      end case;
  end if;
end process;
end architecture;
