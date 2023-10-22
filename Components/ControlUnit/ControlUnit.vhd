library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library xil_defaultlib;
use xil_defaultlib.ISAListings.all;

entity ControlUnit is
port (clk : in std_logic;
    instruction : in signed(63 downto 0);
    eq, lt, ltu : in std_logic;
    pc_out : out unsigned(0 to 15);
    -- decoded instruction signals (operands + control bits)
    opcode : out std_logic_vector(6 downto 0);
    rd_sel : out std_logic_vector(4 downto 0);
    rs_sel : out std_logic_vector(4 downto 0);
    rt_sel : out std_logic_vector(4 downto 0);
    funct3 : out std_logic_vector(2 downto 0);
    funct7 : out std_logic_vector(6 downto 0);
    -- decoded instruction signals (immediates + offsets)
    I_imm : out signed(11 downto 0);
    U_imm : out signed(63 downto 0);
    LS_offset : out signed(11 downto 0);
    -- additional signals
    ja : in signed(0 to 63); -- value to be loaded from core register specified by rs_sel (to be used by jalr instruction)
    ra : out signed(0 to 63)); -- value to be stored in core register specified by rd_sel (used by jump instructions)
end entity;

architecture ControlUnitLogic of ControlUnit is
    -- core signals
    signal program_counter : unsigned(0 to 15) := (others => '1');
    signal instruction_register : signed(31 downto 0);
    -- additional signals
    signal auipc_signal : signed(0 to 31);
    signal jalr_signal : unsigned(0 to 63);
    -- intermediate signals
    signal funct3_internal : std_logic_vector(2 downto 0);
    signal opcode_internal : std_logic_vector(6 downto 0);
    signal I_imm_internal : signed(11 downto 0);
    signal U_imm_internal : signed(63 downto 0);
    -- branch and jump offset signals
    signal B_offset : signed(12 downto 0);
    signal J_offset : signed(20 downto 0);
    -- load and store offset signal
    signal S_offset : signed(11 downto 0);
begin
    pc_out <= program_counter;
    -- decoded instruction signals
    opcode_internal <= std_logic_vector(instruction_register(6 downto 0));
    opcode <= opcode_internal;
    rd_sel <= std_logic_vector(instruction_register(11 downto 7));
    rs_sel <= std_logic_vector(instruction_register(19 downto 15));
    rt_sel <= std_logic_vector(instruction_register(24 downto 20));
    funct3_internal <= std_logic_vector(instruction_register(14 downto 12));
    funct3 <= funct3_internal;
    funct7 <= std_logic_vector(instruction_register(31 downto 25));
    I_imm_internal <= instruction_register(31 downto 20);
    I_imm <= I_imm_internal;
    S_offset <= instruction_register(31 downto 25) & instruction_register(11 downto 7);
    B_offset <= instruction_register(31) & instruction_register(7) & instruction_register(30 downto 25) & instruction_register(11 downto 8) & '0';
    U_imm_internal <= resize(instruction_register(31 downto 12) & "000000000000", 64);
    U_imm <= U_imm_internal;
    J_offset  <= instruction_register(31) & instruction_register(19 downto 12) & instruction_register(20) & instruction_register(30 downto 21) & '0';
    -- additional signals
    jalr_signal <= unsigned(ja + resize(I_imm_internal, 64));
    process (clk, program_counter, jalr_signal)
    begin
        if rising_edge(clk) then
            instruction_register <= instruction(31 downto 0);
            if opcode_internal = BRANCH then
                if (funct3_internal = B_BEQ and eq = '1') or
                (funct3_internal = B_BNE and eq = '0') or
                (funct3_internal = B_BLT and lt = '1') or
                (funct3_internal = B_BGE and lt = '0') or
                (funct3_internal = B_BLTU and ltu = '1') or
                (funct3_internal = B_BGEU and ltu = '0') then
                    program_counter <= program_counter + unsigned(resize(B_offset, 16));
                else
                    program_counter <= program_counter + 4;
                end if;
            elsif opcode_internal = JAL then
                ra <= resize(signed(program_counter + 1), 64);
                program_counter <= program_counter + unsigned(U_imm_internal(15 downto 0));
            elsif opcode_internal = JALR then
                ra <= resize(signed(program_counter + 1), 64);
                program_counter <= jalr_signal(48 to 63);
            elsif opcode_internal = AUIPC then
                program_counter <= program_counter + unsigned(U_imm_internal(15 downto 0));
            elsif (opcode_internal = LOAD) then
                LS_offset <= I_imm_internal;
            elsif (opcode_internal = STORE) then
                LS_offset <= S_offset;
            else
                program_counter <= program_counter + 1;
            end if;
        end if;
    end process;
end architecture;
