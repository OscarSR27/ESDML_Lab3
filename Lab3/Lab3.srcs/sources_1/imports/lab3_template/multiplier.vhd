----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/10/2023 04:04:01 PM
-- Design Name:
-- Module Name: multiplier - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_BIT.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder is 
    Port ( 
        A, B: in bit_vector(7 downto 0);
        Y   : out bit_vector(7 downto 0);
        CO  : out bit);
end adder;

architecture dataflow of adder is
    signal a_and_b, a_xor_b, abc, c: bit_vector(7 downto 0);
begin
    g1: for i in 0 to 7 generate
        a_and_b(i) <= a(i) AND b(i);
        a_xor_b(i) <= a(i) XOR b(i);

        g2: if i = 0 generate
            -- half adder
            y(i) <= a_xor_b(i);
            c(i) <= a_and_b(i);
        end generate g2;

        g3: if i /= 0 generate
            -- full adder
            abc(i) <= c(i-1) AND a_xor_b(i);
            y(i) <= c(i-1) XOR a_xor_b(i);
            c(i) <= a_and_b(i) OR abc(i);
        end generate g3;
    end generate g1;

    CO <= c(7);
end dataflow;

entity multiplier is
    Port ( A : in BIT_VECTOR (7 downto 0);
           B : in BIT_VECTOR (7 downto 0);
           S : in BIT;
           V : in BIT;
           Y : out BIT_VECTOR (15 downto 0));
end multiplier;

architecture dataflow of multiplier is

-- SIGNALS
--- ENTER STUDENT CODE BELOW ---
    signal Y_COPY,Y_NEG: BIT_VECTOR(15 downto 0);
    signal A_COPY, B_COPY, A_NEG, B_NEG, A_ABS, B_ABS, Y_ABS_MSB, Y_ABS_LSB, Y_CARRY_TERM, A1, B1, A2, B2, A3, B3, A4, B4, A5, B5, A6, B6, A7, B7: BIT_VECTOR(7 downto 0);
    signal S1, S2, S3, S4, S5, S6, S7: BIT_VECTOR(7 downto 0);
    signal C1, C2, C3, C4, C5, C6, C7, C_DUMMY1, C_DUMMY2, C_DUMMY3, C_Y: BIT;
    signal A_IS_ZERO, B_IS_ZERO, A_IS_MAX, B_IS_MAX, A_IS_NEGATIVE, B_IS_NEGATIVE, SCALAR_SIGN: BIT;
--- ENTER STUDENT CODE ABOVE ---

begin

--- ENTER STUDENT CODE BELOW ---
    A_IS_NEGATIVE <= A(7);
    B_IS_NEGATIVE <= B(7);
    A_IS_ZERO <= '1' when A = "00000000" else '0';
    B_IS_ZERO <= '1' when B = "00000000" else '0';
    A_IS_MAX <= '1' when A = "10000000" else '0';
    B_IS_MAX <= '1' when B = "10000000" else '0';
    SCALAR_SIGN <= A(7) XOR B(7);
    
    A_NEG <= '0' & not A(6 downto 0) when A_IS_NEGATIVE = '1' AND S = '1' else "00000000";
    B_NEG <= '0' & not B(6 downto 0) when B_IS_NEGATIVE = '1' AND S = '1' else "00000000";
    
    ABS1: entity work.adder(dataflow) port map (A_NEG, "00000001", A_ABS, C_DUMMY1);
    A_COPY <= A_ABS when A_IS_NEGATIVE = '1' AND S = '1' AND A_IS_MAX = '0' else A;
    
    ABS2: entity work.adder(dataflow) port map (B_NEG, "00000001", B_ABS, C_DUMMY2);
    B_COPY <= B_ABS when B_IS_NEGATIVE = '1' AND S = '1' AND B_IS_MAX = '0' else B;

    Y_COPY(0) <= A_COPY(0) AND B_COPY(0);

    A1 <= '0' & A_COPY(7 downto 1) when B_COPY(0) = '1' else "00000000";
    B1 <= A_COPY when B_COPY(1) = '1' else "00000000";
    X1: entity work.adder(dataflow) port map (A1, B1, S1, C1);
    Y_COPY(1) <= S1(0);
    
    A2 <= C1 & S1(7 downto 1);
    B2 <= A_COPY when B_COPY(2) = '1' else "00000000";
    X2: entity work.adder(dataflow) port map (A2, B2, S2, C2);
    Y_COPY(2) <= S2(0);
    
    A3 <= C2 & S2(7 downto 1);
    B3 <= A_COPY when B_COPY(3) = '1' else "00000000";
    X3: entity work.adder(dataflow) port map (A3, B3, S3, C3);
    Y_COPY(3) <= S3(0);
    
    A4 <= C3 & S3(7 downto 1);
    B4 <= A_COPY when B_COPY(4) = '1' else "00000000";
    X4: entity work.adder(dataflow) port map (A4, B4, S4, C4);
    Y_COPY(4) <= S4(0);
    
    A5 <= C4 & S4(7 downto 1);
    B5 <= A_COPY when B_COPY(5) = '1' else "00000000";
    X5: entity work.adder(dataflow) port map (A5, B5, S5, C5);
    Y_COPY(5) <= S5(0);
    
    A6 <= C5 & S5(7 downto 1);
    B6 <= A_COPY when B_COPY(6) = '1' else "00000000";
    X6: entity work.adder(dataflow) port map (A6, B6, S6, C6);
    Y_COPY(6) <= S6(0);
    
    A7 <= C6 & S6(7 downto 1);
    B7 <= A_COPY when B_COPY(7) = '1' else "00000000";
    X7: entity work.adder(dataflow) port map (A7, B7, S7, C7);
    Y_COPY(14 downto 7) <= S7;
    Y_COPY(15) <= SCALAR_SIGN when S = '1' AND A_IS_ZERO = '0' AND B_IS_ZERO = '0' else C7;
    
    Y_NEG <= not('0' & Y_COPY(14 downto 0)) when S = '1' else "0000000000000000";
    
    ABS3: entity work.adder(dataflow) port map (Y_NEG(7 downto 0), "00000001", Y_ABS_LSB, C_Y);
    Y_CARRY_TERM <= "0000000" & C_Y;
    ABS4: entity work.adder(dataflow) port map (Y_NEG(15 downto 8), Y_CARRY_TERM, Y_ABS_MSB, C_DUMMY3);
    Y <= Y_COPY(15) & Y_ABS_MSB(6 downto 0) & Y_ABS_LSB when S = '1' AND SCALAR_SIGN = '1' AND A_IS_ZERO = '0' AND B_IS_ZERO = '0' else Y_COPY;

--- ENTER STUDENT CODE ABOVE ---

end dataflow;



---- Behavioral architecture of the array multiplier, can be used as reference during verification --
--architecture behavioral of multiplier is

--begin

--Y <= BIT_VECTOR( unsigned(A) * unsigned(B) )
--        when s ='0' AND v = '0' else
--     BIT_VECTOR( signed(A) * signed(B) )
--        when s ='1' AND v = '0' else
--     BIT_VECTOR( unsigned(A(7 downto 4)) * unsigned(B(7 downto 4)) ) &
--     BIT_VECTOR( unsigned(A(3 downto 0)) * unsigned(B(3 downto 0)) )
--        when s ='0' AND v = '1' else
--     BIT_VECTOR( signed(A(7 downto 4)) * signed(B(7 downto 4)) ) &
--     BIT_VECTOR( signed(A(3 downto 0)) * signed(B(3 downto 0)) );

--end behavioral;
