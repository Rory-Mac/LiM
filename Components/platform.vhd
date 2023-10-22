library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity platform is
  port (
    clk_in : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of platform : entity is "platform,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=platform,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=4,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of platform : entity is "platform.hwdef";
end platform;

architecture STRUCTURE of platform is
  component platform_ALU_0_0 is
  port (
    opcode : in STD_LOGIC_VECTOR ( 0 to 6 );
    funct3 : in STD_LOGIC_VECTOR ( 0 to 2 );
    funct7 : in STD_LOGIC_VECTOR ( 0 to 6 );
    imm : in STD_LOGIC_VECTOR ( 0 to 11 );
    rs : in STD_LOGIC_VECTOR ( 0 to 63 );
    rt : in STD_LOGIC_VECTOR ( 0 to 63 );
    rd : out STD_LOGIC_VECTOR ( 0 to 63 );
    eq : out STD_LOGIC;
    lt : out STD_LOGIC;
    ltu : out STD_LOGIC
  );
  end component platform_ALU_0_0;
  component platform_CoreRegisters_0_0 is
  port (
    clk : in STD_LOGIC;
    opcode : in STD_LOGIC_VECTOR ( 0 to 6 );
    upper_imm : in STD_LOGIC_VECTOR ( 63 downto 0 );
    ra : in STD_LOGIC_VECTOR ( 63 downto 0 );
    lv : in STD_LOGIC_VECTOR ( 63 downto 0 );
    rs_sel : in STD_LOGIC_VECTOR ( 0 to 4 );
    rt_sel : in STD_LOGIC_VECTOR ( 0 to 4 );
    rd_sel : in STD_LOGIC_VECTOR ( 0 to 4 );
    rd_in : in STD_LOGIC_VECTOR ( 0 to 63 );
    rs_out : out STD_LOGIC_VECTOR ( 0 to 63 );
    rt_out : out STD_LOGIC_VECTOR ( 0 to 63 )
  );
  end component platform_CoreRegisters_0_0;
  component platform_ControlUnit_0_0 is
  port (
    clk : in STD_LOGIC;
    instruction : in STD_LOGIC_VECTOR ( 63 downto 0 );
    eq : in STD_LOGIC;
    lt : in STD_LOGIC;
    ltu : in STD_LOGIC;
    pc_out : out STD_LOGIC_VECTOR ( 0 to 15 );
    opcode : out STD_LOGIC_VECTOR ( 6 downto 0 );
    rd_sel : out STD_LOGIC_VECTOR ( 4 downto 0 );
    rs_sel : out STD_LOGIC_VECTOR ( 4 downto 0 );
    rt_sel : out STD_LOGIC_VECTOR ( 4 downto 0 );
    funct3 : out STD_LOGIC_VECTOR ( 2 downto 0 );
    funct7 : out STD_LOGIC_VECTOR ( 6 downto 0 );
    I_imm : out STD_LOGIC_VECTOR ( 11 downto 0 );
    U_imm : out STD_LOGIC_VECTOR ( 63 downto 0 );
    LS_offset : out STD_LOGIC_VECTOR ( 11 downto 0 );
    ja : in STD_LOGIC_VECTOR ( 0 to 63 );
    ra : out STD_LOGIC_VECTOR ( 0 to 63 )
  );
  end component platform_ControlUnit_0_0;
  component platform_MainMemory_wrapper_0_0 is
  port (
    clk : in STD_LOGIC;
    opcode : in STD_LOGIC_VECTOR ( 0 to 6 );
    funct3 : in STD_LOGIC_VECTOR ( 0 to 2 );
    LS_offset : in STD_LOGIC_VECTOR ( 0 to 11 );
    LS_addr : in STD_LOGIC_VECTOR ( 63 downto 0 );
    instr_addr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    data_in : in STD_LOGIC_VECTOR ( 63 downto 0 );
    data_out : out STD_LOGIC_VECTOR ( 63 downto 0 );
    instr_out : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  end component platform_MainMemory_wrapper_0_0;
  signal ALU_0_eq : STD_LOGIC;
  signal ALU_0_lt : STD_LOGIC;
  signal ALU_0_ltu : STD_LOGIC;
  signal ALU_0_rd : STD_LOGIC_VECTOR ( 0 to 63 );
  signal ControlUnit_0_I_imm : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal ControlUnit_0_S_imm : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal ControlUnit_0_U_imm : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal ControlUnit_0_funct3 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ControlUnit_0_funct7 : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal ControlUnit_0_opcode : STD_LOGIC_VECTOR ( 6 downto 0 );
  signal ControlUnit_0_pc_out : STD_LOGIC_VECTOR ( 0 to 15 );
  signal ControlUnit_0_ra : STD_LOGIC_VECTOR ( 0 to 63 );
  signal ControlUnit_0_rd_sel : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal ControlUnit_0_rs_sel : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal ControlUnit_0_rt_sel : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal CoreRegisters_0_rs_out : STD_LOGIC_VECTOR ( 0 to 63 );
  signal CoreRegisters_0_rt_out : STD_LOGIC_VECTOR ( 0 to 63 );
  signal MainMemory_wrapper_0_data_out : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal MainMemory_wrapper_0_instr_out : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal clk_in_1 : STD_LOGIC;
begin
  clk_in_1 <= clk_in;
ALU_0: component platform_ALU_0_0
     port map (
      eq => ALU_0_eq,
      funct3(0) => ControlUnit_0_funct3(2),
      funct3(1) => ControlUnit_0_funct3(1),
      funct3(2) => ControlUnit_0_funct3(0),
      funct7(0) => ControlUnit_0_funct7(6),
      funct7(1) => ControlUnit_0_funct7(5),
      funct7(2) => ControlUnit_0_funct7(4),
      funct7(3) => ControlUnit_0_funct7(3),
      funct7(4) => ControlUnit_0_funct7(2),
      funct7(5) => ControlUnit_0_funct7(1),
      funct7(6) => ControlUnit_0_funct7(0),
      imm(0) => ControlUnit_0_I_imm(11),
      imm(1) => ControlUnit_0_I_imm(10),
      imm(2) => ControlUnit_0_I_imm(9),
      imm(3) => ControlUnit_0_I_imm(8),
      imm(4) => ControlUnit_0_I_imm(7),
      imm(5) => ControlUnit_0_I_imm(6),
      imm(6) => ControlUnit_0_I_imm(5),
      imm(7) => ControlUnit_0_I_imm(4),
      imm(8) => ControlUnit_0_I_imm(3),
      imm(9) => ControlUnit_0_I_imm(2),
      imm(10) => ControlUnit_0_I_imm(1),
      imm(11) => ControlUnit_0_I_imm(0),
      lt => ALU_0_lt,
      ltu => ALU_0_ltu,
      opcode(0) => ControlUnit_0_opcode(6),
      opcode(1) => ControlUnit_0_opcode(5),
      opcode(2) => ControlUnit_0_opcode(4),
      opcode(3) => ControlUnit_0_opcode(3),
      opcode(4) => ControlUnit_0_opcode(2),
      opcode(5) => ControlUnit_0_opcode(1),
      opcode(6) => ControlUnit_0_opcode(0),
      rd(0 to 63) => ALU_0_rd(0 to 63),
      rs(0 to 63) => CoreRegisters_0_rs_out(0 to 63),
      rt(0 to 63) => CoreRegisters_0_rt_out(0 to 63)
    );
ControlUnit_0: component platform_ControlUnit_0_0
     port map (
      I_imm(11 downto 0) => ControlUnit_0_I_imm(11 downto 0),
      LS_offset(11 downto 0) => ControlUnit_0_S_imm(11 downto 0),
      U_imm(63 downto 0) => ControlUnit_0_U_imm(63 downto 0),
      clk => clk_in_1,
      eq => ALU_0_eq,
      funct3(2 downto 0) => ControlUnit_0_funct3(2 downto 0),
      funct7(6 downto 0) => ControlUnit_0_funct7(6 downto 0),
      instruction(63 downto 0) => MainMemory_wrapper_0_instr_out(63 downto 0),
      ja(0 to 63) => CoreRegisters_0_rs_out(0 to 63),
      lt => ALU_0_lt,
      ltu => ALU_0_ltu,
      opcode(6 downto 0) => ControlUnit_0_opcode(6 downto 0),
      pc_out(0 to 15) => ControlUnit_0_pc_out(0 to 15),
      ra(0 to 63) => ControlUnit_0_ra(0 to 63),
      rd_sel(4 downto 0) => ControlUnit_0_rd_sel(4 downto 0),
      rs_sel(4 downto 0) => ControlUnit_0_rs_sel(4 downto 0),
      rt_sel(4 downto 0) => ControlUnit_0_rt_sel(4 downto 0)
    );
CoreRegisters_0: component platform_CoreRegisters_0_0
     port map (
      clk => clk_in_1,
      lv(63 downto 0) => MainMemory_wrapper_0_data_out(63 downto 0),
      opcode(0) => ControlUnit_0_opcode(6),
      opcode(1) => ControlUnit_0_opcode(5),
      opcode(2) => ControlUnit_0_opcode(4),
      opcode(3) => ControlUnit_0_opcode(3),
      opcode(4) => ControlUnit_0_opcode(2),
      opcode(5) => ControlUnit_0_opcode(1),
      opcode(6) => ControlUnit_0_opcode(0),
      ra(63) => ControlUnit_0_ra(0),
      ra(62) => ControlUnit_0_ra(1),
      ra(61) => ControlUnit_0_ra(2),
      ra(60) => ControlUnit_0_ra(3),
      ra(59) => ControlUnit_0_ra(4),
      ra(58) => ControlUnit_0_ra(5),
      ra(57) => ControlUnit_0_ra(6),
      ra(56) => ControlUnit_0_ra(7),
      ra(55) => ControlUnit_0_ra(8),
      ra(54) => ControlUnit_0_ra(9),
      ra(53) => ControlUnit_0_ra(10),
      ra(52) => ControlUnit_0_ra(11),
      ra(51) => ControlUnit_0_ra(12),
      ra(50) => ControlUnit_0_ra(13),
      ra(49) => ControlUnit_0_ra(14),
      ra(48) => ControlUnit_0_ra(15),
      ra(47) => ControlUnit_0_ra(16),
      ra(46) => ControlUnit_0_ra(17),
      ra(45) => ControlUnit_0_ra(18),
      ra(44) => ControlUnit_0_ra(19),
      ra(43) => ControlUnit_0_ra(20),
      ra(42) => ControlUnit_0_ra(21),
      ra(41) => ControlUnit_0_ra(22),
      ra(40) => ControlUnit_0_ra(23),
      ra(39) => ControlUnit_0_ra(24),
      ra(38) => ControlUnit_0_ra(25),
      ra(37) => ControlUnit_0_ra(26),
      ra(36) => ControlUnit_0_ra(27),
      ra(35) => ControlUnit_0_ra(28),
      ra(34) => ControlUnit_0_ra(29),
      ra(33) => ControlUnit_0_ra(30),
      ra(32) => ControlUnit_0_ra(31),
      ra(31) => ControlUnit_0_ra(32),
      ra(30) => ControlUnit_0_ra(33),
      ra(29) => ControlUnit_0_ra(34),
      ra(28) => ControlUnit_0_ra(35),
      ra(27) => ControlUnit_0_ra(36),
      ra(26) => ControlUnit_0_ra(37),
      ra(25) => ControlUnit_0_ra(38),
      ra(24) => ControlUnit_0_ra(39),
      ra(23) => ControlUnit_0_ra(40),
      ra(22) => ControlUnit_0_ra(41),
      ra(21) => ControlUnit_0_ra(42),
      ra(20) => ControlUnit_0_ra(43),
      ra(19) => ControlUnit_0_ra(44),
      ra(18) => ControlUnit_0_ra(45),
      ra(17) => ControlUnit_0_ra(46),
      ra(16) => ControlUnit_0_ra(47),
      ra(15) => ControlUnit_0_ra(48),
      ra(14) => ControlUnit_0_ra(49),
      ra(13) => ControlUnit_0_ra(50),
      ra(12) => ControlUnit_0_ra(51),
      ra(11) => ControlUnit_0_ra(52),
      ra(10) => ControlUnit_0_ra(53),
      ra(9) => ControlUnit_0_ra(54),
      ra(8) => ControlUnit_0_ra(55),
      ra(7) => ControlUnit_0_ra(56),
      ra(6) => ControlUnit_0_ra(57),
      ra(5) => ControlUnit_0_ra(58),
      ra(4) => ControlUnit_0_ra(59),
      ra(3) => ControlUnit_0_ra(60),
      ra(2) => ControlUnit_0_ra(61),
      ra(1) => ControlUnit_0_ra(62),
      ra(0) => ControlUnit_0_ra(63),
      rd_in(0 to 63) => ALU_0_rd(0 to 63),
      rd_sel(0) => ControlUnit_0_rd_sel(4),
      rd_sel(1) => ControlUnit_0_rd_sel(3),
      rd_sel(2) => ControlUnit_0_rd_sel(2),
      rd_sel(3) => ControlUnit_0_rd_sel(1),
      rd_sel(4) => ControlUnit_0_rd_sel(0),
      rs_out(0 to 63) => CoreRegisters_0_rs_out(0 to 63),
      rs_sel(0) => ControlUnit_0_rs_sel(4),
      rs_sel(1) => ControlUnit_0_rs_sel(3),
      rs_sel(2) => ControlUnit_0_rs_sel(2),
      rs_sel(3) => ControlUnit_0_rs_sel(1),
      rs_sel(4) => ControlUnit_0_rs_sel(0),
      rt_out(0 to 63) => CoreRegisters_0_rt_out(0 to 63),
      rt_sel(0) => ControlUnit_0_rt_sel(4),
      rt_sel(1) => ControlUnit_0_rt_sel(3),
      rt_sel(2) => ControlUnit_0_rt_sel(2),
      rt_sel(3) => ControlUnit_0_rt_sel(1),
      rt_sel(4) => ControlUnit_0_rt_sel(0),
      upper_imm(63 downto 0) => ControlUnit_0_U_imm(63 downto 0)
    );
MainMemory_wrapper_0: component platform_MainMemory_wrapper_0_0
     port map (
      LS_addr(63) => CoreRegisters_0_rs_out(0),
      LS_addr(62) => CoreRegisters_0_rs_out(1),
      LS_addr(61) => CoreRegisters_0_rs_out(2),
      LS_addr(60) => CoreRegisters_0_rs_out(3),
      LS_addr(59) => CoreRegisters_0_rs_out(4),
      LS_addr(58) => CoreRegisters_0_rs_out(5),
      LS_addr(57) => CoreRegisters_0_rs_out(6),
      LS_addr(56) => CoreRegisters_0_rs_out(7),
      LS_addr(55) => CoreRegisters_0_rs_out(8),
      LS_addr(54) => CoreRegisters_0_rs_out(9),
      LS_addr(53) => CoreRegisters_0_rs_out(10),
      LS_addr(52) => CoreRegisters_0_rs_out(11),
      LS_addr(51) => CoreRegisters_0_rs_out(12),
      LS_addr(50) => CoreRegisters_0_rs_out(13),
      LS_addr(49) => CoreRegisters_0_rs_out(14),
      LS_addr(48) => CoreRegisters_0_rs_out(15),
      LS_addr(47) => CoreRegisters_0_rs_out(16),
      LS_addr(46) => CoreRegisters_0_rs_out(17),
      LS_addr(45) => CoreRegisters_0_rs_out(18),
      LS_addr(44) => CoreRegisters_0_rs_out(19),
      LS_addr(43) => CoreRegisters_0_rs_out(20),
      LS_addr(42) => CoreRegisters_0_rs_out(21),
      LS_addr(41) => CoreRegisters_0_rs_out(22),
      LS_addr(40) => CoreRegisters_0_rs_out(23),
      LS_addr(39) => CoreRegisters_0_rs_out(24),
      LS_addr(38) => CoreRegisters_0_rs_out(25),
      LS_addr(37) => CoreRegisters_0_rs_out(26),
      LS_addr(36) => CoreRegisters_0_rs_out(27),
      LS_addr(35) => CoreRegisters_0_rs_out(28),
      LS_addr(34) => CoreRegisters_0_rs_out(29),
      LS_addr(33) => CoreRegisters_0_rs_out(30),
      LS_addr(32) => CoreRegisters_0_rs_out(31),
      LS_addr(31) => CoreRegisters_0_rs_out(32),
      LS_addr(30) => CoreRegisters_0_rs_out(33),
      LS_addr(29) => CoreRegisters_0_rs_out(34),
      LS_addr(28) => CoreRegisters_0_rs_out(35),
      LS_addr(27) => CoreRegisters_0_rs_out(36),
      LS_addr(26) => CoreRegisters_0_rs_out(37),
      LS_addr(25) => CoreRegisters_0_rs_out(38),
      LS_addr(24) => CoreRegisters_0_rs_out(39),
      LS_addr(23) => CoreRegisters_0_rs_out(40),
      LS_addr(22) => CoreRegisters_0_rs_out(41),
      LS_addr(21) => CoreRegisters_0_rs_out(42),
      LS_addr(20) => CoreRegisters_0_rs_out(43),
      LS_addr(19) => CoreRegisters_0_rs_out(44),
      LS_addr(18) => CoreRegisters_0_rs_out(45),
      LS_addr(17) => CoreRegisters_0_rs_out(46),
      LS_addr(16) => CoreRegisters_0_rs_out(47),
      LS_addr(15) => CoreRegisters_0_rs_out(48),
      LS_addr(14) => CoreRegisters_0_rs_out(49),
      LS_addr(13) => CoreRegisters_0_rs_out(50),
      LS_addr(12) => CoreRegisters_0_rs_out(51),
      LS_addr(11) => CoreRegisters_0_rs_out(52),
      LS_addr(10) => CoreRegisters_0_rs_out(53),
      LS_addr(9) => CoreRegisters_0_rs_out(54),
      LS_addr(8) => CoreRegisters_0_rs_out(55),
      LS_addr(7) => CoreRegisters_0_rs_out(56),
      LS_addr(6) => CoreRegisters_0_rs_out(57),
      LS_addr(5) => CoreRegisters_0_rs_out(58),
      LS_addr(4) => CoreRegisters_0_rs_out(59),
      LS_addr(3) => CoreRegisters_0_rs_out(60),
      LS_addr(2) => CoreRegisters_0_rs_out(61),
      LS_addr(1) => CoreRegisters_0_rs_out(62),
      LS_addr(0) => CoreRegisters_0_rs_out(63),
      LS_offset(0) => ControlUnit_0_S_imm(11),
      LS_offset(1) => ControlUnit_0_S_imm(10),
      LS_offset(2) => ControlUnit_0_S_imm(9),
      LS_offset(3) => ControlUnit_0_S_imm(8),
      LS_offset(4) => ControlUnit_0_S_imm(7),
      LS_offset(5) => ControlUnit_0_S_imm(6),
      LS_offset(6) => ControlUnit_0_S_imm(5),
      LS_offset(7) => ControlUnit_0_S_imm(4),
      LS_offset(8) => ControlUnit_0_S_imm(3),
      LS_offset(9) => ControlUnit_0_S_imm(2),
      LS_offset(10) => ControlUnit_0_S_imm(1),
      LS_offset(11) => ControlUnit_0_S_imm(0),
      clk => clk_in_1,
      data_in(63) => CoreRegisters_0_rt_out(0),
      data_in(62) => CoreRegisters_0_rt_out(1),
      data_in(61) => CoreRegisters_0_rt_out(2),
      data_in(60) => CoreRegisters_0_rt_out(3),
      data_in(59) => CoreRegisters_0_rt_out(4),
      data_in(58) => CoreRegisters_0_rt_out(5),
      data_in(57) => CoreRegisters_0_rt_out(6),
      data_in(56) => CoreRegisters_0_rt_out(7),
      data_in(55) => CoreRegisters_0_rt_out(8),
      data_in(54) => CoreRegisters_0_rt_out(9),
      data_in(53) => CoreRegisters_0_rt_out(10),
      data_in(52) => CoreRegisters_0_rt_out(11),
      data_in(51) => CoreRegisters_0_rt_out(12),
      data_in(50) => CoreRegisters_0_rt_out(13),
      data_in(49) => CoreRegisters_0_rt_out(14),
      data_in(48) => CoreRegisters_0_rt_out(15),
      data_in(47) => CoreRegisters_0_rt_out(16),
      data_in(46) => CoreRegisters_0_rt_out(17),
      data_in(45) => CoreRegisters_0_rt_out(18),
      data_in(44) => CoreRegisters_0_rt_out(19),
      data_in(43) => CoreRegisters_0_rt_out(20),
      data_in(42) => CoreRegisters_0_rt_out(21),
      data_in(41) => CoreRegisters_0_rt_out(22),
      data_in(40) => CoreRegisters_0_rt_out(23),
      data_in(39) => CoreRegisters_0_rt_out(24),
      data_in(38) => CoreRegisters_0_rt_out(25),
      data_in(37) => CoreRegisters_0_rt_out(26),
      data_in(36) => CoreRegisters_0_rt_out(27),
      data_in(35) => CoreRegisters_0_rt_out(28),
      data_in(34) => CoreRegisters_0_rt_out(29),
      data_in(33) => CoreRegisters_0_rt_out(30),
      data_in(32) => CoreRegisters_0_rt_out(31),
      data_in(31) => CoreRegisters_0_rt_out(32),
      data_in(30) => CoreRegisters_0_rt_out(33),
      data_in(29) => CoreRegisters_0_rt_out(34),
      data_in(28) => CoreRegisters_0_rt_out(35),
      data_in(27) => CoreRegisters_0_rt_out(36),
      data_in(26) => CoreRegisters_0_rt_out(37),
      data_in(25) => CoreRegisters_0_rt_out(38),
      data_in(24) => CoreRegisters_0_rt_out(39),
      data_in(23) => CoreRegisters_0_rt_out(40),
      data_in(22) => CoreRegisters_0_rt_out(41),
      data_in(21) => CoreRegisters_0_rt_out(42),
      data_in(20) => CoreRegisters_0_rt_out(43),
      data_in(19) => CoreRegisters_0_rt_out(44),
      data_in(18) => CoreRegisters_0_rt_out(45),
      data_in(17) => CoreRegisters_0_rt_out(46),
      data_in(16) => CoreRegisters_0_rt_out(47),
      data_in(15) => CoreRegisters_0_rt_out(48),
      data_in(14) => CoreRegisters_0_rt_out(49),
      data_in(13) => CoreRegisters_0_rt_out(50),
      data_in(12) => CoreRegisters_0_rt_out(51),
      data_in(11) => CoreRegisters_0_rt_out(52),
      data_in(10) => CoreRegisters_0_rt_out(53),
      data_in(9) => CoreRegisters_0_rt_out(54),
      data_in(8) => CoreRegisters_0_rt_out(55),
      data_in(7) => CoreRegisters_0_rt_out(56),
      data_in(6) => CoreRegisters_0_rt_out(57),
      data_in(5) => CoreRegisters_0_rt_out(58),
      data_in(4) => CoreRegisters_0_rt_out(59),
      data_in(3) => CoreRegisters_0_rt_out(60),
      data_in(2) => CoreRegisters_0_rt_out(61),
      data_in(1) => CoreRegisters_0_rt_out(62),
      data_in(0) => CoreRegisters_0_rt_out(63),
      data_out(63 downto 0) => MainMemory_wrapper_0_data_out(63 downto 0),
      funct3(0) => ControlUnit_0_funct3(2),
      funct3(1) => ControlUnit_0_funct3(1),
      funct3(2) => ControlUnit_0_funct3(0),
      instr_addr(15) => ControlUnit_0_pc_out(0),
      instr_addr(14) => ControlUnit_0_pc_out(1),
      instr_addr(13) => ControlUnit_0_pc_out(2),
      instr_addr(12) => ControlUnit_0_pc_out(3),
      instr_addr(11) => ControlUnit_0_pc_out(4),
      instr_addr(10) => ControlUnit_0_pc_out(5),
      instr_addr(9) => ControlUnit_0_pc_out(6),
      instr_addr(8) => ControlUnit_0_pc_out(7),
      instr_addr(7) => ControlUnit_0_pc_out(8),
      instr_addr(6) => ControlUnit_0_pc_out(9),
      instr_addr(5) => ControlUnit_0_pc_out(10),
      instr_addr(4) => ControlUnit_0_pc_out(11),
      instr_addr(3) => ControlUnit_0_pc_out(12),
      instr_addr(2) => ControlUnit_0_pc_out(13),
      instr_addr(1) => ControlUnit_0_pc_out(14),
      instr_addr(0) => ControlUnit_0_pc_out(15),
      instr_out(63 downto 0) => MainMemory_wrapper_0_instr_out(63 downto 0),
      opcode(0) => ControlUnit_0_opcode(6),
      opcode(1) => ControlUnit_0_opcode(5),
      opcode(2) => ControlUnit_0_opcode(4),
      opcode(3) => ControlUnit_0_opcode(3),
      opcode(4) => ControlUnit_0_opcode(2),
      opcode(5) => ControlUnit_0_opcode(1),
      opcode(6) => ControlUnit_0_opcode(0)
    );
end STRUCTURE;
