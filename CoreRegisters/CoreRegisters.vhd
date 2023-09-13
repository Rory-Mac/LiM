library ieee;
use ieee.std_logic_1164.all;
use work.array_package.all;

entity CoreRegisters is
port (clk, load : in std_logic;
    sel1, sel2 : in std_logic_vector (0 to 4);
    data_in : in std_logic_vector (0 to 31);
    data_out1, data_out2 : out std_logic_vector (0 to 31));
end CoreRegisters;

architecture alternate of CoreRegisters is
    signal stored_values : vector_array(0 to 31);
begin
    process (clk)
    begin
        if rising_edge(clk) and load = '1' then
            case sel1 is
                when "00000" => stored_values(0) <= data_in;
                when "00001" => stored_values(1) <= data_in;
                when "00010" => stored_values(2) <= data_in;
                when "00011" => stored_values(3) <= data_in;
                when "00100" => stored_values(4) <= data_in;
                when "00101" => stored_values(5) <= data_in;
                when "00110" => stored_values(6) <= data_in;
                when "00111" => stored_values(7) <= data_in;
                when "01000" => stored_values(8) <= data_in;
                when "01001" => stored_values(9) <= data_in;
                when "01010" => stored_values(10) <= data_in;
                when "01011" => stored_values(11) <= data_in;
                when "01100" => stored_values(12) <= data_in;
                when "01101" => stored_values(13) <= data_in;
                when "01110" => stored_values(14) <= data_in;
                when "01111" => stored_values(15) <= data_in;
                when "10000" => stored_values(16) <= data_in;
                when "10001" => stored_values(17) <= data_in;
                when "10010" => stored_values(18) <= data_in;
                when "10011" => stored_values(19) <= data_in;
                when "10100" => stored_values(20) <= data_in;
                when "10101" => stored_values(21) <= data_in;
                when "10110" => stored_values(22) <= data_in;
                when "10111" => stored_values(23) <= data_in;
                when "11000" => stored_values(24) <= data_in;
                when "11001" => stored_values(25) <= data_in;
                when "11010" => stored_values(26) <= data_in;
                when "11011" => stored_values(27) <= data_in;
                when "11100" => stored_values(28) <= data_in;
                when "11101" => stored_values(29) <= data_in;
                when "11110" => stored_values(30) <= data_in;
                when "11111" => stored_values(31) <= data_in;
                when others => null;
            end case;
        end if;
        case sel1 is
            when "00000" => data_out1 <= stored_values(0);
            when "00001" => data_out1 <= stored_values(1);
            when "00010" => data_out1 <= stored_values(2);
            when "00011" => data_out1 <= stored_values(3);
            when "00100" => data_out1 <= stored_values(4);
            when "00101" => data_out1 <= stored_values(5);
            when "00110" => data_out1 <= stored_values(6);
            when "00111" => data_out1 <= stored_values(7);
            when "01000" => data_out1 <= stored_values(8);
            when "01001" => data_out1 <= stored_values(9);
            when "01010" => data_out1 <= stored_values(10);
            when "01011" => data_out1 <= stored_values(11);
            when "01100" => data_out1 <= stored_values(12);
            when "01101" => data_out1 <= stored_values(13);
            when "01110" => data_out1 <= stored_values(14);
            when "01111" => data_out1 <= stored_values(15);
            when "10000" => data_out1 <= stored_values(16);
            when "10001" => data_out1 <= stored_values(17);
            when "10010" => data_out1 <= stored_values(18);
            when "10011" => data_out1 <= stored_values(19);
            when "10100" => data_out1 <= stored_values(20);
            when "10101" => data_out1 <= stored_values(21);
            when "10110" => data_out1 <= stored_values(22);
            when "10111" => data_out1 <= stored_values(23);
            when "11000" => data_out1 <= stored_values(24);
            when "11001" => data_out1 <= stored_values(25);
            when "11010" => data_out1 <= stored_values(26);
            when "11011" => data_out1 <= stored_values(27);
            when "11100" => data_out1 <= stored_values(28);
            when "11101" => data_out1 <= stored_values(29);
            when "11110" => data_out1 <= stored_values(30);
            when "11111" => data_out1 <= stored_values(31);
            when others => null;
        end case;
        case sel2 is
            when "00000" => data_out2 <= stored_values(0);
            when "00001" => data_out2 <= stored_values(1);
            when "00010" => data_out2 <= stored_values(2);
            when "00011" => data_out2 <= stored_values(3);
            when "00100" => data_out2 <= stored_values(4);
            when "00101" => data_out2 <= stored_values(5);
            when "00110" => data_out2 <= stored_values(6);
            when "00111" => data_out2 <= stored_values(7);
            when "01000" => data_out2 <= stored_values(8);
            when "01001" => data_out2 <= stored_values(9);
            when "01010" => data_out2 <= stored_values(10);
            when "01011" => data_out2 <= stored_values(11);
            when "01100" => data_out2 <= stored_values(12);
            when "01101" => data_out2 <= stored_values(13);
            when "01110" => data_out2 <= stored_values(14);
            when "01111" => data_out2 <= stored_values(15);
            when "10000" => data_out2 <= stored_values(16);
            when "10001" => data_out2 <= stored_values(17);
            when "10010" => data_out2 <= stored_values(18);
            when "10011" => data_out2 <= stored_values(19);
            when "10100" => data_out2 <= stored_values(20);
            when "10101" => data_out2 <= stored_values(21);
            when "10110" => data_out2 <= stored_values(22);
            when "10111" => data_out2 <= stored_values(23);
            when "11000" => data_out2 <= stored_values(24);
            when "11001" => data_out2 <= stored_values(25);
            when "11010" => data_out2 <= stored_values(26);
            when "11011" => data_out2 <= stored_values(27);
            when "11100" => data_out2 <= stored_values(28);
            when "11101" => data_out2 <= stored_values(29);
            when "11110" => data_out2 <= stored_values(30);
            when "11111" => data_out2 <= stored_values(31);
            when others => null;
        end case;
    end process;

end architecture;