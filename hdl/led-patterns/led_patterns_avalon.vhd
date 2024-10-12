library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_avalon is
    port (
    clk : in std_ulogic;
    rst : in std_ulogic;
    -- avalon memory-mapped slave interface
    avs_read : in std_logic;
    avs_write : in std_logic;
    avs_address : in std_logic_vector(1 downto 0);
    avs_readdata : out std_logic_vector(31 downto 0);
    avs_writedata : in std_logic_vector(31 downto 0);
    -- external I/O; export to top-level
    push_button : in std_ulogic;
    switches : in std_ulogic_vector(3 downto 0);
    led : out std_ulogic_vector(7 downto 0)
    );
    end entity led_patterns_avalon;
    

    architecture rtl of led_patterns_avalon is
        component led_patterns is
            generic (
                system_clock_period : time := 20 ns
            );
            port (
                clk : in std_ulogic;
                rst : in std_ulogic;
                push_button : in std_ulogic;
                switches : in std_ulogic_vector(3 downto 0);
                hps_led_control : in boolean;
                base_period : in unsigned(7 downto 0):="00010000"; --4 int bits 4 frac bits
                led_reg : in std_ulogic_vector(7 downto 0);
                led : out std_ulogic_vector(7 downto 0):="00000000"
            );
        end component;


        -- Registers
        signal hps_led_control : std_logic_vector(31 downto 0) := (others => '0');
        signal base_period : std_logic_vector(31 downto 0) := "00000000000000000000000000010000"; --4 frac bits, 28 integer bits
        signal led_reg : std_logic_vector(31 downto 0) := (others => '0');
        
        --End Registers
        signal hps_led_control_switcheroo: boolean:=false;

    begin
        bool: process(hps_led_control)
        begin
            if (hps_led_control(0)='1') then
                hps_led_control_switcheroo<=true;
            else
                hps_led_control_switcheroo<=false;
            end if;
        end process;

        led_patt: led_patterns
            port map (
                clk   => clk,
                rst => rst,
                hps_led_control=>hps_led_control_switcheroo,
                push_button=>push_button,
                switches=>switches(3 downto 0),
                base_period=>unsigned(base_period(7 downto 0)),
                led_reg=>std_ulogic_vector(led_reg(7 downto 0)),
                led=>led(7 downto 0)
            );
    
        avalon_register_read: process(clk)
            begin
                if rising_edge(clk) then
                    case avs_address is
                        when "00" => avs_readdata <= hps_led_control;
                        when "01" => avs_readdata <= base_period;
                        when "11" => avs_readdata <= led_reg;
                        when others => avs_readdata <= (others => '0');
                    end case;
                end if;
            end process;

        avalon_register_write: process(clk, rst)
        begin
            if (rst='1') then
                hps_led_control <= (others => '0');
                base_period <= "00000000000000000000000000010000";
                led_reg <= (others => '0');
            elsif rising_edge(clk) and avs_write='1' then
                case avs_address is
                    when "00" => hps_led_control <= avs_writedata(31 downto 0);
                    when "01" => base_period <= avs_writedata(31 downto 0);
                    when "10" => led_reg <= avs_writedata(31 downto 0);
                    when others =>
                        null;
                end case;
            end if;
        end process;
    end architecture;