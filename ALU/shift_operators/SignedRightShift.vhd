library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignedRightShift is
port (d : in signed(0 to 31);
    sel : in unsigned(0 to 4);
    q : out signed(0 to 31));
end entity;

architecture SignedRightShiftLogic of SignedRightShift is
begin
    process(d, sel)
    begin
            case sel is
                when "00000" => q <= d ;
                when "00001" => q <= shift_right(d, 1);
                when "00010" => q <= shift_right(d, 2);
                when "00011" => q <= shift_right(d, 3);
                when "00100" => q <= shift_right(d, 4);
                when "00101" => q <= shift_right(d, 5);
                when "00110" => q <= shift_right(d, 6);
                when "00111" => q <= shift_right(d, 7);
                when "01000" => q <= shift_right(d, 8);
                when "01001" => q <= shift_right(d, 9);
                when "01010" => q <= shift_right(d, 10);
                when "01011" => q <= shift_right(d, 11);
                when "01100" => q <= shift_right(d, 12);
                when "01101" => q <= shift_right(d, 13);
                when "01110" => q <= shift_right(d, 14);
                when "01111" => q <= shift_right(d, 15);
                when "10000" => q <= shift_right(d, 16);
                when "10001" => q <= shift_right(d, 17);
                when "10010" => q <= shift_right(d, 18);
                when "10011" => q <= shift_right(d, 19);
                when "10100" => q <= shift_right(d, 20);
                when "10101" => q <= shift_right(d, 21);
                when "10110" => q <= shift_right(d, 22);
                when "10111" => q <= shift_right(d, 23);
                when "11000" => q <= shift_right(d, 24);
                when "11001" => q <= shift_right(d, 25);
                when "11010" => q <= shift_right(d, 26);
                when "11011" => q <= shift_right(d, 27);
                when "11100" => q <= shift_right(d, 28);
                when "11101" => q <= shift_right(d, 29);
                when "11110" => q <= shift_right(d, 30);
                when "11111" => q <= shift_right(d, 31);
                when others => q <= (others => 'U');
            end case;
    end process;

end architecture;