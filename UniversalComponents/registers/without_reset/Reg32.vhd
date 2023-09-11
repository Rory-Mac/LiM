library ieee;
use ieee.std_logic_1164.all;

entity Reg32 is
port (clk, l: in std_logic;
    d: in std_logic_vector(0 to 31);
    q: out std_logic_vector(0 to 31));
end Reg32;

architecture Reg32Logic of Reg32 is
    signal clk_internal, l_internal : std_logic;
    signal d_internal, q_internal: std_logic_vector (0 to 31);
begin
    Reg1Generate : for i in 0 to 31 generate
        Reg1Instance : entity work.Reg1 port map (clk => clk_internal, d => d_internal(i), l => l_internal, q => q_internal(i));
    end generate;

    clk_internal <= clk;
    l_internal <= l;
    d_internal <= d;
    q <= q_internal;

end Reg32Logic;