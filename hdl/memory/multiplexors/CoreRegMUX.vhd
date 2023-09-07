library ieee;
use ieee.std_logic_1164.all;

package my_package is
    type vector_array is array (natural range <>) of std_logic_vector(0 to 31);
end package;

library ieee;
use ieee.std_logic_1164.all;
use work.my_package.all;

entity CoreRegMux is
port (A : in vector_array(0 to 31); 
    X : out std_logic_vector(0 to 31));
end CoreRegMux;

architecture CoreRegMuxLogic of CoreRegMux is
    signal MuxInputs : vector_array(0 to 31);
    signal MuxSelectors : std_logic_vector(0 to 4);
    signal MuxOut : std_logic_vector(0 to 31);
begin
    generateMux32 : for i in 0 to 31 generate
        Mux32instance : entity work.Mux32 port map (A => MuxInputs(i), Sel => MuxSelectors, X => MuxOut);
    end generate generateMux32;

    process
    begin
        for i in 0 to 31 loop
            for j in 0 to 31 loop
                MuxInputs(i)(j) <= vector_array(j)(i);
            end loop;
        end loop;
    end process;

end CoreRegMuxLogic;

