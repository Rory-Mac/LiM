library ieee;
use ieee.std_logic_1164.all;
use work.array_package.all;

entity CoreRegMux is
port (A : in vector_array(0 to 31); 
    Sel: in std_logic_vector(0 to 4);
    X : out std_logic_vector(0 to 31));
end CoreRegMux;

architecture CoreRegMuxLogic of CoreRegMux is
    signal MuxInputs : vector_array(0 to 31);
    signal MuxSelectors : std_logic_vector(0 to 4);
    signal MuxOut : std_logic_vector(0 to 31);
begin
    generateMux32 : for i in 0 to 31 generate
        Mux32instance : entity work.Mux32 port map (A => MuxInputs(i), Sel => MuxSelectors, X => MuxOut(i));
    end generate generateMux32;

    process (A)
    begin
        for i in 0 to 31 loop
            for j in 0 to 31 loop
                MuxInputs(i)(j) <= A(j)(i);
            end loop;
        end loop;
    end process;

    MuxSelectors <= Sel;
    X <= MuxOut;

end CoreRegMuxLogic;

