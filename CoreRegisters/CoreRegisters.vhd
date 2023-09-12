library ieee;
use ieee.std_logic_1164.all;
use work.array_package.all;

entity CoreRegisters is
port (clk, l : in std_logic;
    sel1, sel2 : in std_logic_vector (0 to 4);
    d_in : in std_logic_vector (0 to 31);
    reg_out1, reg_out2 : out std_logic_vector (0 to 31));
end CoreRegisters;

architecture CoreRegisterLogic of CoreRegisters is
    signal clk_internal, demux_in : std_logic;
    signal sel1_internal, sel2_internal : std_logic_vector(0 to 4);
    signal demux_out, reg_load, mux_out1, mux_out2: std_logic_vector(0 to 31); 
    signal reg_out, mux_in : vector_array(0 to 31);
begin
    Demux32Instance : entity work.Demux32 port map(A => demux_in, sel => sel1_internal, X => demux_out);
    CoreRegisters : for i in 0 to 31 generate
        Reg32Instance : entity work.Reg32 port map (clk => clk_internal, l => reg_load(i), d => d_in, q => reg_out(i));
    end generate;
    CoreRegMuxInstance1 : entity work.CoreRegMux port map(A => mux_in, sel => sel1_internal, X => mux_out1);
    CoreRegMuxInstance2 : entity work.CoreRegMux port map(A => mux_in, sel => sel2_internal, X => mux_out2);

    clk_internal <= clk;
    demux_in <= l;
    sel1_internal <= sel1;
    sel2_internal <= sel2;
    reg_load <= demux_out;
    mux_in <= reg_out;
    reg_out1 <= mux_out1;
    reg_out2 <= mux_out2;

end CoreRegisterLogic;