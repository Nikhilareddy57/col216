----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.03.2019 14:28:27
-- Design Name: 
-- Module Name: Shifter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Shifter is
    Port ( instruct, B, C : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carry : out STD_LOGIC);
end Shifter;

architecture Behavioral of Shifter is
signal SValue : integer;
signal zeros, ones : std_logic_vector(31 downto 0);
signal shiftType : std_logic_vector(1 downto 0);
signal shiftAmt : std_logic_vector(5 downto 0);
signal shiftInput : std_logic_vector(31 downto 0);
begin
    shiftType <= "11" when (instruct(25) = '1')  else
                     instruct(6 downto 5);
    shiftAmt <= instruct(11 downto 8)&'0' when (instruct(25) = '1') else
                       instruct(11 downto 7) when(instruct(4) = '0') else
                       C(3 downto 0)&'0';
    shiftInput <= instruct(7 downto 0) when(instruct(25) = '1') else
                      B;
    zeros <= "00000000000000000000000000000000";
    ones <=  "11111111111111111111111111111111";
    SValue <= to_integer(unsigned(shiftAmt));
    output <= B((31 - SValue) downto 0)& zeros(SValue downto 1)             when shiftType = "00" else --sll
              zeros(SValue downto 1)&B(31 downto SValue)      when shiftType = "01" else --srl
              zeros(SValue downto 1)&B(31 downto SValue)     when (shiftType = "10")and(B(31)= '0') else --sra
              ones(SValue downto 1)&B(31 downto SValue)     when (shiftType = "10")and(B(31)= '1') else --sra
              B((SValue-1) downto 0) & B(31 downto SValue) ; --ror
    carry <= B(32 - SValue) when shiftType = "00" else
             input(SValue -1);
             
             
end Behavioral;
