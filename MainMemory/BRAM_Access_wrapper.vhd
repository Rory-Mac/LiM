library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity BRAM_Access_wrapper is
  port (
    clk_controller : in STD_LOGIC
  );
end BRAM_Access_wrapper;

architecture STRUCTURE of BRAM_Access_wrapper is
  component BRAM_Access is
  port (
    clk_controller : in STD_LOGIC
  );
  end component BRAM_Access;
begin
BRAM_Access_i: component BRAM_Access
     port map (
      clk_controller => clk_controller
    );
end STRUCTURE;
