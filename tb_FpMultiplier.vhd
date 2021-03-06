--
-- tb_FpMultiplier.vhd 
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use std.textio.all;
 
entity tb_FpMul is
end tb_FpMul;
 
architecture behavior of tb_FpMul is 
	 
component FpMul
	port(
		Reset, Clock, InEnable: in std_logic; 
		Xin, Yin: in std_logic_vector(63 downto 0);
		Rout: out std_logic_vector(63 downto 0);		
		OutValid: out std_logic
  );
end component;	 
	 
signal tb_Reset, tb_Clock, tb_InEnable, tb_OutValid: std_logic := '0';
signal tb_Xin, tb_Yin, tb_Rout: std_logic_vector(63 downto 0);

-- Clock period definitions
constant period : time := 100 ns;    

begin

	-- Instantiate the Unit Under Test (UUT)
	uut: FpMul 
		PORT MAP (
         Reset		=> tb_Reset,
		 Clock 	    => tb_Clock,
         InEnable	=> tb_InEnable,
         Xin		=> tb_Xin,
         Yin 	 	=> tb_Yin,
		 Rout		=> tb_Rout,
         OutValid	=> tb_OutValid
        );
		  
	CLK: process
   begin
		tb_Clock <= '0';
		wait for period/2;
		tb_Clock <= '1';
		wait for period/2;
   end process CLK;

	process is						
		file FIX: TEXT open READ_MODE is "InputX.txt"; 
		file FIY: TEXT open READ_MODE is "InputY.txt";
		variable LX, LY: LINE;
		variable FrontStr: string(1 to 5);
		variable XinV, YinV: std_logic_vector(63 downto 0);
	begin
		tb_Reset <= '1';
		wait for 50 ns;
		tb_Reset <= '0';
		tb_InEnable <= '0';

		while not ENDFILE(FIX)  loop
			READLINE(FIX, LX);
			read(LX, FrontStr);
			HREAD(LX, XinV);	
			READLINE(FIY, LY);		
			read(LY, FrontStr);
			HREAD(LY, YinV);
			wait until falling_edge(tb_Clock);
			tb_Xin <= XinV;
			tb_Yin <= YinV;
			tb_InEnable <= '1';
		end loop;
		tb_InEnable <= '0';
		wait; 
	end process;	

	process is						
		file FO: TEXT open WRITE_MODE is "OutputR.txt";
		file FOm: TEXT open READ_MODE is "outputR_matlab.txt";
		variable L, Lm: LINE;
		variable FrontStr: string(1 to 5);
		variable RoutVm: std_logic_vector(63 downto 0);
		variable v_OK: boolean;
		
	begin
		----wait for OutValid
		wait until rising_edge(tb_OutValid);
		
		Write(L, STRING'("Results"));
		WRITELINE(FO, L);		
		Write(L, STRING'("Data from Matlab"), Left, 20);
		Write(L, STRING'("Data from Simulation"), Left, 20);
		WRITELINE(FO, L);		
		
		while not ENDFILE(FOm)  loop
			wait until rising_edge(tb_Clock);
					--wait for 1ns;
					READLINE(FOm, Lm);
					read(Lm, FrontStr);
					HREAD(Lm, RoutVm);		
					if RoutVm = tb_Rout then
						v_OK :=True;
					else
						v_OK :=False;
					end if;
					HWRITE(L, RoutVm, Left, 20);
                    HWRITE(L, tb_Rout, Left, 20);
					WRITE(L, v_OK, Left, 10);			
					WRITELINE(FO, L);
		end loop;
		wait;  
	end process;
end;
