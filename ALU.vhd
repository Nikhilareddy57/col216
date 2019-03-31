----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2019 11:45:46 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: week8
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
use IEEE.STD_LOGIC_SIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( clock : in STD_LOGIC;
           operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           opcode : in STD_LOGIC_VECTOR(3 downto 0);
           c_shift : in STD_LOGIC;
           flagSet : in STD_LOGIC;
           result : out STD_LOGIC_VECTOR (31 downto 0);
           Z : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
signal temp : std_logic_vector(31 downto 0);
signal Z_flag, V_flag, C_flag, N_flag, c31, c32 : std_logic := '1';
begin


    with opcode select temp <=
        operand1 and operand2 when "0000",
        operand1 xor operand2 when "0001",
        operand1 - operand2 when "0010",
        operand2 - operand1 when "0011",
        operand1 + operand2 when "0100",
        operand1 + operand2 + C_flag when "0101",
        operand1 - operand2 + C_flag when "0110",
        operand2 - operand1 + C_flag when "0111",
        operand1 and operand2 when "1000",
        operand1 xor operand2 when "1001",
        operand1 - operand2 when "1010",
        operand1 + operand2 when "1011",
        operand1 or operand2 when "1100",
        operand2 when "1101",
        operand1 and (not operand2) when "1110",
        not operand2 when "1111";
     result <= temp;
     Z <= Z_flag;
 
c31 <= (operand1(31) xor operand2(31) xor temp(31));
c32 <= (operand1(31) and operand2(31)) or ( (operand1(31) or operand2(31)) and c31);   
process(clock)
begin
   if(flagSet = '1') then
     if(temp = "00000000000000000000000000000000") then
          Z_flag <= '1';
     else Z_flag <= '0';
     end if;
     N_flag <= temp(31);
     
     if((((not opcode(3)) and opcode(2)) or((not opcode(2)) and opcode(1))) = '1') then
     V_flag <= c31 xor c32;
     C_flag <= c32;
     else 
     C_flag <= c_shift;
     end if;
     
     
   end if; 
end process;
end Behavioral;
