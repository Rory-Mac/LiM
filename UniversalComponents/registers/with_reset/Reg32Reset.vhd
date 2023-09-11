library ieee;
use ieee.std_logic_1164.all;

entity Reg32Reset is
port (clk, l, r: in std_logic;
    d: in std_logic_vector(0 to 31);
    q: out std_logic_vector(0 to 31));
end Reg32Reset;

architecture Reg32ResetLogic of Reg32Reset is
    signal clk_internal, l_internal : std_logic;
    signal d_internal, q_internal: std_logic_vector (0 to 31);
begin
    Reg1ResetGenerate : for i in 0 to 31 generate
        Reg1ResetInstance : entity work.Reg1Reset port map (clk => clk_internal, d => d_internal(i), l => l_internal, r => r, q => q_internal(i));
    end generate;

    clk_internal <= clk;
    l_internal <= l;
    d_internal <= d;
    q <= q_internal;

end architecture;