library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_generator is
    -- generic (
    --     cnt: unsigned(29 downto 0)
    -- );
    port (
        clk   : in std_ulogic;
        rst : in std_ulogic;
        cnt: in unsigned(29 downto 0);
        eighth_base_rate:out std_ulogic:='0';
        quarter_base_rate: out std_ulogic:='0';
        half_base_rate: out std_ulogic:='0';
        twice_base_rate: out std_ulogic:='0';
        four_base_rate: out std_ulogic:='0'
    );
end entity;

architecture rtl of clk_generator is
    signal eighth_count:unsigned(29 downto 0);
    signal quarter_count:unsigned(29 downto 0);
    signal half_count:unsigned(29 downto 0);
    signal twice_count:unsigned(29 downto 0);
    signal four_count:unsigned(29 downto 0);

    signal counter1: unsigned(39 downto 0):=(others=>'0');
    signal counter2: unsigned(39 downto 0):=(others=>'0');
    signal counter3: unsigned(39 downto 0):=(others=>'0');
    signal counter4: unsigned(39 downto 0):=(others=>'0');
    signal counter5: unsigned(39 downto 0):=(others=>'0');

    

begin
    eighth_count<=shift_right(cnt, 3);
    quarter_count<=shift_right(cnt, 2);
    half_count<=shift_right(cnt, 1);
    twice_count<=shift_left(cnt, 1);
    four_count<=shift_left(cnt, 2);

    eighth:process (clk, counter1, eighth_base_rate)
    begin
        if rst='1' then
            counter1<=(others=>'0');
        elsif rising_edge(clk) then
            counter1<=counter1+1;
            if (counter1=(eighth_count-1)) then
                eighth_base_rate<=not eighth_base_rate;
                counter1<=(others=>'0');
            end if;
        end if;
    end process;
    
    quarter:process (clk, counter2, quarter_base_rate)
    begin
        if rst='1' then
            counter2<=(others=>'0');
        elsif rising_edge(clk) then
            counter2<=counter2+1;
            if (counter2=(quarter_count-1)) then
                quarter_base_rate<=not quarter_base_rate;
                counter2<=(others=>'0');
            end if;
        end if;
    end process;

    half:process (clk, counter3, half_base_rate)
    begin
        if rst='1' then
            counter3<=(others=>'0');
        elsif rising_edge(clk) then
            counter3<=counter3+1;
            if (counter3=(half_count-1)) then
                half_base_rate<=not half_base_rate;
                counter3<=(others=>'0');
            end if;
        end if;
    end process;

    twice:process (clk, counter4, twice_base_rate)
    begin
        if rst='1' then
            counter4<=(others=>'0');
        elsif rising_edge(clk) then
            counter4<=counter4+1;
            if (counter4=(twice_count-1)) then
                twice_base_rate<=not twice_base_rate;
                counter4<=(others=>'0');
            end if;
        end if;
    end process;

    four:process (clk, counter5, four_base_rate)
    begin
        if rst='1' then
            counter5<=(others=>'0');
        elsif rising_edge(clk) then
            counter5<=counter5+1;
            if (counter5=(four_count-1)) then
                four_base_rate<=not four_base_rate;
                counter5<=(others=>'0');
            end if;
        end if;
    end process;
    

end architecture;
