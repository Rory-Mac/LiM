library ieee;
use ieee.std_logic_1164.all;

package array_package is
    type vector_array is array (natural range <>) of std_logic_vector(0 to 31);
end package;