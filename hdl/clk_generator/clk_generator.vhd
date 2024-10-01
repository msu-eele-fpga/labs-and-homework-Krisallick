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

    signal eighth_out: std_ulogic:='0';
    signal quarter_out: std_ulogic:='0';
    signal half_out: std_ulogic:='0';
    signal twice_out: std_ulogic:='0';
    signal four_out: std_ulogic:='0';


begin
    eighth_count<=shift_right(cnt, 3);
    quarter_count<=shift_right(cnt, 2);
    half_count<=shift_right(cnt, 1);
    twice_count<=shift_left(cnt, 1);
    four_count<=shift_right(cnt, 4);

    eighth:process (clk, counter1, eighth_out)
    begin
        if rst='1' then
            counter1<=(others=>'0');
        elsif rising_edge(clk) then
            counter1<=counter1+1;
            if (counter1=(eighth_count-1)) then
                eighth_out<=not eighth_out;
                counter1<=(others=>'0');
            end if;
        end if;
        eighth_base_rate<=eighth_out;
    end process;
    
    quarter:process (clk, counter2, quarter_out)
    begin
        if rst='1' then
            counter2<=(others=>'0');
        elsif rising_edge(clk) then
            counter2<=counter2+1;
            if (counter2=(quarter_count-1)) then
                quarter_out<=not quarter_out;
                counter2<=(others=>'0');
            end if;
        end if;
        quarter_base_rate<=quarter_out;
    end process;

    half:process (clk, counter3, half_out)
    begin
        if rst='1' then
            counter3<=(others=>'0');
        elsif rising_edge(clk) then
            counter3<=counter3+1;
            if (counter3=(half_count-1)) then
                half_out<=not half_out;
                counter3<=(others=>'0');
            end if;
        end if;
        half_base_rate<=half_out;
    end process;

    twice:process (clk, counter4, twice_out)
    begin
        if rst='1' then
            counter4<=(others=>'0');
        elsif rising_edge(clk) then
            counter4<=counter4+1;
            if (counter4=(twice_count-1)) then
                twice_out<=not twice_out;
                counter4<=(others=>'0');
            end if;
        end if;
        twice_base_rate<=twice_out;
    end process;

    four:process (clk, counter5, four_out)
    begin
        if rst='1' then
            counter5<=(others=>'0');
        elsif rising_edge(clk) then
            counter5<=counter5+1;
            if (counter5=(four_count-1)) then
                four_out<=not four_out;
                counter5<=(others=>'0');
            end if;
        end if;
        four_base_rate<=four_out;
    end process;
    

end architecture;
