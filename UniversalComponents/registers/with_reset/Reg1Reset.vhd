library ieee;
use ieee.std_logic_1164.all;

entity Reg1Reset is
port (clk, d, l, r : in std_logic;
    q: out std_logic);
end Reg1Reset;

architecture Reg1ResetLogic of Reg1Reset is
    signal clk_internal, d_internal, q_internal : std_logic;
    signal MuxIn : std_logic_vector (0 to 1);
    signal Sel, MuxOut : std_logic;
begin
    DFFResetInstance : entity work.DFFReset port map (clk => clk_internal, d => d_internal, r => r, q => q_internal);
    MuxInstance : entity work.Mux2 port map (A => MuxIn(0), B => MuxIn(1), Sel => Sel, X => MuxOut);

    clk_internal <= clk;
    MuxIn(0) <= q_internal;
    MuxIn(1) <= d;
    Sel <= l;
    d_internal <= MuxOut;
    q <= q_internal;

end architecture;