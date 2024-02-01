----------------------------------------------------------------------------------
-- Company:
-- Engineer: Le, Thien N and Soto, Oscar
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

--- Add custom modules (adders,...) here
--- ENTER STUDENT CODE BELOW ---
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_BIT.ALL;
--- ENTER STUDENT CODE ABOVE ---

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
    signal TWO_COMPLEMENT_ADD_A, TWO_COMPLEMENT_ADD_B, A_COPY, B_COPY, A_NEG, B_NEG, A_ABS, B_ABS, Y_ABS_MSB, Y_ABS_LSB, Y_CARRY_TERM, A1, B1, A2, B2, A3, B3, A4, B4, A5, B5, A6, B6, A7, B7: BIT_VECTOR(7 downto 0);
    signal S1, S2, S3, S4, S5, S6, S7: BIT_VECTOR(7 downto 0);
    signal SCALAR_SIGN, C1, C2, C3, C4, C5, C6, C7, C_DUMMY1, C_DUMMY2, C_DUMMY3, C_Y: BIT;
    signal A_IS_ZERO, B_IS_ZERO, A_IS_MAX, B_IS_MAX, A_IS_NEGATIVE, B_IS_NEGATIVE, VECTOR_SIGN: BIT_VECTOR(1 downto 0);
--- ENTER STUDENT CODE ABOVE ---

begin

--- ENTER STUDENT CODE BELOW ---

--- Flags:
--- Set a flag when A or B inputs are negatives (both scalar and vector format)
    A_IS_NEGATIVE <= A(7) & '0' when V = '0' else
                     A(7) & A(3);
    B_IS_NEGATIVE <= B(7) & '0' when V = '0' else
                     B(7) & B(3);
--- Set a flag when A or B inputs are 0 (both scalar and vector format)
    A_IS_ZERO <= "11" when A = "00000000"  else 
                 "10" when V = '1' AND A(7 downto 4)  = "0000" AND A(3 downto 0) /= "0000" else
                 "01" when V = '1' AND A(7 downto 4) /= "0000" AND A(3 downto 0)  = "0000" else
                 "00";
    B_IS_ZERO <= "11" when B = "00000000"  else 
                 "10" when V = '1' AND B(7 downto 4)  = "0000" AND B(3 downto 0) /= "0000" else
                 "01" when V = '1' AND B(7 downto 4) /= "0000" AND B(3 downto 0)  = "0000" else
                 "00";
--- Set a flag when A or B inputs are intended to be signed numbers and have maximum value (8 for vectors and 128 for scalars)
    A_IS_MAX <= "11" when (V = '0' AND A = "10000000") OR (V = '1' AND A(7 downto 4) = "1000" AND A(3 downto 0) = "1000") else 
                "01" when  V = '1' AND A(7 downto 4) /= "1000" AND A(3 downto 0) = "1000" else
                "10" when  V = '1' AND A(7 downto 4) = "1000" AND A(3 downto 0) /= "1000" else
                "00";
    B_IS_MAX <= "11" when (V = '0' AND B = "10000000") OR (V = '1' AND B(7 downto 4) = "1000" AND B(3 downto 0) = "1000") else 
                "01" when  V = '1' AND B(7 downto 4) /= "1000" AND B(3 downto 0) = "1000" else
                "10" when  V = '1' AND B(7 downto 4) = "1000" AND B(3 downto 0) /= "1000" else
                "00";

--- Determine the sign of the result in case of signed 8-bit multiplication.
    SCALAR_SIGN <= (A(7) XOR B(7)) when A_IS_ZERO /= "11" AND B_IS_ZERO /= "11" else '0';

--- Determine the sign of the result in the case of signed vector 4-bit multiplication.
    VECTOR_SIGN(1) <= (A(7) XOR B(7)) when A_IS_ZERO(1) /= '1' AND B_IS_ZERO(1) /= '1' else '0';
    VECTOR_SIGN(0) <= (A(3) XOR B(3)) when A_IS_ZERO(0) /= '1' AND B_IS_ZERO(0) /= '1' else '0';
 
