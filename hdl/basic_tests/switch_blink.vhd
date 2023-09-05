library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity switch_blink is
    Port ( sw : in STD_LOGIC_VECTOR (0 to 3);
           led0_r, led0_g, led0_b, led1_r, led1_g, led1_b, led2_r, led2_g, led2_b, led3_r, led3_g, led3_b : out STD_LOGIC);
end switch_blink;

architecture Behavioral of switch_blink is
begin
    led0_r <= sw(0);
    led0_g <= sw(0);
    led0_b <= sw(0);
    led1_r <= sw(1);
    led1_g <= sw(1);
    led1_b <= sw(1);
    led2_r <= sw(2);
    led2_g <= sw(2);
    led2_b <= sw(2);
    led3_r <= sw(3);
    led3_g <= sw(3);
    led3_b <= sw(3);
end Behavioral;
