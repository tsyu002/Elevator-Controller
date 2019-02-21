-- EE270 Project
-- Storage Circuit
-- Description: Store the requests from the two decoders and reset them using certain inputs from the drive circuit

library ieee;
use ieee.std_logic_1164.all;
entity storage_circuit is
	port( fs:          in std_logic_vector(8 downto 0);   -- Floor Select Inputs
		  er_up:       in std_logic_vector(7 downto 0);    -- Elevator Up Request Inputs
		  er_down:     in std_logic_vector(7 downto 0);    -- Elevator Down Request Inputs
		  fr:          in std_logic_vector(3 downto 0);                    -- Floor Select Reset Inputs
		  upr:         in std_logic;                                        -- Up Direction Reset Input
		  downr:       in std_logic;                                        -- Down Direction Reset Input
		  reset:       in std_logic;                                        -- Reset Input
		  fs_out:      out std_logic_vector(8 downto 0) := "000000000";  -- Floor Select Outputs
		  er_up_out:   out std_logic_vector(7 downto 0) := "00000000";   -- Elevator Up Request Outputs
		  er_down_out: out std_logic_vector(7 downto 0) := "00000000");  -- Elevator Down Request Outputs
end storage_circuit;

architecture behavioral of storage_circuit is
begin
    process(fs, er_up, er_down, reset)
    begin
        if (reset = '1') then
            fs_out <= "000000000";
            er_up_out <= "00000000";
            er_down_out <= "00000000";
        else
            -- Set the Floor Select Output when that floor is selected
            -- Reset the Floor Select Output when the drive circuit verifies that floor has been reached
            if (fs(0) = '1') then
                fs_out(0) <= '1';
            elsif (fr = "0001") then
                fs_out(0) <= '0';
            end if;
            if (fs(1) = '1') then
                fs_out(1) <= '1';
            elsif (fr = "0010") then
                fs_out(1) <= '0';
            end if;
            if (fs(2) = '1') then
                fs_out(2) <= '1';
            elsif (fr = "0011") then
                fs_out(2) <= '0';
            end if;        
            if (fs(3) = '1') then
                fs_out(3) <= '1';
            elsif (fr = "0100") then
                fs_out(3) <= '0';
            end if;
            if (fs(4) = '1') then
                fs_out(4) <= '1';
            elsif (fr = "0101") then
                fs_out(4) <= '0';
            end if;
            if (fs(5) = '1') then
                fs_out(5) <= '1';
            elsif (fr = "0110") then
                fs_out(5) <= '0';
            end if;
            if (fs(6) = '1') then
                fs_out(6) <= '1';
            elsif (fr = "0111") then
                fs_out(6) <= '0';
            end if;
            if (fs(7) = '1') then
                fs_out(7) <= '1';
            elsif (fr = "1000") then
                fs_out(7) <= '0';
            end if;
            if (fs(8) = '1') then
                fs_out(8) <= '1';
            elsif (fr = "1001") then
                fs_out(8) <= '0';
            end if;        
            
            -- Set the Elevator Up Request Output when an up request is made from that floor
            -- Reset the Elevator Up Request Output when the drive circuit verifes that floor has been reached while going up
            if (er_up(0) = '1') then
                er_up_out(0) <= '1';
            elsif (fr = "0001" and upr = '1') then
                er_up_out(0) <= '0';
            end if;
            if (er_up(1) = '1') then
                er_up_out(1) <= '1';
            elsif (fr = "0010" and upr = '1') then
                er_up_out(1) <= '0';
            end if;
            if (er_up(2) = '1') then
                er_up_out(2) <= '1';
            elsif (fr = "0011" and upr = '1') then
                er_up_out(2) <= '0';
            end if;
            if (er_up(3) = '1') then
                er_up_out(3) <= '1';
            elsif (fr = "0100" and upr = '1') then
                er_up_out(3) <= '0';
            end if;
            if (er_up(4) = '1') then
                er_up_out(4) <= '1';
            elsif (fr = "0101" and upr = '1') then
                er_up_out(4) <= '0';
            end if;
            if (er_up(5) = '1') then
                er_up_out(5) <= '1';
            elsif (fr = "0110" and upr = '1') then
                er_up_out(5) <= '0';
            end if;
            if (er_up(6) = '1') then
                er_up_out(6) <= '1';
            elsif (fr = "0111" and upr = '1') then
                er_up_out(6) <= '0';
            end if;
            if (er_up(7) = '1') then
                er_up_out(7) <= '1';
            elsif (fr = "1000"and upr = '1') then
                er_up_out(7) <= '0';
            end if;                                                                                    
        
            -- Set the Elevator Down Request Output when a down request is made from that floor
            -- Reset the Elevator Down Request Output when the drive circuit verifes that floor has been reached while going down
            if (er_down(0) = '1') then
                er_down_out(0) <= '1';
            elsif (fr = "0010" and downr = '1') then
                er_down_out(0) <= '0';
            end if;
            if (er_down(1) = '1') then
                er_down_out(1) <= '1';
            elsif (fr = "0011" and downr = '1') then
                er_down_out(1) <= '0';
            end if;
            if (er_down(2) = '1') then
                er_down_out(2) <= '1';
            elsif (fr = "0100" and downr = '1') then
                er_down_out(2) <= '0';
            end if;
            if (er_down(3) = '1') then
                er_down_out(3) <= '1';
            elsif (fr = "0101" and downr = '1') then
                er_down_out(3) <= '0';
            end if;
            if (er_down(4) = '1') then
                er_down_out(4) <= '1';
            elsif (fr = "0110" and downr = '1') then
                er_down_out(4) <= '0';
            end if;
            if (er_down(5) = '1') then
                er_down_out(5) <= '1';
            elsif (fr = "0111" and downr = '1') then
                er_down_out(5) <= '0';
            end if;
            if (er_down(6) = '1') then
                er_down_out(6) <= '1';
            elsif (fr = "1000" and downr = '1') then
                er_down_out(6) <= '0';
            end if;
            if (er_down(7) = '1') then
                er_down_out(7) <= '1';
            elsif (fr = "1001" and downr = '1') then
                er_down_out(7) <= '0';
            end if;           
        end if;                 
    end process;   
end behavioral;