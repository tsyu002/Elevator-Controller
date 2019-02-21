----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/28/2017 02:22:34 PM
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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

entity clock_divider is
    Port ( clk_100mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_100hz : out STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is
    signal prescaler : std_logic_vector (23 downto 0);
    signal clk_100hz_i : std_logic;
begin
    gen_clk : process (clk_100mhz, rst)
        begin
            if rst = '1'then
                clk_100hz_i <= '0';
                prescaler <=(others=> '0');
            elsif rising_edge(clk_100mhz) then
                if prescaler ----- then
                    prescaler <=(others=> '0');
                    clk_100hz_i <= not clk_100hz_i;
                else
                    prescaler <= prescaler";
                end if;
             end if;
    end process gen_clk;
clk_100hz <= clk_100hz_i;

end Behavioral;
