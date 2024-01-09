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
    --- Perform bit by bit addition
    g1: for i in 0 to 7 generate
        a_and_b(i) <= a(i) AND b(i); --- Compute carry from the two inputs bits
        a_xor_b(i) <= a(i) XOR b(i); --- Compute addition between input A(i) and B(i)

        g2: if i = 0 generate  --- The LSB bit can use a half adder (no extra gates are needed to compute the carry or the addition)
                               --- since there are no previous additions that could affect the result.

            --- half adder
            y(i) <= a_xor_b(i);
            c(i) <= a_and_b(i);
        end generate g2;

        g3: if i /= 0 generate
            --- full adder
            --- The remaining bits require a full adder for two reasons:
            ---     1. The output carry needs to consider all other forms in which it can be produced, i.e., due to A(i) + B(i) or (A(i) + B(i)) + Input carry(i).
            ---     2. The final addition between bits needs to consider the input carry, so an extra XOR operation is needed between A(i) + B(i) and the input carry.

            abc(i) <= c(i-1) AND a_xor_b(i);
            y(i) <= c(i-1) XOR a_xor_b(i);
            c(i) <= a_and_b(i) OR abc(i);
        end generate g3;
    end generate g1;

    CO <= c(7); --- Assign final carry to C0
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
    signal Y_COPY,Y_NEG, Y_VECTOR: BIT_VECTOR(15 downto 0);
    signal A_COPY, B_COPY, A_NEG, B_NEG, A_ABS, B_ABS, Y_ABS_MSB, Y_ABS_LSB, Y_CARRY_TERM, A1, B1, A2, B2, A3, B3, A4, B4, A5, B5, A6, B6, A7, B7: BIT_VECTOR(7 downto 0);
    signal S1, S2, S3, S4, S5, S6, S7: BIT_VECTOR(7 downto 0);
    signal C1, C2, C3, C4, C5, C6, C7, C_DUMMY1, C_DUMMY2, C_DUMMY3, C_Y: BIT;
    signal A_IS_ZERO, B_IS_ZERO, A_IS_MAX, B_IS_MAX, A_IS_NEGATIVE, B_IS_NEGATIVE, SCALAR_SIGN: BIT;
--- ENTER STUDENT CODE ABOVE ---

begin

--- ENTER STUDENT CODE BELOW ---

--- Flags:
---     perform signed multiplication with 8 bit 
---     numbers and corner conditions (0 and abs(128))
    A_IS_NEGATIVE <= A(7);
    B_IS_NEGATIVE <= B(7);
    A_IS_ZERO <= '1' when A = "00000000" else '0';
    B_IS_ZERO <= '1' when B = "00000000" else '0';
    A_IS_MAX <= '1' when A = "10000000" else '0';
    B_IS_MAX <= '1' when B = "10000000" else '0';
--- Determine the sign of the result in the case of signed 8-bit multiplication.
    SCALAR_SIGN <= A(7) XOR B(7);
    
-- If we perform signed multiplication (S = '1'), we extract the absolute value, perform the multiplication, and
-- then add the sign using 2's complement: A(7) XOR B(7) Two_Complement(|A|x|B|), where the sign is computed with A(7) XOR B(7).

-- For signed multiplication between two 8-bit numbers, the first step is to find the absolute value of each input. 
-- To do that, we need to consider two cases:
--     1. If the input number is positive, zero, 128, or -128 (remember in bit representation, 128 = -128), then we use it as it is.
--     2. If the input number is negative (except for ±128), then we use 2's complement. To compute 2's complement, we follow this approach:
--         A. Invert all bits (except for the sign bit) using a NOT gate. Since a signed 8-bit number uses the MSB as the sign bit, the value is
--            stored in the remaining 7 bits. So, we need to concatenate a 0 for the MSB to have the correct absolute value representation.
--         B. Add 1 to the inverted result.

    A_NEG <= '0' & not A(6 downto 0) when S = '1' AND A_IS_NEGATIVE = '1' else "00000000";
    ABS1: entity work.adder(dataflow) port map (A_NEG, "00000001", A_ABS, C_DUMMY1);
    A_COPY <= A_ABS when S = '1' AND A_IS_NEGATIVE = '1' AND A_IS_MAX = '0' else A; -- Here we evalute case 1 vs case 2
    
    B_NEG <= '0' & not B(6 downto 0) when S = '1' AND B_IS_NEGATIVE = '1' else "00000000";
    ABS2: entity work.adder(dataflow) port map (B_NEG, "00000001", B_ABS, C_DUMMY2);
    B_COPY <= B_ABS when S = '1' AND B_IS_NEGATIVE = '1' AND B_IS_MAX = '0' else B; -- Here we evalute case 1 vs case 2

