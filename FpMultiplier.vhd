--
-- FpMultiplier.vhd 
--

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity FpMul is 
	port(
		Reset, Clock, InEnable: in std_logic; 
		Xin, Yin: in std_logic_vector(63 downto 0);
		Rout: out std_logic_vector(63 downto 0);		
		OutValid: out std_logic
  );
end FpMul; 

architecture FpMul_arch of FpMul is

-- High speed, max usage(11 x DSP48E1), max latency(16 clock cycles), NonBlocking  
COMPONENT mul_double
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

begin	

	U1: mul_double 
		PORT MAP (
			aclk => Clock,
			s_axis_a_tvalid => InEnable,
			s_axis_a_tdata => Xin,
			s_axis_b_tvalid => InEnable,
			s_axis_b_tdata => Yin,
			m_axis_result_tvalid => OutValid,
			m_axis_result_tdata => Rout
		);
		
end FpMul_arch;