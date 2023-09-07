library ieee;
use ieee.std_logic_1164.all;

entity Mux8 is
port (A : in std_logic_vector (0 to 7);
    Sel : in std_logic_vector (0 to 2);
    X : out std_logic);
end Mux8;

architecture Mux8Logic of Mux8 is
signal ComponentMuxIn :  std_logic_vector (0 to 7);
signal ComponentMuxOut : std_logic_vector (0 to 1);
signal Component1Sels : std_logic_vector (0 to 1);
signal Component2Sels : std_logic_vector (0 to 1);
signal MuxSel : std_logic;
signal MuxIn : std_logic_vector (0 to 1);
signal MuxOut : std_logic;

begin
    Mux2Instance1 : entity work.Mux4 port map (A => ComponentMuxIn(0 to 3), Sel => Component1Sels, X => ComponentMuxOut(0));
    Mux2Instance2 : entity work.Mux4 port map (A => ComponentMuxIn(4 to 7), Sel => Component2Sels, X => ComponentMuxOut(1));
    Mux2Instance3 : entity work.Mux2 port map (A => MuxIn(0), B => MuxIn(1), Sel => MuxSel, X => MuxOut);

    ComponentMuxIn <= A;
    Component1Sels <= Sel(1 to 2);
    Component2Sels <= Sel(1 to 2); 
    MuxSel <= Sel(0);
    MuxIn <= ComponentMuxOut;
    X <= MuxOut;

end Mux8Logic;