--- Below is the explanation on how to compute two complement. In the approach implemented here, it is required to add a 1 to the absolute value (abs) of a 
--- negative number. Then, below signals are used to decide wether we need to add a 1 to the abs value or not
    TWO_COMPLEMENT_ADD_A <= "0000000" & A(7) when V = '0' AND S = '1' else
                            "000" & A(7) & "000" & A(3) when V = '1' AND S = '1' else
                            "00000000";
                            
    TWO_COMPLEMENT_ADD_B <= "0000000" & B(7) when V = '0' AND S = '1' else
                            "000" & B(7) & "000" & B(3) when V = '1' AND S = '1' else
                            "00000000";

--- While the explanation and comments within the script are based on 8-bit inputs for both signed and 
--- unsigned multiplication, the code is adaptable to handle 4-bit inputs. This is achieved by treating 
--- each 4-bit input as part of separate 8-bit inputs, where for a given 8-bit input, the lower 4 bits (LSB) 
--- are treated as Input0 and the upper 4 bits (MSB) as Input1, both for A and B inputs. This approach allows 
--- the code to maintain its core functionality and structure while being flexible to accommodate different 
--- input sizes.

-- If we perform signed multiplication (S = '1'), we extract the absolute value, perform the multiplication, and
-- then add the sign using 2's complement: Two_Complement(|A|x|B|), where the sign is computed with A(7) XOR B(7).

-- For signed multiplication between two 8-bit numbers, the first step is to find the absolute value of each input. 
-- To do that, we need to consider two cases:
--     1. If the input number is positive, zero, or ±128/±8 (max value in sign representation, remember in bit representation, 128 = -128, 8 = -8), 
--        then we use it as it is.
--     2. If the input number is negative (except for -128/-8), then we use 2's complement. To compute 2's complement, we follow this approach:
--         A. Invert all bits (except for the sign bit) using a NOT gate. Since a signed number uses the MSB as the sign bit, the value is
--            stored in the remaining bits. So, we need to concatenate a 0 for the MSB to have the correct absolute value representation.
--         B. Add 1 to the inverted result.

   A_NEG <= '0' & not A(6 downto 0) when S = '1' AND V = '0' AND A_IS_NEGATIVE(1) = '1' else
            '0' & not A(6 downto 4) & '0' & not A(2 downto 0) when S = '1' AND V = '1' AND A_IS_NEGATIVE = "11" else
            A(7 downto 4) & '0' & not A(2 downto 0) when S = '1' AND V = '1' AND A_IS_NEGATIVE = "01" else
            '0' & not A(6 downto 4) & A(3 downto 0) when S = '1' AND V = '1' AND A_IS_NEGATIVE = "10" else
            A;
    ABS1: entity work.adder(dataflow) port map (A_NEG, TWO_COMPLEMENT_ADD_A, A_ABS, C_DUMMY1);
    A_COPY <= A_ABS when A_IS_MAX = "00" OR A_IS_MAX = "01" OR A_IS_MAX = "10" else A; -- Here we evalute case 1 vs case 2

    B_NEG <= '0' & not B(6 downto 0) when S = '1' AND V = '0' AND B_IS_NEGATIVE(1) = '1' else
             '0' & not B(6 downto 4) & '0' & not B(2 downto 0) when S = '1' AND V = '1' AND B_IS_NEGATIVE = "11" else
             B(7 downto 4) & '0' & not B(2 downto 0) when S = '1' AND V = '1' AND B_IS_NEGATIVE = "01" else
             '0' & not B(6 downto 4) & B(3 downto 0) when S = '1' AND V = '1' AND B_IS_NEGATIVE = "10" else
             B;
    ABS2: entity work.adder(dataflow) port map (B_NEG, TWO_COMPLEMENT_ADD_B, B_ABS, C_DUMMY2);
    B_COPY <= B_ABS when B_IS_MAX = "00" OR B_IS_MAX = "01" OR B_IS_MAX = "10" else B; -- Here we evalute case 1 vs case 2

