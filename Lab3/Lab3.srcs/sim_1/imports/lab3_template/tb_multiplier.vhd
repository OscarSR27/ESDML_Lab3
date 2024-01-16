----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 07/19/2023 05:43:15 PM
-- Design Name:
-- Module Name: tb_multiplier - Behavioral
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

entity tb_multiplier is
--  Port ( );
end tb_multiplier;

architecture behavioral of tb_multiplier is
    signal A, B : bit_vector(7 downto 0);
    signal S, V : bit;
    signal test:bit;
    signal Y1, Y2 : bit_vector(15 downto 0);
    --signal C1T,C2T,C3T: bit;
    --signal A1T,A2T,A3T,B1T,B2T,B3T,S1T,S2T,S3T: bit_vector (7 downto 0);
begin

--- ENTER STUDENT CODE BELOW ---
    process
    begin
        S <= '1'; V <= '0';
        for AI in 0 to 2**8-1 loop
            A <= bit_vector(to_unsigned(AI, 8));
            for BI in 0 to 2**8-1 loop
                B <= bit_vector(to_unsigned(BI, 8));
                wait for 1 ns;
                assert Y1 = Y2;
            end loop;
        end loop;
        wait;
    end process;

UUT1: entity work.multiplier(behavioral) port map(A => A, B => B, S => S, V => V, Y => Y1); -- Complete port map!
UUT2: entity work.multiplier(dataflow)   port map(A => A, B => B, S => S, V => V, Y => Y2); -- Complete port map!
--UUT2: entity work.multiplier(dataflow)   port map(A1t=>A1T,A2t=>A2T,A3t=>A3T,B1t=>B1T,B2t=>B2T,B3t=>B3T,S1t=>S1T,S2t=>S2T,S3t=>S3T,C1T=>C1t,C2T=>C2t,C3T=>C3t,A => A, B => B, S => S, V => V, Y => Y2); -- Complete port map!
--- ENTER STUDENT CODE ABOVE ---

end Behavioral;
