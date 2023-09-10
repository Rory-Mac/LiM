library ieee;
use ieee.std_logic_1164.all;

entity Demux8 is
port (A: in std_logic;
    Sel: in std_logic_vector(0 to 2);
    X: out std_logic_vector(0 to 7));
end Demux8;

architecture Demux8Logic of Demux8 is
    signal DemuxIn, DemuxSel : std_logic;
    signal DemuxOut : std_logic_vector(0 to 1);
    signal Component1In, Component2In : std_logic;
    signal Component1Sel : std_logic_vector(0 to 1);
    signal Component2Sel : std_logic_vector(0 to 1);
    signal ComponentsOut : std_logic_vector(0 to 7);

begin
    Demux : entity work.Demux2 port map (A => DemuxIn, Sel => DemuxSel, X1 => DemuxOut(0), X2 => DemuxOut(1));
    ComponentDemux1 : entity work.Demux4 port map (A => Component1In, Sel => Component1Sel, X => ComponentsOut(0 to 3));
    ComponentDemux2 : entity work.Demux4 port map (A => Component2In, Sel => Component2Sel, X => ComponentsOut(4 to 7));

    DemuxIn <= A;
    DemuxSel <= Sel(0);
    Component1In <= DemuxOut(0);
    Component2In <= DemuxOut(1);
    Component1Sel <= Sel(1 to 2);
    Component2Sel <= Sel(1 to 2);
    X <= ComponentsOut;

end Demux8Logic;
