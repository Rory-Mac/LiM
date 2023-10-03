library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BRAMTB is
end BRAMTB;

architecture BRAMTBLogic of BRAMTB is
    constant CLOCK_PERIOD : time := 2 ns;
    constant SIMULATION_LENGTH : time := 1000 ns;
    signal clk, w_data, w_instr : std_logic;
    signal data_addr, instr_addr : std_logic_vector(15 downto 0);
    signal data_in, data_out, instr_in, instr_out : std_logic_vector(63 downto 0); 
begin
    BRAMinstance : entity work.BRAM_Access_wrapper port map (
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

    ClockProcess : process
    begin
        while now < SIMULATION_LENGTH loop
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    BRAMTestBench : process
    begin
        -- test write data to and read data from registers
        w_data <= '1';
        w_instr <= '0';
        data_addr <= "0000000000000000";
        data_in <= "0101010101010101010101010101010101010101010101010101010101010101";
        wait for CLOCK_PERIOD;
        assert data_out = "0101010101010101010101010101010101010101010101010101010101010101" report "testbench failed for BRAM case 1" severity error;
        data_addr <= "0000000000000001";
        data_in <= "0011001100110011001100110011001100110011001100110011001100110011";
        wait for CLOCK_PERIOD;
        assert data_out = "0011001100110011001100110011001100110011001100110011001100110011" report "testbench failed for BRAM case 2" severity error;
        data_addr <= "1111111111111110";
        data_in <= "0000111100001111000011110000111100001111000011110000111100001111";
        wait for CLOCK_PERIOD;
        assert data_out = "0000111100001111000011110000111100001111000011110000111100001111" report "testbench failed for BRAM case 3" severity error;
        data_addr <= "1111111111111111";
        data_in <= "0000000011111111000000001111111100000000111111110000000011111111";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000011111111000000001111111100000000111111110000000011111111" report "testbench failed for BRAM case 4" severity error;
        -- test that state is preserved across clock cycles
        w_data <= '0';
        data_in <= "0000000000000000000000000000000000000000000000000000000000000000";
        data_addr <= "1111111111111111";
        wait for 10 * CLOCK_PERIOD;
        assert data_out = "0000000011111111000000001111111100000000111111110000000011111111" report "testbench failed for BRAM case 5" severity error;
        data_addr <= "1111111111111110";
        wait for CLOCK_PERIOD;
        assert data_out = "0000111100001111000011110000111100001111000011110000111100001111" report "testbench failed for BRAM case 6" severity error;
        data_addr <= "0000000000000001";
        wait for CLOCK_PERIOD;
        assert data_out = "0011001100110011001100110011001100110011001100110011001100110011" report "testbench failed for BRAM case 7" severity error;
        data_addr <= "0000000000000000";
        wait for CLOCK_PERIOD;
        assert data_out = "0101010101010101010101010101010101010101010101010101010101010101" report "testbench failed for BRAM case 8" severity error;
        -- test write instructions to and read instructions from registers
        w_data <= '1';
        data_addr <= "0000000000000101";
        data_in <= "0101010101010101010101010101010101010101010101010101010101010101";
        wait for CLOCK_PERIOD;
        w_data <= '0';
        instr_addr <= "0000000000000101";
        wait for CLOCK_PERIOD;
        assert instr_out = "0101010101010101010101010101010101010101010101010101010101010101" report "testbench failed for BRAM case 9" severity error;
        w_data <= '1';
        data_addr <= "0000000000000110";
        data_in <= "0011001100110011001100110011001100110011001100110011001100110011";
        wait for CLOCK_PERIOD;
        w_data <= '0';
        instr_addr <= "0000000000000110";
        wait for CLOCK_PERIOD;
        assert instr_out = "0011001100110011001100110011001100110011001100110011001100110011" report "testbench failed for BRAM case 10" severity error;
        w_data <= '1';
        data_addr <= "0000000000000111";
        data_in <= "0000111100001111000011110000111100001111000011110000111100001111";
        wait for CLOCK_PERIOD;
        w_data <= '0';
        instr_addr <= "0000000000000111";
        wait for CLOCK_PERIOD;
        assert instr_out = "0000111100001111000011110000111100001111000011110000111100001111" report "testbench failed for BRAM case 11" severity error;
        w_data <= '1';
        data_addr <= "0000000000001000";
        data_in <= "0000000011111111000000001111111100000000111111110000000011111111";
        wait for CLOCK_PERIOD;
        w_data <= '0';
        instr_addr <= "0000000000001000";
        wait for CLOCK_PERIOD;
        assert instr_out = "0000000011111111000000001111111100000000111111110000000011111111" report "testbench failed for BRAM case 12" severity error;
        -- test write enable
        w_data <= '1';
        data_addr <= "1010101010101010";
        data_in <= "1111111111111111111111111111111111111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111111111111111111111111111111111111" report "testbench failed for BRAM case 13" severity error;
        w_data <= '0';
        data_addr <= "1010101010101010";
        data_in <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert data_out = "1111111111111111111111111111111111111111111111111111111111111111" report "testbench failed for BRAM case 14" severity error;
        w_data <= '1';
        data_addr <= "1010101010101010";
        data_in <= "0000000000000000000000000000000000000000000000000000000000000000";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for BRAM case 15" severity error;
        w_data <= '0';
        -- test address separation
        data_addr <= "1010101010101010";
        instr_addr <= "0000000000000000";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for BRAM case 16" severity error;
        assert instr_out = "0101010101010101010101010101010101010101010101010101010101010101" report "testbench failed for BRAM case 17" severity error;
        instr_addr <= "0000000000000001";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for BRAM case 18" severity error;
        assert instr_out = "0011001100110011001100110011001100110011001100110011001100110011" report "testbench failed for BRAM case 19" severity error;
        instr_addr <= "1111111111111110";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for BRAM case 20" severity error;
        assert instr_out = "0000111100001111000011110000111100001111000011110000111100001111" report "testbench failed for BRAM case 21" severity error;
        instr_addr <= "1111111111111111";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000000000000000000000000000000000000" report "testbench failed for BRAM case 22" severity error;
        assert instr_out = "0000000011111111000000001111111100000000111111110000000011111111" report "testbench failed for BRAM case 23" severity error;
        -- test simultaneous reads
        w_data <= '1';
        data_addr <= "1011110101010111";
        data_in <= "0000000000000000000000000000000011111111111111111111111111111111";
        wait for CLOCK_PERIOD;
        data_addr <= "1011110101011000";
        data_in <= "1111110000111111111111000011111111111100001111111111110000111111";
        wait for CLOCK_PERIOD;
        w_data <= '0';
        data_addr <= "1011110101010111";
        instr_addr <= "1011110101011000";
        wait for CLOCK_PERIOD;
        assert data_out = "0000000000000000000000000000000011111111111111111111111111111111" report "testbench failed for BRAM case 24" severity error;
        assert instr_out = "1111110000111111111111000011111111111100001111111111110000111111" report "testbench failed for BRAM case 25" severity error;
        wait;
    end process;
end BRAMTBLogic;