library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnsignedLeftShift is
port (d : in signed(0 to 31);
    sel : in unsigned(0 to 4);
    q : out signed(0 to 31));
end entity;

architecture UnsignedLeftShiftLogic of UnsignedLeftShift is
begin
    process(d, sel)
    begin
            case sel is
                when "00000" => q <= d ;
                when "00001" => q <= d sll 1;
                when "00010" => q <= d sll 2;
                when "00011" => q <= d sll 3;
                when "00100" => q <= d sll 4;
                when "00101" => q <= d sll 5;
                when "00110" => q <= d sll 6;
                when "00111" => q <= d sll 7;
                when "01000" => q <= d sll 8;
                when "01001" => q <= d sll 9;
                when "01010" => q <= d sll 10;
                when "01011" => q <= d sll 11;
                when "01100" => q <= d sll 12;
                when "01101" => q <= d sll 13;
                when "01110" => q <= d sll 14;
                when "01111" => q <= d sll 15;
                when "10000" => q <= d sll 16;
                when "10001" => q <= d sll 17;
                when "10010" => q <= d sll 18;
                when "10011" => q <= d sll 19;
                when "10100" => q <= d sll 20;
                when "10101" => q <= d sll 21;
                when "10110" => q <= d sll 22;
                when "10111" => q <= d sll 23;
                when "11000" => q <= d sll 24;
                when "11001" => q <= d sll 25;
                when "11010" => q <= d sll 26;
                when "11011" => q <= d sll 27;
                when "11100" => q <= d sll 28;
                when "11101" => q <= d sll 29;
                when "11110" => q <= d sll 30;
                when "11111" => q <= d sll 31;
                when others => q <= (others => 'U');
            end case;
    end process;

end architecture;