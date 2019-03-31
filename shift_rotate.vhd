----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2019 04:50:54 PM
-- Design Name: 
-- Module Name: shift_rotate - Behavioral
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

entity shift_rotate is
    Port ( operand : in STD_LOGIC_VECTOR (11 downto 0); -- least 12 bits of operand2 of dp instruction
           C_shift : in std_logic ;-- carry value from shifter
            I_bit: in std_logic; --immediate bit
            rmValue, rsvalue : in std_logic_vector(31 downto 0);
            rm, rs: out std_logic_vector(3 downto 0);
            output : out std_logic_vector(31 downto 0)); -- operand2 value after performing shift/rotate on it 
end shift_rotate;

architecture Behavioral of shift_rotate is
signal shiftType : std_logic_vector(1 downto 0);
signal op2 : std_logic_vector(31 downto 0); -- value to be shifted
signal rotSftAmt: std_logic_vector(5 downto 0);
signal rotateAmtInt : integer; 
begin
    rm <= operand(3 downto 0);
    rs <= operand(11 downto 8);
    
    rotSftAmt <= operand(11 downto 8)&'0' when (I_bit = '1') else -- 2*rotate amount
                 '0'&rsValue(3 downto 0) when (I_bit = '1') and (operand(4) = '1') else
                 operand(11 downto 7);
     
    shiftType <= operand(6 downto 5);
    
    op2 <= rmValue when I_bit = '0' else
           operand(7 downto 0);
    
    rotateAmtInt <= to_integer(unsigned(rotSftAmt));
    output <= op2((rotateAmtInt - 1) downto 0)&op2(31 downto rotateAmtInt) when (I_bit = '1' and (rotateAmtInt > 0 ))else
              op2 when (I_bit = '1' and (rotateAmtInt = 0 )) else
              
              
                       
    
    output <=  

end Behavioral;
