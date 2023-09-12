library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UnsignedRightShift is
port (d : in signed(0 to 31);
    sel : in unsigned(0 to 4);
    q : out signed(0 to 31));
end entity;

architecture UnsignedRightShiftLogic of UnsignedRightShift is
begin
    process(d, sel)
    begin
            case sel is
                when "00000" => q <= d ;
                when "00001" => q <= d srl 1;
                when "00010" => q <= d srl 2;
                when "00011" => q <= d srl 3;
                when "00100" => q <= d srl 4;
                when "00101" => q <= d srl 5;
                when "00110" => q <= d srl 6;
                when "00111" => q <= d srl 7;
                when "01000" => q <= d srl 8;
                when "01001" => q <= d srl 9;
                when "01010" => q <= d srl 10;
                when "01011" => q <= d srl 11;
                when "01100" => q <= d srl 12;
                when "01101" => q <= d srl 13;
                when "01110" => q <= d srl 14;
                when "01111" => q <= d srl 15;
                when "10000" => q <= d srl 16;
                when "10001" => q <= d srl 17;
                when "10010" => q <= d srl 18;
                when "10011" => q <= d srl 19;
                when "10100" => q <= d srl 20;
                when "10101" => q <= d srl 21;
                when "10110" => q <= d srl 22;
                when "10111" => q <= d srl 23;
                when "11000" => q <= d srl 24;
                when "11001" => q <= d srl 25;
                when "11010" => q <= d srl 26;
                when "11011" => q <= d srl 27;
                when "11100" => q <= d srl 28;
                when "11101" => q <= d srl 29;
                when "11110" => q <= d srl 30;
                when "11111" => q <= d srl 31;
                when others => q <= (others => 'U');
            end case;
    end process;

end architecture;