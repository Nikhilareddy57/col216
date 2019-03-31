----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2019 12:40:46 AM
-- Design Name: 
-- Module Name: execution_stateFSM - Behavioral
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

entity execution_stateFSM is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           step : in STD_LOGIC;
           instr : in STD_LOGIC;
           go : in STD_LOGIC;
           control_state : in STD_LOGIC_VECTOR (3 downto 0);
           exec_state : out STD_LOGIC_VECTOR(2 downto 0));
end execution_stateFSM;

architecture Behavioral of execution_stateFSM is
type execution_state_type is (initial, cont, oneinstr, onestep, done);
signal state : execution_state_type := initial;
begin
exec_state <= "000" when state = initial else
              "001" when state = cont else
              "010" when state = oneinstr else
              "011" when state = onestep else
              "100";
process(clk,reset)                  -- states are encoded from 1 not from 0
begin
   if(reset = '1') then
     state <= initial;
   elsif(rising_edge(clk)) then
     if(state=initial) then if(step = '1') then state <= onestep;
                           elsif(instr = '1') then state <= oneinstr;
                           elsif(go = '1') then state <= cont;
                           else state <= initial; 
                           end if;
     elsif(state = onestep) then state <= done;
     elsif(state = oneinstr) then if(control_state="0101" or control_state = "0110" or control_state = "0111" or control_state = "1000" or control_state = "1010") then
                                  state <= done;
                                  else state <= oneinstr;
                                  end if;
     elsif(state = cont) then if(control_state="1010") then state <= done;
                              else state <= cont;
                              end if;
     else if(step = '1' or instr = '1' or go = '1') then state <= done;
          else state <= initial;
          end if;
     end if;
     end if;
end process;
end Behavioral;
