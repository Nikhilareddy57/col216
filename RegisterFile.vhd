----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2019 10:49:16 PM
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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
use IEEE.STD_LOGIC_SIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    Port ( clock,reset : in STD_LOGIC;
           rad1 : in STD_LOGIC_VECTOR (3 downto 0);
           rad2 : in STD_LOGIC_VECTOR (3 downto 0);
           wadr : in STD_LOGIC_VECTOR (3 downto 0);
           wData : in STD_LOGIC_VECTOR (31 downto 0);
           wDataEn : in STD_LOGIC;
           pc_in : in STD_LOGIC_VECTOR (31 downto 0);
           pcEn : in STD_LOGIC;
           pc_out : out STD_LOGIC_VECTOR (31 downto 0);
           data1 : out STD_LOGIC_VECTOR (31 downto 0);
           data2 : out STD_LOGIC_VECTOR (31 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
type registers_type is array(15 downto 0) of std_logic_vector(31 downto 0);
signal registers : registers_type := (others=>(others=>'0'));
begin
   data1 <= registers(to_integer(unsigned(rad1)));
   data2 <= registers(to_integer(unsigned(rad1)));
   pc_out <= registers(15);
process(clock)
  begin
    if(reset = '1') then
    registers(15) <= "00000000000000000000000000000000";
    elsif(rising_edge(clock)) then 
    if(wDataEn = '1') then
    registers(to_integer(unsigned(wadr))) <= wData;
    end if;
    if(pcEn = '1') then
    registers(15) <= pc_in;
    end if;
    end if;
end process;
end Behavioral;
