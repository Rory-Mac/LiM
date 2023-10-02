library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity BRAM_Access_wrapper is
  port (
    clk : in STD_LOGIC;
    data_addr, instr_addr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    data_in, instr_in : in STD_LOGIC_VECTOR ( 63 downto 0 );
    data_out, instr_out : out STD_LOGIC_VECTOR ( 63 downto 0 );
    w_data, w_instr : in STD_LOGIC
  );
end BRAM_Access_wrapper;

architecture STRUCTURE of BRAM_Access_wrapper is
  component BRAM_Access is
  port (
    clk : in STD_LOGIC;
    w_data, w_instr : in STD_LOGIC;
    data_out, instr_out : out STD_LOGIC_VECTOR ( 63 downto 0 );
    data_in, instr_in : in STD_LOGIC_VECTOR ( 63 downto 0 );
    data_addr, instr_addr : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
  end component BRAM_Access;
begin
BRAM_Access_i: component BRAM_Access
     port map (
      clk => clk,
      data_addr(15 downto 0) => data_addr(15 downto 0),
      data_in(63 downto 0) => data_in(63 downto 0),
      data_out(63 downto 0) => data_out(63 downto 0),
      instr_addr(15 downto 0) => instr_addr(15 downto 0),
      instr_in(63 downto 0) => instr_in(63 downto 0),
      instr_out(63 downto 0) => instr_out(63 downto 0),
      w_data => w_data,
      w_instr => w_instr
    );
end STRUCTURE;
