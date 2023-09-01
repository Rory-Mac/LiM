library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity blink is
    Port ( clk : in STD_LOGIC;
            led0 : out STD_LOGIC;
            led1 : out STD_LOGIC;
            led2 : out STD_LOGIC;
            led3 : out STD_LOGIC
    );
end blink;

architecture Behavioral of blink is
    signal counter : std_logic_vector(27 downto 0) := (others => '0');
    signal clk_divs : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if counter = "0010011000100101101000000000" then
                clk_divs(0) <= not clk_divs(0);
            elsif counter = "0100110001001011010000000000" then
                clk_divs(1) <= not clk_divs(1);
            elsif counter = "0111001001110000111000000000" then
                clk_divs(2) <= not clk_divs(2);
            elsif counter = "1001100010010110100000000000" then
                clk_divs(3) <= not clk_divs(3);
                counter <= (others => '0');
            end if;
            counter <= counter + 1;
        end if;    
    end process;
    led0 <= clk_divs(0);
    led1 <= clk_divs(1);
    led2 <= clk_divs(2);
    led3 <= clk_divs(3);
end Behavioral;
