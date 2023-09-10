library ieee;
use ieee.std_logic_1164.all;
use work.array_package.all;

entity CoreRegisters is
port (clk, l : in std_logic;
    sel : in std_logic_vector (0 to 4);
    d : in std_logic_vector (0 to 31);
    q : out std_logic_vector (0 to 31));
end CoreRegisters;

architecture CoreRegisterLogic of CoreRegisters is
    signal clk_internal, demux_in : std_logic;
    signal sel_internal : std_logic_vector(0 to 4);
    signal demux_out, reg_load, data_in, mux_out: std_logic_vector(0 to 31); 
    signal reg_out, mux_in : vector_array(0 to 31);
begin
    Demux32Instance : entity work.Demux32 port map(A => demux_in, sel => sel_internal, X => demux_out);
    CoreRegisters : for i in 0 to 31 generate
        Reg32Instance : entity work.Reg32 port map (clk => clk_internal, l => reg_load(i), d => data_in, q => reg_out(i));
    end generate;
    CoreRegMuxInstance : entity work.CoreRegMux port map(A => mux_in, sel => sel_internal, X => mux_out);

    clk_internal <= clk;
    demux_in <= l;
    sel_internal <= sel;
    reg_load <= demux_out;
    data_in <= d;
    mux_in <= reg_out;
    q <= mux_out;

end CoreRegisterLogic;