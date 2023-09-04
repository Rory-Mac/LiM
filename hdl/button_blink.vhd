library ieee;
use ieee.std_logic_1164.all;

entity button_blink_test is
    Port (btn : in std_logic_vector(0 to 3);
           led0_r, led0_g, led0_b, led1_r, led1_g, led1_b, led2_r, led2_g, led2_b, led3_r, led3_g, led3_b : out STD_LOGIC);
end button_blink_test;

architecture Behavioral of button_blink_test is
begin
    led0_r <= btn(0);
    led0_g <= btn(0);
    led0_b <= btn(0);
    led1_r <= btn(1);
    led1_g <= btn(1);
    led1_b <= btn(1);
    led2_r <= btn(2);
    led2_g <= btn(2);
    led2_b <= btn(2);
    led3_r <= btn(3);
    led3_g <= btn(3);
    led3_b <= btn(3);

end Behavioral;
