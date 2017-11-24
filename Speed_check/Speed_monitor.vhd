----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:31 11/26/2013 
-- Design Name: 
-- Module Name:    Speed_monitor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Speed_monitor is
    Port ( Select_button : in  STD_LOGIC;
	        reset:in  STD_LOGIC;
           LED_flasher : inout  STD_LOGIC_VECTOR (7 downto 0);
           fpulse : in  STD_LOGIC_VECTOR (7 downto 0);
			  pulloutSp : out  STD_LOGIC_VECTOR (7 downto 0);
           buzzer : out  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC);
end Speed_monitor;

architecture Behavioral of Speed_monitor is
type state IS (S0,S1,S2,S3,S4,S5,S6,S7);
type state IS (B0, B1,B2);
SIGNAL Speed_state,buzzer_state: state;
begin
	ControlSpeed: PROCESS (Select_button,reset)
	BEGIN
		IF(reset = '1') THEN
			speed_state <= S0;
		ELSE
			CASE Speed_state IS
			WHEN S0 =>
				IF Select_button = '1' THEN
				speed_state <= S1;
				ELSE speed_state<=S0;
				END IF;
			WHEN S1 =>
				IF Select_button='1' THEN
				Speed_state<=S2;
				ELSE speed_state<=S1;
				END IF;
			WHEN S2 =>
				IF Select_button = '1' THEN
				speed_state <= S3;
				ELSE speed_state<=S2;
				END IF;
			WHEN S3 =>
				IF Select_button='1' THEN
				Speed_state<=S4;
				ELSE speed_state<=S3;
				END IF;
				WHEN S4 =>
				IF Select_button = '1' THEN
				speed_state <= S5;
				ELSE speed_state<=S4;
				END IF;
			WHEN S5 =>
				IF Select_button='1' THEN
				Speed_state<=S6;
				ELSE speed_state<=S5;
				END IF;
			WHEN S6=>
				IF Select_button = '1' THEN
				speed_state <= S7;
				ELSE speed_state<=S6;
				END IF;
			WHEN S7 =>
				IF Select_button='1' THEN
				Speed_state<=S0;
				ELSE speed_state<=S7;
				END IF;
			END CASE;
		END IF;
	End PROCESS;
	WITH Speed_state SELECT 
		LED_flasher<="00100011"  WHEN S0 ,
		LED_flasher<="00101101"  WHEN S1 ,
		LED_flasher<="00110111"  WHEN S2 ,
		LED_flasher<="00111100"  WHEN S3 ,
		LED_flasher<="01010001"  WHEN S4 ,
		LED_flasher<="01000110"  WHEN S5 ,
		LED_flasher<="01001011"  WHEN S6 ,
		LED_flasher<="01001011"  WHEN S7 ,
		LED_flasher<="00000000"  WHEN OTHERS;
	ControlBuzzer: PROCESS (fpulse,LED_flasher,reset,clock)
	BEGIN
		IF(reset = '1') THEN
			buzzer_state <= B0;
		ELSiF (rising_edge(clock) ) THEN 
			CASE buzzer_state IS
			WHEN B0 =>
				IF (((fpulse-3)>=0)and (fpulse<LED)) THEN
				buzzer_state <= B1;
				ELSIF(fpulse>=LED) THEN
				buzzer_state<= B2;
				ELSE buzzer_state<=B0;
				END IF;
			WHEN B1 =>
				IF ((fpulse-3)<0) THEN
				buzzer_state<=B0;
				ELSIF  (fpulse>=LED) THEN
				buzzer_state<=B2;
				ELSE buzzer_state<=B1;
				END IF;
			WHEN B2 => 
				IF (fpulse-3<0) THEN
				buzzer_state<=B0;
				ELSIF (((fpulse-3)>0) and (fpulse<LED)) THEN
				buzzer_state<=B1;
				ELSE buzzer_state<=B2;
				END IF;
			END CASE;
		END IF;
	END PROCESS;
	--buzzer_state SELECT 
		--pulloutSp<="00100011"  WHEN B0 ,
		--LED_flasher<="00101101"  WHEN S1 ,
		--LED_flasher<="00111100"  WHEN S3 ,
		--LED_flasher<="01010001"  WHEN S4 ,
		
		--LED_flasher<="00000000"  WHEN OTHERS;
end Behavioral;

