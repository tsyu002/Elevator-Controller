-- EE270 Project
-- Elevator Request Decoder
-- Description: Use 4 toggle switches + 2 pushbuttons to request the elevator for a particular direction from a certain floor

library ieee;
use ieee.std_logic_1164.all;
entity elevator_request is
	port( s:       in std_logic_vector(3 downto 0);   -- Switch Inputs
		  p_up:    in std_logic;					  -- Pushbutton Up Input
		  p_down:  in std_logic;			          -- Pushbutton Down Input
		  er_up:   out std_logic_vector(7 downto 0);  -- Elevator Up Request Output
		  er_down: out std_logic_vector(7 downto 0)); -- Elevator Down Request Output
end elevator_request;

architecture structural of elevator_request is
begin
	proc: process(p_up,p_down,s) is
	begin
		er_up <= "00000000";   -- default output value: no requests
		er_down <= "00000000"; -- default output value: no requests
	
		-- If the up pushbutton is pressed	
		if (p_up = '1') then
			case s is
				when "0001" => er_up(0) <= '1'; -- One of floors 1 through 8 will send the request
				when "0010" => er_up(1) <= '1';
				when "0011" => er_up(2) <= '1';
				when "0100" => er_up(3) <= '1';
				when "0101" => er_up(4) <= '1';
				when "0110" => er_up(5) <= '1';
				when "0111" => er_up(6) <= '1';
				when "1000" => er_up(7) <= '1';
				when others => er_up <= "00000000";
			end case;
		end if;
	
		-- If the down pushbutton is pressed
		if (p_down = '1') then
			case s is
				when "0010" => er_down(0) <= '1'; -- One of floors 2 through 9 will send the request
				when "0011" => er_down(1) <= '1';
				when "0100" => er_down(2) <= '1';
				when "0101" => er_down(3) <= '1';
				when "0110" => er_down(4) <= '1';
				when "0111" => er_down(5) <= '1';
				when "1000" => er_down(6) <= '1';
				when "1001" => er_down(7) <= '1';
				when others => er_down <= "00000000";
			end case;
		end if;
	end process;
end structural;