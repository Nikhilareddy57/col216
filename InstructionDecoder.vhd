----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2019 12:28:52 AM
-- Design Name: 
-- Module Name: InstructionDecoder - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionDecoder is
   Port (instruct: in std_logic_vector(31 downto 0 );
         I_bit,sign: out std_logic;
         field_class : out std_logic_vector (1 downto 0);
         op_class : out std_logic_vector (3 downto 0));
end InstructionDecoder;

architecture Behavioral of InstructionDecoder is
signal F_field : std_logic_vector(1 downto 0);
signal opcode : std_logic_vector(5 downto 0);
begin
   F_field <= instruct(27 downto 26);
   field_class <= F_field;
   I_bit <= instruct(25);
   sign <= instruct(23);
   --Zset <= '1' when (opcode = "001010") else '0';
   with F_field select opcode <=
        "00"&instruct(24 downto 21) when "00",
        "01000"&instruct(20 downto 20) when "01",
        "10"&instruct(31 downto 28) when "10",
        "111111" when others;    
   with opcode select op_class <=
        "00000" when "000000",--and
        "00001" when "000001",--eor
        "00010" when "000010",--sub
        "00011" when "000011",--rsb
        "00100" when "000100",--add
        "00101" when "000101",--adc
        "00110" when "000110",--sbc
        "00111" when "000111",--rsc
        "01000" when "001000",--tst
        "01001" when "001001",--teq
        "01010" when "001010",--cmp
        "01011" when "001011",--cmn
        "01100" when "001100",--orr
        "01101" when "001101",--mov
        "01110" when "001110",--bic
        "01111" when "001111",--mvn
        "10100" when "010001",--ldr
        "10101" when "010000",--str
        "10110" when "101110",--b
        "10111" when "100000",--beq
        "11000" when "100001",--bne
        "11001" when "000000",--halt
        "11010" when others;  --others
      
      
end Behavioral;
