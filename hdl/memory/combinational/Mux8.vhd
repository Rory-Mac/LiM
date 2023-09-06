library ieee;
use ieee.std_logic_1164.all;

entity Mux8 is
port (A: in std_logic_vector (0 to 7);
    S1, S2, S3: in std_logic;
    X: out std_logic);
end Mux8;

architecture Mux8Logic of Mux8 is
    signal AndIn, AndS1, AndS2, AndS3, AndOut : std_logic_vector (0 to 7);
    signal OrIn : std_logic_vector (0 to 7);
    signal OrOut : std_logic;
begin
    generateUnary4Ands : for i in 0 to 7 generate
        Unary4AndInstance : entity work.Unary4And port map (A(0) => AndIn(i), A(1) => AndS1(i), A(2) => AndS2(i), A(3) => AndS3(i), B => AndOut(i));
    end generate generateUnary4Ands;

    AndIn <= A;
    process (S1, S2, S3)
    begin
        for i in 0 to 7 loop
            if (i / 4) mod 2 = 0 then
                AndS1(i) <= not S1;
            else
                AndS1(i) <= S1;
            end if;
            if (i / 2) mod 2 = 0 then
                AndS2(i) <= not S2;
            else
                AndS2(i) <= S2;
            end if;
            if i mod 2 = 0 then
                AndS3(i) <= not S3;
            else
                AndS3(i) <= S3;
            end if;
        end loop;
    end process;

    Unary8OrInstance : entity work.Unary8Or port map (A => OrIn, B => OrOut);
    OrIn <= AndOut;
    X <= OrOut;
    
end architecture;