--- Here we perform unsigned multiplication (S = '0') or signed multiplication (S = '1') with the absolute value version of input numbers 
--- that actually follow the same process as the unsigned case. The process is as follows:
---     1. Compute partial products with an AND gate between each bit from the B input and each bit from the A input.
---     2. Perform the addition of each partial product, taking into account the 1-position shift to the left at each partial addition.
---  Important note: Propagate the carry after each addition, except for the first addition, since the carry is 0 (no previous additions).
---  We create two copies of the signal to manage scalar (Y_COPY) or vector (Y_VECTOR) multiplication

    Y_COPY(0) <= A_COPY(0) AND B_COPY(0);
    Y_VECTOR(0) <= A_COPY(0) AND B_COPY(0);

    A1 <= '0' & A_COPY(7 downto 1) when B_COPY(0) = '1' AND V = '0' else "00000" & A_COPY(3 downto 1) when B_COPY(0) = '1' AND V = '1' else "00000000";
    B1 <= A_COPY when B_COPY(1) = '1' AND V = '0' else "0000" & A_COPY(3 downto 0) when B_COPY(1) = '1' AND V = '1' else "00000000";
    X1: entity work.adder(dataflow) port map (A1, B1, S1, C1);
    Y_COPY(1) <= S1(0);
    Y_VECTOR(1) <= S1(0);
    
    A2 <= C1 & S1(7 downto 1) when V = '0' else S1(4) & S1(7 downto 1);
    B2 <= A_COPY when B_COPY(2) = '1' AND V = '0' else "0000" & A_COPY(3 downto 0) when B_COPY(2) = '1' AND V = '1' else "00000000";
    X2: entity work.adder(dataflow) port map (A2, B2, S2, C2);
    Y_COPY(2) <= S2(0);
    Y_VECTOR(2) <= S2(0);
    
    A3 <= C2 & S2(7 downto 1) when V = '0' else S2(4) & S2(7 downto 1);
    B3 <= A_COPY when B_COPY(3) = '1' AND V = '0' else "0000" & A_COPY(3 downto 0) when B_COPY(3) = '1' AND V = '1' else "00000000";
    X3: entity work.adder(dataflow) port map (A3, B3, S3, C3);
    Y_COPY(3) <= S3(0);
    Y_VECTOR(6 downto 3) <= S3(3 downto 0);
    Y_VECTOR(7) <= VECTOR_SIGN(0) when S = '1' else S3(4);--Sign/MSB bit for vector case
    
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
    
    A6 <= C5 & S5(7 downto 1) when V = '0' else S5(4) & S5(7 downto 1);
    B6 <= A_COPY when B_COPY(6) = '1' AND V = '0' else "0000" & A_COPY(7 downto 4) when B_COPY(6) = '1' AND V = '1' else "00000000";
    X6: entity work.adder(dataflow) port map (A6, B6, S6, C6);
    Y_COPY(6) <= S6(0);
    Y_VECTOR(10) <= S6(0);
    
    A7 <= C6 & S6(7 downto 1) when V = '0' else S6(4) & S6(7 downto 1);
    B7 <= A_COPY when B_COPY(7) = '1' AND V = '0' else "0000" & A_COPY(7 downto 4) when B_COPY(7) = '1' AND V = '1' else "00000000";
    X7: entity work.adder(dataflow) port map (A7, B7, S7, C7);
    Y_COPY(14 downto 7) <= S7;
    Y_COPY(15) <= SCALAR_SIGN when S = '1' else C7;--Sign/MSB bit for scalar case
    
    Y_VECTOR(14 downto 11) <= S7(3 downto 0);
    Y_VECTOR(15) <= VECTOR_SIGN(1) when S = '1' else S7(4);--Sign/MSB bit for vector case
    
    
