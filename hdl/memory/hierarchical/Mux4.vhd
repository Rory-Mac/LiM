library ieee;
use ieee.std_logic_1164.all;

entity Mux4 is
port (A : in std_logic_vector (0 to 3);
    Sel : in std_logic_vector (0 to 1);
    X : out std_logic);
end Mux4;

architecture Mux4Logic of Mux4 is
signal ComponentMuxIn :  std_logic_vector (0 to 3);
signal ComponentMuxOut : std_logic_vector (0 to 1);
signal MuxSelectors1 : std_logic_vector (0 to 1);
signal MuxSelector2 : std_logic;
signal MuxIn : std_logic_vector (0 to 1);
signal MuxOut : std_logic;

begin
    Mux2Instance1 : entity work.Mux2 port map (A => ComponentMuxIn(0), B => ComponentMuxIn(1), Sel => MuxSelectors1(0), X => ComponentMuxOut(0));
    Mux2Instance2 : entity work.Mux2 port map (A => ComponentMuxIn(2), B => ComponentMuxIn(3), Sel => MuxSelectors1(1), X => ComponentMuxOut(1));
    Mux2Instance3 : entity work.Mux2 port map (A => MuxIn(0), B => MuxIn(1), Sel => MuxSelector2, X => MuxOut);

    ComponentMuxIn <= A;
    MuxSelectors1(0) <= Sel(1);
    MuxSelectors1(1) <= Sel(1);
    MuxSelector2 <= Sel(0);
    MuxIn <= ComponentMuxOut;
    X <= MuxOut;

end Mux4Logic;
