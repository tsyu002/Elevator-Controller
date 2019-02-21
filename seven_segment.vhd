-- EE270 Project
-- Seven-Segment Driver
-- Description: Display the elevator floor on the seven-segment display given the bit value of the elevator

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity seven_segment is
    Port ( floor: in std_logic_vector(3 downto 0);  -- Floor input
           clock: in std_logic;
           anode: out std_logic_vector(3 downto 0) := "1111";                                -- Digit Driver
           cathode: out std_logic_vector(6 downto 0) := "1111111"); -- Individual LED Driver
end seven_segment;

architecture dataflow of seven_segment is
signal counter : std_logic_vector(1 downto 0) := "00";
signal anode_int : std_logic;
begin
    process(clock, floor)
    begin
        case floor is
            when "0001" => cathode <= "1111001"; -- Floor 1
            when "0010" => cathode <= "0100100"; -- Floor 2
            when "0011" => cathode <= "0110000"; -- Floor 3
            when "0100" => cathode <= "0011001"; -- Floor 4
            when "0101" => cathode <= "0010010"; -- Floor 5
            when "0110" => cathode <= "0000010"; -- Floor 6
            when "0111" => cathode <= "1111000"; -- Floor 7
            when "1000" => cathode <= "0000000"; -- Floor 8
            when "1001" => cathode <= "0011000"; -- Floor 9
            when others => cathode <= "1111111";  -- Else
        end case;
        if rising_edge(clock) then
            if counter < 4 then
                anode_int <= '1';
                counter <= counter + "1";
            elsif counter = 4 then
                anode_int <= '0';
                counter <= (others => '0');
            end if;
        end if;
    end process;
    anode(3 downto 1) <= "111";
    anode(0) <= anode_int;
end dataflow;
