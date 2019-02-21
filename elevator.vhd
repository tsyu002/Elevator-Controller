-- EE270 Project
-- Main
-- 

library ieee;
use ieee.std_logic_1164.all;
entity elevator is
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
end elevator;

architecture structural of elevator is
	component floor_select is
		port( s:  in std_logic_vector(3 downto 0);   -- Switch Inputs
			  p:  in std_logic;						 -- Pushbutton Input
			  fs: out std_logic_vector(8 downto 0)); -- Floor Select Output
	end component;
	
	component elevator_request is
		port( s:       in std_logic_vector(3 downto 0);   -- Switch Inputs
			  p_up:    in std_logic;					  -- Pushbutton Up Input
			  p_down:  in std_logic;			          -- Pushbutton Down Input
			  er_up:   out std_logic_vector(7 downto 0);  -- Elevator Up Request Output
			  er_down: out std_logic_vector(7 downto 0)); -- Elevator Down Request Output
	end component;
	
	component storage_circuit is
		port( fs:          in std_logic_vector(8 downto 0);   -- Floor Select Inputs
		      er_up:       in std_logic_vector(7 downto 0);   -- Elevator Up Request Inputs
		      er_down:     in std_logic_vector(7 downto 0);   -- Elevator Down Request Inputs
		      fr:          in std_logic_vector(3 downto 0);   -- Floor Select Reset Inputs
		      upr:         in std_logic;                      -- Up Direction Reset Input
		      downr:       in std_logic;                      -- Down Direction Reset Input
		      reset:       in std_logic;                      --reset
		      fs_out:      out std_logic_vector(8 downto 0);  -- Floor Select Outputs
		      er_up_out:   out std_logic_vector(7 downto 0);  -- Elevator Up Request Outputs
		      er_down_out: out std_logic_vector(7 downto 0)); -- Elevator Down Request Outputs
	end component;
	
	component control is
		port( reset: in std_logic;
		      clock: in std_logic;
			  UR: in std_logic_vector(7 downto 0);
			  DR: in std_logic_vector(7 downto 0);
			  FS: in std_logic_vector(8 downto 0);
			  stop: in std_logic;
			  up: out std_logic;
			  down: out std_logic;
			  CF: out std_logic_vector(3 downto 0));
	end component;
	
	component clock_div is
	   port ( clk_100mhz : in STD_LOGIC;
             rst : in STD_LOGIC;
             clk_1hz : out STD_LOGIC;
             clk_100hz : out STD_LOGIC);
    end component;         
    
    component seven_segment is
        Port ( floor: in std_logic_vector(3 downto 0);  -- Floor input
               clock: in std_logic;
               anode: out std_logic_vector(3 downto 0);                                -- Digit Driver
               cathode: out std_logic_vector(6 downto 0)); -- Individual LED Driver
    end component;
	
	signal fs_int: std_logic_vector(8 downto 0);
	signal er_up_int: std_logic_vector(7 downto 0);
	signal er_down_int: std_logic_vector(7 downto 0);
	signal fs_int2: std_logic_vector(8 downto 0);
	signal er_up_int2: std_logic_vector(7 downto 0);
	signal er_down_int2: std_logic_vector(7 downto 0);
	signal cf_int: std_logic_vector (3 downto 0);
	signal clk_1hz_int: std_logic;
	signal clk_100hz_int: std_logic;
begin
	fs: floor_select port map(s => sw_fs, p => push_fs, fs => fs_int);
	er: elevator_request port map(s => sw_er, p_up => push_er_up, p_down => push_er_down, er_up => er_up_int, er_down => er_down_int);
	sc: storage_circuit port map(fs => fs_int, er_up => er_up_int, er_down => er_down_int, fr => cf_int, upr => up, downr => down, reset => push_reset, fs_out => fs_int2, er_up_out => er_up_int2, er_down_out => er_down_int2);
	c: control port map(reset => push_reset, clock => clk_1hz_int, UR => er_up_int2, DR => er_down_int2, FS => fs_int2, stop => push_stop, up => up, down => down, CF => cf_int);
    clk: clock_div port map(clk_100mhz => clock, rst => push_reset, clk_1hz => clk_1hz_int, clk_100hz => clk_100hz_int);
    ss: seven_segment port map(floor => cf_int, clock => clk_100hz_int, anode => anode, cathode => cathode);
end structural;