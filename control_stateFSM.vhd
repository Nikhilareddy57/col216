----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2019 01:23:46 AM
-- Design Name: 
-- Module Name: control_stateFSM - Behavioral
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

entity control_stateFSM is
    Port ( clk,reset,LD_bit,I_bit,sign,ZFlag,Zset : in STD_LOGIC;
           instr_type : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           Asrc2,op : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           PW,lorD,MR,MW,IW,DW,Rsrc,M2R,RW,AW,BW,Asrc1,Fset,ReW,carry, ACsel : out STD_LOGIC);
end control_stateFSM;

architecture Behavioral of control_stateFSM is
type control_state is (fetch,decode,shifter,arith,addr,brn,halt,res2RF,mem_wr,mem_rd,mem2RF);
signal state : control_state := fetch; 
begin
process(clk,reset)
begin
  if(reset = '1') then state<=fetch;
  elsif(rising_edge(clk)) then
    case state is
    when fetch => state <= decode;
    when decode => if(instr_type(4) = '0') then --- states are encoded from 0 not from 1
                       state <= shifter;
                   elsif(instr_type = "0100" or instr_type = "0101") then state <= addr;
                   elsif(instr_type = "0110" or instr_type = "0111" or instr_type = "1000") then state <= brn;
                   else state <= halt;
                   end if;
    when shifter => state <= arith;
    when arith => state <= res2RF;
    when addr => if(LD_bit ='0') then state <= mem_wr;
                 else state <= mem_rd;
                 end if;
    when brn => state <= fetch;
    when halt => state <= fetch;
    when res2RF => state <= fetch;
    when mem_wr => state <= fetch;
    when mem_rd => state <= mem2RF;
    when mem2RF => state <= fetch;
    end case;
  end if;
end process;

process(state)
begin
   PW<='0';lorD<='0';MR<='0';MW<='0';IW<='0';DW<='0';Rsrc<='0';M2R<='0';carry<='0';
   RW<='0';AW<='0';BW<='0';Asrc1<='0';Asrc2<="00";op<="00";Fset<='0';ReW<='0';
   case state is
      when fetch => IW<='1';Asrc1<='0';Asrc2<= "01";PW<='1';op<="01";
      when decode => AW<='1';BW<='1';Rsrc<='0';
      when arith => ReW <='1';Fset<=Zset;carry<='0';ACsel <= '0';
                    if(I_bit = '0') then Asrc1<= '1';Asrc2<= "00";
                    else Asrc1<='1';Asrc2<= "10";
                    end if;
                    if(instr_type = "0000") then op <="01";
                    elsif(instr_type = "0001" or instr_type = "0011") then  op <= "00";
                    else op <= "10";
                    end if;
      when shifter => ACsel <= '1';
      when addr => ReW<= '1';Asrc1<='1';Asrc2<="10";op<="0"&sign;carry<='0';Rsrc<='1';BW<='1';
      when brn => Asrc1<='0';Asrc2<="11";op<="01";carry<='1';
                  if(instr_type = "0110") then PW <= '1';
                  elsif(instr_type = "0111") then PW <= ZFlag;  ---- beq
                  else PW <= not(ZFlag);   ---- bne
                  end if;
      when res2RF => RW <= '1';M2R<='0';
      when mem_wr => lorD <= '1';MW <= '1';
      when mem_rd => DW <= '1';lorD<='1';MW<='0';
      when mem2RF => RW<='1';M2R<='1';
      when halt => PW <= '0';
   end case; 
end process;
end Behavioral;

