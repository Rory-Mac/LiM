library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
library xil_defaultlib;
use xil_defaultlib.ISAListings.all;
entity MainMemory_wrapper is
    port (
        clk : in std_logic;
        opcode : in std_logic_vector(0 to 6);
        funct3 : in std_logic_vector(0 to 2);
        LS_offset : in signed(0 to 11);
        LS_addr : in std_logic_vector(63 downto 0);
        instr_addr : in std_logic_vector(15 downto 0);
        data_in: in std_logic_vector(63 downto 0);
        data_out : out signed(63 downto 0);
        instr_out : out std_logic_vector(63 downto 0)
    );
end MainMemory_wrapper;

architecture STRUCTURE of MainMemory_wrapper is
    component MainMemory is
    port (
        clk : in STD_LOGIC;
        w_data, w_instr : in STD_LOGIC;
        data_out, instr_out : out STD_LOGIC_VECTOR ( 63 downto 0 );
        data_in, instr_in : in STD_LOGIC_VECTOR ( 63 downto 0 );
        data_addr : in std_logic_vector(15 downto 0);
        instr_addr : in STD_LOGIC_VECTOR ( 15 downto 0 )
    );
    end component MainMemory;
    signal w_data, w_instr : std_logic;
    signal offset_address : std_logic_vector(0 to 15);
    signal loaded_value : std_logic_vector(63 downto 0);
    signal stored_value : signed(63 downto 0);
    signal load_byte_signal, load_halfword_signal, load_word_signal, load_double_signal : signed(0 to 63);
    signal load_byte_signal_u, load_halfword_signal_u, load_word_signal_u : unsigned(0 to 63);
    signal store_byte_signal, store_halfword_signal, store_word_signal, store_double_signal : signed(0 to 63);
begin
    offset_address <= std_logic_vector(unsigned(LS_addr) + unsigned(resize(LS_offset, 16)));
    MainMemory_instance: component MainMemory
    port map (
        clk => clk,
        data_addr(15 downto 0) => offset_address,
        data_in(63 downto 0) => std_logic_vector(stored_value(63 downto 0)),
        data_out(63 downto 0) => loaded_value,
        instr_addr(15 downto 0) => instr_addr(15 downto 0),
        instr_in(63 downto 0) => (others => '0'), -- unused
        instr_out(63 downto 0) => instr_out(63 downto 0),
        w_data => w_data,
        w_instr => '0' -- unused
    );
    -- initialise load and store signals
    load_byte_signal <= resize(signed(loaded_value(7 downto 0)), 64);
    load_byte_signal_u <= resize(unsigned(loaded_value(7 downto 0)), 64);
    store_byte_signal <= resize(signed(data_in(7 downto 0)), 64);
    load_halfword_signal <= resize(signed(loaded_value(15 downto 0)), 64);
    load_halfword_signal_u <= resize(unsigned(loaded_value(15 downto 0)), 64);
    store_halfword_signal <= resize(signed(data_in(15 downto 0)), 64);
    load_word_signal <= resize(signed(loaded_value(31 downto 0)), 64);
    load_word_signal_u <= resize(unsigned(loaded_value(31 downto 0)), 64);
    store_word_signal <= resize(signed(data_in(31 downto 0)), 64);
    load_double_signal <= signed(loaded_value);
    store_double_signal <= signed(data_in);
    -- route load and store signals
    process (loaded_value, load_byte_signal, load_halfword_signal, load_word_signal, load_double_signal,
        load_byte_signal_u, load_halfword_signal_u, load_word_signal_u, store_byte_signal, 
        store_halfword_signal, store_word_signal, store_double_signal)
    begin
        if opcode = LOAD then
            w_data <= '0';
            case funct3 is 
                when I_LB => data_out <= load_byte_signal;
                when I_LBU => data_out <= signed(load_byte_signal_u);
                when I_LH => data_out <= load_halfword_signal;
                when I_LHU => data_out <= signed(load_halfword_signal_u);
                when I_LW => data_out <= load_word_signal;
                when I_LWU => data_out <= signed(load_word_signal_u);
                when I_LD => data_out <= load_double_signal;
                when others => null;
            end case;
        elsif opcode = STORE then
            w_data <= '1';
            data_out <= signed(loaded_value);
            case funct3 is 
                when S_SB => stored_value <= store_byte_signal;
                when S_SH => stored_value <= store_halfword_signal;
                when S_SW => stored_value <= store_word_signal;
                when S_SD => stored_value <= store_double_signal;
                when others => null;
            end case;
        else 
            w_data <= '0';
        end if;
    end process;
end STRUCTURE;