--- Here we perform unsigned multiplication (S = '0') or signed multiplication (S = '1') with the absolute value version of input numbers 
--- that actually follow the same process as the unsigned case. The process is as follows:
---     1. Compute partial products with an AND gate between each bit from the B input and each bit from the A input.
---     2. Perform the addition of each partial product, taking into account the 1-position shift to the left at each partial addition.
---  Important note: Propagate the carry after each addition, except for the first addition, since the carry is 0 (no previous additions).

    Y_COPY(0) <= A_COPY(0) AND B_COPY(0);
    Y_VECTOR(0) <= A_COPY(0) AND B_COPY(0);

    A1 <= '0' & A_COPY(7 downto 1) when B_COPY(0) = '1' AND V = '0' else "00000" & A_COPY(3 downto 1) when B_COPY(0) = '1' AND V = '1' else "00000000";
    B1 <= A_COPY when B_COPY(1) = '1' AND V = '0' else "0000" & A_COPY(3 downto 0) when B_COPY(1) = '1' AND V = '1' else "00000000";
    X1: entity work.adder(dataflow) port map (A1, B1, S1, C1);
    Y_COPY(1) <= S1(0);
    Y_VECTOR(1) <= S1(0);
    
    A2 <= C1 & S1(7 downto 1);
    B2 <= A_COPY when B_COPY(2) = '1' AND V = '0' else "0000" & A_COPY(3 downto 0) when B_COPY(2) = '1' AND V = '1' else "00000000";
    X2: entity work.adder(dataflow) port map (A2, B2, S2, C2);
    Y_COPY(2) <= S2(0);
    Y_VECTOR(2) <= S2(0);
    
    A3 <= C2 & S2(7 downto 1);
    B3 <= A_COPY when B_COPY(3) = '1' AND V = '0' else "0000" & A_COPY(3 downto 0) when B_COPY(3) = '1' AND V = '1' else "00000000";
    X3: entity work.adder(dataflow) port map (A3, B3, S3, C3);
    Y_COPY(3) <= S3(0);
    Y_VECTOR(6 downto 3) <= S3(3 downto 0);
    Y_VECTOR(7) <= C3;
    
    A4 <= C3 & S3(7 downto 1);
    B4 <= A_COPY when B_COPY(4) = '1' else "00000000";
    X4: entity work.adder(dataflow) port map (A4, B4, S4, C4);
    Y_COPY(4) <= S4(0);
    Y_VECTOR(8) <= A_COPY(4) AND B_COPY(4);
    
    A5 <= C4 & S4(7 downto 1) when V = '0' else "00000" & A_COPY(7 downto 5) when B_COPY(4) = '1' AND V = '1' else "00000000";
    B5 <= A_COPY when B_COPY(5) = '1' AND V = '0' else "0000" & A_COPY(7 downto 4) when B_COPY(5) = '1' AND V = '1' else "00000000";
    X5: entity work.adder(dataflow) port map (A5, B5, S5, C5);
    Y_COPY(5) <= S5(0);
    Y_VECTOR(9) <= S5(0);
    
    A6 <= C5 & S5(7 downto 1);
    B6 <= A_COPY when B_COPY(6) = '1' AND V = '0' else "0000" & A_COPY(7 downto 4) when B_COPY(6) = '1' AND V = '1' else "00000000";
    X6: entity work.adder(dataflow) port map (A6, B6, S6, C6);
    Y_COPY(6) <= S6(0);
    Y_VECTOR(10) <= S6(0);
    
    A7 <= C6 & S6(7 downto 1);
    B7 <= A_COPY when B_COPY(7) = '1' AND V = '0' else "0000" & A_COPY(7 downto 4) when B_COPY(7) = '1' AND V = '1' else "00000000";
    X7: entity work.adder(dataflow) port map (A7, B7, S7, C7);
    Y_COPY(14 downto 7) <= S7;
    Y_VECTOR(14 downto 11) <= S7(3 downto 0);
    Y_VECTOR(15) <= C6;
    
--- Decide the value of the MSB bit of the result based on the following two cases:
---     1. Unsigned multiplication: Set MSB equal to the carry of the last addition (C7 for 8-bit inputs).
---     2. Signed multiplication: 
---         A. If A is not zero and B is not zero, then set MSB equal to A(7) XOR B(7) (Reasoning: if A = 0 and B = -1, then A(7) XOR B(7) = 1, 
---            which is incorrect; the sign should be 0 for a multiplication with 0).
---         B. If A = 0 or B = 0, set MSB equal to the carry of the last addition (Reasoning: We already manage multiplication with 0, and the carry will be
---            the same for either unsigned or signed multiplication).

    Y_COPY(15) <= SCALAR_SIGN when S = '1' AND A_IS_ZERO = '0' AND B_IS_ZERO = '0' else C7;
    
--- To set the final result, we need to decide between two cases:
---     1. Unsigned multiplication or signed multiplication when the result is positive or zero (we know the result is zero if any of the inputs is zero): Set Y equal to Y_COPY.
---     2. Signed multiplication: Set the MSB of Y equal to the MSB of Y_COPY and use 2's complement for the remaining bits. To compute 2's complement, we follow this approach:
---         A. Invert all bits (except for the sign bit) using a NOT gate. Since a signed 16-bit number uses the MSB as the sign bit, the value is
---            stored in the remaining 15 bits. So, we need to concatenate a 0 for the MSB and then invert the bits.
---         B. Add 1 to the inverted result: 
---            Since our adder only supports 8-bit inputs, we need to perform the whole addition in three steps:
---                 i. Add the first 8 LSB bits of the two inputs.
---                 ii. Manage the carry by concatenating it to the LSB of the upper part of the 1 representation.
---                 iii. Add the MSB of both quantities, taking into account the carry correction above.


    Y_NEG <= not('0' & Y_COPY(14 downto 0)) when S = '1' else "0000000000000000";
    
    ABS3: entity work.adder(dataflow) port map (Y_NEG(7 downto 0), "00000001", Y_ABS_LSB, C_Y);
    Y_CARRY_TERM <= "0000000" & C_Y;
    ABS4: entity work.adder(dataflow) port map (Y_NEG(15 downto 8), Y_CARRY_TERM, Y_ABS_MSB, C_DUMMY3);
    Y <= Y_COPY(15) & Y_ABS_MSB(6 downto 0) & Y_ABS_LSB when S = '1' AND SCALAR_SIGN = '1' AND A_IS_ZERO = '0' AND B_IS_ZERO = '0' else Y_COPY when V = '0' else Y_VECTOR;
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
