library ieee;
use ieee.std_logic_1164.all;

entity Demux4 is
port (A: in std_logic;
    Sel: in std_logic_vector(0 to 1);
    X: out std_logic_vector(0 to 3));
end Demux4;

architecture Demux4Logic of Demux4 is
    signal DemuxIn, DemuxSel : std_logic;
    signal DemuxOut : std_logic_vector(0 to 1);
    signal Component1In, Component2In : std_logic;
    signal Component1Sel : std_logic;
    signal Component2Sel : std_logic;
    signal ComponentsOut : std_logic_vector(0 to 3);
    
begin
    Demux : entity work.Demux2 port map (A => DemuxIn, Sel => DemuxSel, X1 => DemuxOut(0), X2 => DemuxOut(1));
    ComponentDemux1 : entity work.Demux2 port map (A => Component1In, Sel => Component1Sel, X1 => ComponentsOut(0), X2 => ComponentsOut(1));
    ComponentDemux2 : entity work.Demux2 port map (A => Component2In, Sel => Component2Sel, X1 => ComponentsOut(2), X2 => ComponentsOut(3));

    DemuxIn <= A;
    DemuxSel <= Sel(0);
    Component1In <= DemuxOut(0);
    Component2In <= DemuxOut(1);
    Component1Sel <= Sel(1);
    Component2Sel <= Sel(1);
    X <= ComponentsOut;

end Demux4Logic;
