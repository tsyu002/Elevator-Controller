-- EE270 Project
-- Floor Select Decoder
-- Description: Use 4 toggle switches + 1 pushbutton to select a floor from inside the elevator

library ieee;
use ieee.std_logic_1164.all;
entity floor_select is
	port( s:  in std_logic_vector(3 downto 0);   -- Switch Inputs
		  p:  in std_logic;						 -- Pushbutton Input
		  fs: out std_logic_vector(8 downto 0)); -- Floor Select Output
end floor_select;

architecture structural of floor_select is
begin
	proc: process(p, s) is
	begin
		fs <= "000000000"; -- default output value: no floors are selected
	
		-- If the pushbutton is pressed
		if (p = '1') then
			case s is
				when "0001" => fs(0) <= '1'; -- One of floors 1 through 9
				when "0010" => fs(1) <= '1';
				when "0011" => fs(2) <= '1';
				when "0100" => fs(3) <= '1';
				when "0101" => fs(4) <= '1';
				when "0110" => fs(5) <= '1';
				when "0111" => fs(6) <= '1';
				when "1000" => fs(7) <= '1';
				when "1001" => fs(8) <= '1';
				when others => fs <= "000000000";
			end case;
		end if;
	end process;
end structural;