library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnsignedLeftShift is
port (d : in unsigned(0 to 31);
    sel : in unsigned(0 to 4);
    q : out unsigned(0 to 31));
end entity;

architecture UnsignedLeftShiftLogic of UnsignedLeftShift is
begin
    process(d, sel)
    begin
            case sel is
                when "00000" => q <= d ;
                when "00001" => q <= shift_left(d, 1);
                when "00010" => q <= shift_left(d, 2);
                when "00011" => q <= shift_left(d, 3);
                when "00100" => q <= shift_left(d, 4);
                when "00101" => q <= shift_left(d, 5);
                when "00110" => q <= shift_left(d, 6);
                when "00111" => q <= shift_left(d, 7);
                when "01000" => q <= shift_left(d, 8);
                when "01001" => q <= shift_left(d, 9);
                when "01010" => q <= shift_left(d, 10);
                when "01011" => q <= shift_left(d, 11);
                when "01100" => q <= shift_left(d, 12);
                when "01101" => q <= shift_left(d, 13);
                when "01110" => q <= shift_left(d, 14);
                when "01111" => q <= shift_left(d, 15);
                when "10000" => q <= shift_left(d, 16);
                when "10001" => q <= shift_left(d, 17);
                when "10010" => q <= shift_left(d, 18);
                when "10011" => q <= shift_left(d, 19);
                when "10100" => q <= shift_left(d, 20);
                when "10101" => q <= shift_left(d, 21);
                when "10110" => q <= shift_left(d, 22);
                when "10111" => q <= shift_left(d, 23);
                when "11000" => q <= shift_left(d, 24);
                when "11001" => q <= shift_left(d, 25);
                when "11010" => q <= shift_left(d, 26);
                when "11011" => q <= shift_left(d, 27);
                when "11100" => q <= shift_left(d, 28);
                when "11101" => q <= shift_left(d, 29);
                when "11110" => q <= shift_left(d, 30);
                when "11111" => q <= shift_left(d, 31);
                when others => q <= (others => 'U');
            end case;
    end process;

end architecture;