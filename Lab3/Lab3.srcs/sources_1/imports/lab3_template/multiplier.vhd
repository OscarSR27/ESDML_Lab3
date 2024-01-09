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
    signal A1, B1, A2, B2, A3, B3, A4, B4, A5, B5, A6, B6, A7, B7: BIT_VECTOR(7 downto 0);
    signal S1, S2, S3, S4, S5, S6, S7: BIT_VECTOR(7 downto 0);
    signal C1, C2, C3, C4, C5, C6, C7: BIT;
--- ENTER STUDENT CODE ABOVE ---

begin

--- ENTER STUDENT CODE BELOW ---
    Y(0) <= A(0) AND B(0);

    A1 <= '0' & A(7 downto 1) when B(0) = '1' else "00000000";
    B1 <= A when B(1) = '1' else "00000000";
    X1: entity work.adder(dataflow) port map (A1, B1, S1, C1);
    Y(1) <= S1(0);
    
    A2 <= C1 & S1(7 downto 1);
    B2 <= A when B(2) = '1' else "00000000";
    X2: entity work.adder(dataflow) port map (A2, B2, S2, C2);
    Y(2) <= S2(0);
    
    A3 <= C2 & S2(7 downto 1);
    B3 <= A when B(3) = '1' else "00000000";
    X3: entity work.adder(dataflow) port map (A3, B3, S3, C3);
    Y(3) <= S3(0);
    
    A4 <= C3 & S3(7 downto 1);
    B4 <= A when B(4) = '1' else "00000000";
    X4: entity work.adder(dataflow) port map (A4, B4, S4, C4);
    Y(4) <= S4(0);
    
    A5 <= C4 & S4(7 downto 1);
    B5 <= A when B(5) = '1' else "00000000";
    X5: entity work.adder(dataflow) port map (A5, B5, S5, C5);
    Y(5) <= S5(0);
    
    A6 <= C5 & S5(7 downto 1);
    B6 <= A when B(6) = '1' else "00000000";
    X6: entity work.adder(dataflow) port map (A6, B6, S6, C6);
    Y(6) <= S6(0);
    
    A7 <= C6 & S6(7 downto 1);
    B7 <= A when B(7) = '1' else "00000000";
    X7: entity work.adder(dataflow) port map (A7, B7, S7, C7);
    Y(14 downto 7) <= S7;
    Y(15) <= C7;

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
