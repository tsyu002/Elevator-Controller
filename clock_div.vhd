----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2017 03:19:17 PM
-- Design Name: 
-- Module Name: clock_div - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_div is
    Port ( clk_100mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_1hz : out STD_LOGIC;
           clk_100hz : out STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is

signal prescaler : std_logic_vector (25 downto 0);
signal prescaler2: std_logic_vector(18 downto 0);
signal clk_1hz_i : std_logic;
signal clk_100hz_i : std_logic;
begin
    gen_clk : process (clk_100mhz, rst)
        begin
            if rst = '1'then
                clk_1hz_i <= '0';
                prescaler <=(others=> '0');
            elsif rising_edge(clk_100mhz) then
                if prescaler = 50000000 then
                    prescaler <=(others=> '0');
                    clk_1hz_i <= not clk_1hz_i;
                else                  
                    prescaler <= prescaler + "1";
                end if;
                
                if prescaler2 = 500000 then
                    prescaler2 <= (others => '0');
                    clk_100hz_i <= not clk_100hz_i;
                else
                    prescaler2 <= prescaler2 + "1";
                end if;
             end if;
    end process gen_clk;
clk_1hz <= clk_1hz_i;
clk_100hz <= clk_100hz_i;
end Behavioral;
