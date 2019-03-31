----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/19/2019 09:54:23 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
    Port ( clock,step,one_instr,go : in STD_LOGIC);
           --instruction : in STD_LOGIC_VECTOR (31 downto 0);
           --adress : out STD_LOGIC_VECTOR (31 downto 0));
end main;

architecture Behavioral of main is
signal A,B,C,RES,DR,IR, ShifterOut : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal rd1,rd2,wd,result,pc_out, address, instruction: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal operand1,operand2,result1: std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal Asrc2,field_class,op : std_logic_vector(1 downto 0) := "00";
signal op_class,rad1,rad2,wadr : std_logic_vector(3 downto 0) := "0000";
signal PW,lorD,MR,MW,IW,DW,Rsrc,M2R,RW,AW,BW,Asrc1,Fset,ReW,carry,ZFlag,I_bit,sign, ACsel, C_shift : std_logic := '0';
COMPONENT ALU is
    Port ( clock : in STD_LOGIC;
           operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           opcode : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           C_shift : in STD_LOGIC;
           flagSet : in STD_LOGIC;
           result : out STD_LOGIC_VECTOR (31 downto 0);
           Z : out STD_LOGIC);
END COMPONENT;

COMPONENT InstructionDecoder is
   Port (instruct: in std_logic_vector(31 downto 0 );
         field_class : out std_logic_vector (1 downto 0);
         I_bit,sign : out std_logic;
         op_class : out std_logic_vector (3 downto 0));
END COMPONENT;

COMPONENT RegisterFile is
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
END COMPONENT;

COMPONENT execution_stateFSM is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC;
           step : in STD_LOGIC;
           instr : in STD_LOGIC;
           go : in STD_LOGIC;
           control_state : in STD_LOGIC_VECTOR (3 downto 0));
END COMPONENT;

COMPONENT control_stateFSM is
    Port ( clk,reset,LD_bit,I_bit,sign,Zset,ZFlag : in STD_LOGIC;
           instr_type : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           Asrc2,op : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           PW,lorD,MR,MW,IW,DW,Rsrc,M2R,RW,AW,BW,Asrc1,Fset,ReW,carry, ACsel : out STD_LOGIC);
END COMPONENT;

COMPONENT Shifter is
    Port ( instruct, B, C : in STD_LOGIC_VECTOR (31 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carry : out STD_LOGIC);
END COMPONENT;

COMPONENT Memory IS
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

begin

Memory1: Memory
    Port Map (a => address(9 downto 2),
              d => B,
              clk => clock,
              we => MW,
              spo => instruction ); 
ALU1 : ALU
   Port Map (clock => clock,
             operand1 =>operand1, operand2 =>operand2,
             opcode =>op, c_shift =>c_shift, flagSet =>Fset,
             result =>result, Z =>Zflag );
InstructDecode1 : InstructionDecoder
   Port Map (instruct=>IR,
             field_class=>field_class,
             op_class=>op_class, I_bit=>I_bit, sign=>sign);         
RegisterFile1 : RegisterFile
  Port Map (clock =>clock,reset => '0',
            rad1 =>rad1, rad2 =>rad2,
            wadr =>wadr, wData =>wd, wDataEn =>RW,
            pc_in =>result1, pcEn =>PW, pc_out => pc_out,
            data1 =>rd1,data2 =>rd2);
execFSM : execution_stateFSM
  Port Map(reset =>'0', clk =>clock, step =>step,instr =>one_instr, go =>go,
           control_state =>op_class);
controlFSM : control_stateFSM
  Port Map (clk =>clock, reset =>'0', LD_bit =>IR(20),
            I_bit =>I_bit, sign => sign, Zflag => Zflag, Zset =>IR(20),
            instr_type =>op_class,
            Asrc1=>Asrc1,Asrc2 =>Asrc2, PW =>PW, lorD =>lorD, MR =>MR,
            MW =>MW, IW =>IW, DW=>DW, Rsrc=>Rsrc, M2R=>M2R,
            RW=>RW, AW=>AW, BW=>BW,
            op=>op, Fset=>Fset, ReW=>ReW, carry=> carry);
shifter1 : Shifter
    Port Map (  instruct => IR, B => B, C => rad1,
                output => ShifterOut,
                carry => C_shift);
Register_X: process (clock) 
 begin
   if (rising_edge(clock)) then
     if(AW='1') then A <= rd1; 
     end if;
     if(BW='1') then B <= rd2;
     end if;
    -- if(CW='1') then C <= rd1;
     --end if;
     if(IW='1') then IR <= instruction; 
     end if;
     if(DW='1') then DR <= instruction;
     end if;
     if(ReW='1') then RES <= result; 
     end if;
 end if;
 end process;
 -----------Combinational Circuit---------------
 result1 <= (result(29 downto 0)&"00");
 address <= pc_out when (lorD = '0') else RES;
 rad1 <= IR(19 downto 16) when ACsel='0' else IR(11 downto 8);
 rad2 <= IR(3 downto 0) when Rsrc ='0' else IR(15 downto 12);
 wadr <= IR(15 downto 12);
 wd <= DR when (M2R = '1') else RES;
 operand1 <= "00"&pc_out(31 downto 2) when (Asrc1 = '0') else A;
 operand2 <= shifterOut;
end Behavioral;
