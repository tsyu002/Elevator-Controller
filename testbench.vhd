----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/30/2017 04:00:03 PM
-- Design Name: 
-- Module Name: testbench - Behavioral
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
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity elevator_tb is
end elevator_tb;

architecture arch of elevator_tb is
component elevator is
	port( sw_fs:        in std_logic_vector(3 downto 0);
      sw_er:        in std_logic_vector(3 downto 0);
      push_fs:      in std_logic;
      push_er_up:   in std_logic;
      push_er_down: in std_logic;
      push_stop:    in std_logic;
      push_reset:   in std_logic;
      up:           inout std_logic;
      down:         inout std_logic;
      clock:        in std_logic;
      anode:        out std_logic_vector(3 downto 0);
      cathode:      out std_logic_vector(6 downto 0));
end component;
      
  constant T: time := 10ns;
  signal sw_fs: std_logic_vector(3 downto 0);
  signal sw_er: std_logic_vector(3 downto 0);
  signal push_fs: std_logic;
  signal push_er_up: std_logic;
  signal push_er_down: std_logic;
  signal push_stop: std_logic;
  signal push_reset: std_logic;
  signal up: std_logic;
  signal down: std_logic;
  signal clock: std_logic;
  signal anode: std_logic_vector(3 downto 0);
  signal cathode: std_logic_vector(6 downto 0);

begin

  uut: elevator
        port map (         sw_fs        => sw_fs,
                           sw_er        => sw_er,
                           push_fs      => push_fs,
                           push_er_up   => push_er_up,
                           push_er_down => push_er_down,
                           push_stop    => push_stop,
                           push_reset   => push_reset,
                           up           => up,
                           down         => down,
                           clock        => clock,
                           anode        => anode,
                           cathode      => cathode );
  
  process
  begin
    clock<= '0';
    wait for T/2;
    clock<= '1';
    wait for T/2;
  end process;
  
  stimulus: process
  begin
  --Initialize signals
     sw_fs<= "0000";
     sw_er<= "0000";
     push_fs<= '0';
     push_er_up<= '0';
     push_er_down<= '0';
     push_stop<= '0';
     push_reset<= '0';
     up<= '1';
     down<= '1';
     anode<= "1111";
     cathode<= "1111111";
     
    -- Test 1: Go to floor 5 from floor 1.
    -- Expectation elevator goes to floor 5
    sw_fs<= "0101";
    push_fs<= '1';
    wait for 6 sec;
   -- wait until cathode = "0010010";
    
    -- Test 2: Up request from floor 2 while elevator is on floor 5
    -- Expectation: Elevator goes to floor 2
    sw_er<= "0010";
    push_er_up<= '1';
    wait for 5 sec;
    --wait until cathode = "0100100";
    
    -- Test 3: Go to floor 9 from floor 2,  Up request from floor 6 after delay
    -- Expecation: Elevator stops at floor 6, then continues to floor 9
    sw_fs<= "1001";
    push_fs<= '1';
    wait for 2 sec;
    sw_er<= "0110";
    push_er_up<= '1';
    wait for 10 sec;
    --wait until cathode = "0011000";
    
    -- Test 4: Down request from floor 3. Up request made from floor 4 after delay
    -- Expectation: Elevator does not stop at floor 4, continues to floor 3, then goes to floor 4
    sw_er<= "0011";
    push_er_down<= '1';
    wait for 2 sec;
    sw_er<= "0100";
    push_er_up<= '1';
    wait for 6 sec;
    --wait until cathode = "0110000";
    --wait until cathode = "0011001";
    
    -- Test 5: Go to floor 8. After delay send stop request. After second delay cancel stop request.
    -- Expectation: Elevator goes to floor 8, but stops at intermediate floor for delay, then resumes travel to floor 8
    sw_fs<= "1000";
    push_fs<= '1';
    wait for 2 sec;
    push_stop<= '1';
    wait for 2 sec;
    push_stop<= '0';
    wait for 2 sec;
    --wait for cathode = "0000000";
   
    -- Test 6: Reset request is sent
    -- Expectation: Elevator goes to floor 1 without stopping
    push_reset<= '1';
    wait for 1 sec;
    --wait until cathode = "1111001";
    
    --wait;
  end process;


end;