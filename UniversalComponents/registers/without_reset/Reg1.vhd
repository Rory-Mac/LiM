library ieee;
use ieee.std_logic_1164.all;

entity Reg1 is
port (clk, d, l : in std_logic;
    q: out std_logic);
end Reg1;

architecture Reg1Logic of Reg1 is
    signal dff_clk, d_internal, q_internal : std_logic;
    signal MuxIn : std_logic_vector (0 to 1);
    signal Sel, MuxOut : std_logic;
begin
    DFFInstance : entity work.DFF port map (clk => dff_clk, d => d_internal, q => q_internal);
    MuxInstance : entity work.Mux2 port map (A => MuxIn(0), B => MuxIn(1), Sel => Sel, X => MuxOut);

    dff_clk <= clk;
    MuxIn(0) <= q_internal;
    MuxIn(1) <= d;
    Sel <= l;
    d_internal <= MuxOut;
    q <= q_internal;

end architecture;