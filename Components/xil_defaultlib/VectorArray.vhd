library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package array_package is
    type vector_array is array (natural range <>) of signed(0 to 63);
end package;