--- To set the final result, we need to decide between two cases:
---     1. Unsigned multiplication or signed multiplication when the result is positive or zero (we know the result is zero if any of the inputs is zero): Set Y equal to Y_COPY.
---     2. Signed multiplication: Set the MSB of Y equal to the MSB of Y_COPY (or Y_VECTOR in case we use vector inputs) and use 2's complement for the remaining bits. To compute 2's complement, we follow this approach:
---         A. Invert all bits (except for the sign bit) using a NOT gate. Since a signed number uses the MSB as the sign bit, the value is
---            stored in the remaining bits. So, we need to concatenate a 0 for the MSB and then invert the bits.
---         B. Add 1 to the inverted result: 
---            Since our adder only supports 8-bit inputs, we need to perform the whole addition in three steps:
---                 i. Add the first 8 LSB bits of the two inputs (the first input is the multiplication result and the second input is 1).
---                 ii. For scalar multiplication: You need to add the upper 8 MSB with the carry resulted from the first addition, then create the second term by concatenating 7 zeros and the carry bit
---                     For vector multiplication: The upper 8 MSB are an independent quantity since this is vector multiplication, we need to add 1 as well, so the second term is just a 1
---                 iii. Add the MSB of both quantities, taking into account above considerations.


    Y_NEG <= not('0' & Y_COPY(14 downto 0)) when S = '1' AND V = '0' else
             not('0' & Y_VECTOR(14 downto 8) & '0' & Y_VECTOR(6 downto 0)) when S = '1' AND V = '1';
    
    ABS3: entity work.adder(dataflow) port map (Y_NEG(7 downto 0), "00000001", Y_ABS_LSB, C_Y);
    Y_CARRY_TERM <= "0000000" & C_Y when S = '1' AND V = '0' else "00000001" when S = '1' AND V = '1' else "00000000";
    ABS4: entity work.adder(dataflow) port map (Y_NEG(15 downto 8), Y_CARRY_TERM, Y_ABS_MSB, C_DUMMY3);
    Y <= Y_COPY(15) & Y_ABS_MSB(6 downto 0) & Y_ABS_LSB when S = '1' AND V = '0' AND SCALAR_SIGN = '1' else
         Y_COPY when V = '0' else
         Y_VECTOR(15) & Y_ABS_MSB(6 downto 0) & Y_VECTOR(7) & Y_ABS_LSB(6 downto 0) when S = '1' AND V = '1' AND VECTOR_SIGN = "11" else
         Y_VECTOR(15 downto 8) & Y_VECTOR(7) & Y_ABS_LSB(6 downto 0) when S = '1' AND V = '1' AND VECTOR_SIGN = "01" else
         Y_VECTOR(15) & Y_ABS_MSB(6 downto 0) & Y_VECTOR(7 downto 0) when S = '1' AND V = '1' AND VECTOR_SIGN = "10" else
         Y_VECTOR;
--- ENTER STUDENT CODE ABOVE ---

end dataflow;

-- Behavioral architecture of the array multiplier, can be used as reference during verification --
architecture behavioral of multiplier is

begin

Y <= BIT_VECTOR( unsigned(A) * unsigned(B) )
        when s ='0' AND v = '0' else
     BIT_VECTOR( signed(A) * signed(B) )
        when s ='1' AND v = '0' else
     BIT_VECTOR( unsigned(A(7 downto 4)) * unsigned(B(7 downto 4)) ) &
     BIT_VECTOR( unsigned(A(3 downto 0)) * unsigned(B(3 downto 0)) )
        when s ='0' AND v = '1' else
     BIT_VECTOR( signed(A(7 downto 4)) * signed(B(7 downto 4)) ) &
     BIT_VECTOR( signed(A(3 downto 0)) * signed(B(3 downto 0)) );
end behavioral;
