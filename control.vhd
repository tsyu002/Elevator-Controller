--EE270 Project
-- Description: State Machine

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity control is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC; --Clock is 100Hz
           UR : in STD_LOGIC_VECTOR (7 downto 0); --up request
           DR: in STD_LOGIC_VECTOR (7 downto 0); --down request
           FS : in STD_LOGIC_VECTOR (8 downto 0); --floor select
           stop : in STD_LOGIC; --stop feature
           up : out STD_LOGIC; --elevator is going up
           down : out STD_LOGIC; --elevator is going down
           CF : out STD_LOGIC_VECTOR (3 downto 0)); --current floor
end control;

architecture Behavioral of control is
    --states (F1 and F9 are floor number. TP=transition period between floors ie TP12 is for floors 1 to 2. F#UP=Passing that floor as elevator goes up. F#DOWN=Passing that floor as elevator goes down
    type state_type is (F1, TP12, F2UP, F2IDLE, TP23, F3UP, F3IDLE, TP34, F4UP, F4IDLE, TP45, F5UP, F5IDLE, TP56, F6UP, F6IDLE, TP67, F7UP, F7IDLE, TP78, F8UP, F8IDLE, TP89, F9, TP98, F8DOWN, TP87, F7DOWN, TP76, F6DOWN, TP65, F5DOWN, TP54, F4DOWN, TP43, F3DOWN, TP32, F2DOWN, TP21);
    signal state_reg, next_state : state_type;
 
    
begin
    --reset feature
    process (clock, reset)
    begin
        if (reset = '1')
            then state_reg <= F1;
        elsif (clock'event and clock='1') then
            state_reg <= next_state;
        end if;
    end process;
    
    --INTERNAL LOGIC STATE MACHINE
    process (state_reg, UR, DR, FS, stop)
    begin
        case state_reg is
    --STATES WHEN GOING UP AND IDLE STATES
            when F1 =>
                if (stop = '1') then --stop at floor 1
                    next_state <= F1;
                elsif (not FS(8 downto 1) /= "11111111" or not UR /= "11111111" or not DR /= "11111111") then --Elevator is traveling up due to request to go up, down, or request from a higher floor
                    next_state <= TP12; --Elevator traveling from floor 1 to 2
                else
                    next_state <= F1;
                end if;
            when TP12 => --Elevator traveling from floor 1 to 2
                if (stop = '1') then  --stop requested, stop at next floor which here is floor 2 with no direction of movement pending
                    next_state <= F2IDLE;
                elsif (FS(1)= '1' or UR(1)= '1') then --Elevator has been requestd from 2nd floor or a request from inside elevator to go up has been made
                    next_state <= F2UP; --Floor state 2 as elevator travels up
                elsif (FS(1)= '0' and UR(1)= '0' and DR(0)= '0') then
                    next_state <= TP23;
                elsif (FS(8 downto 1)= "00000000" and UR(7 downto 1)="0000000" and DR(0)= '1') then --Down request is made. No up request or requests from higher floors
                    next_state <= F2IDLE;
                end if;
            when F2UP => --Elevator traveling up
                if (stop = '1') then
                    next_state <= F2IDLE; --stop requested therefore elevator stoping at floor 2
                elsif (FS (8 downto 2) = "0000000" and UR(7 downto 2) = "000000") then --No pending requests
                    next_state <= F2IDLE; 
                else
                    next_state <= TP23; --Continue traveling up
                end if;
            when F2IDLE =>
                if (stop ='1') then
                    next_state<= F2IDLE;
                elsif(FS(0)='0' and FS(8 downto 2)="0000000" and UR(0)='0' and UR(7 downto 2)="000000" and DR(7 downto 1)="0000000")then
                    next_state<= F2IDLE;
                elsif(FS(0)='1' or UR(0)='1') then
                    next_state<=TP21;
                elsif(not FS(8 downto 2)/="1111111" or not UR(7 downto 2)/="111111" or not DR(7 downto 1)/="1111111") then
                    next_state<=TP23;
                end if;
           
           
            when TP23 =>
                if (stop = '1') then
                    next_state <= F3IDLE;
                elsif (FS(2) = '1' or UR(2)= '1') then
                    next_state <= F3UP;
                elsif (FS(2)= '0' and UR(2)= '0' and DR(1)='0') then
                    next_state <= TP34;
                elsif (FS(8 downto 2)= "0000000" and UR(7 downto 2)= "000000" and DR(1)= '1') then
                    next_state <= F3IDLE;
                end if;
            when F3UP =>
                if (stop= '1') then
                    next_state <= F3IDLE;
                elsif (FS (8 downto 3) = "000000" and UR(7 downto 3)="00000") then
                    next_state <= F3IDLE;
                else
                    next_state <= TP34;
                end if;
            when F3IDLE =>
                if (stop ='1') then
                   next_state<= F3IDLE;
                elsif(FS(1 downto 0)="00" and FS(8 downto 3)="000000" and UR(1 downto 0)="00" and UR(7 downto 3)="00000" and DR(0)='0' and DR(7 downto 2)="000000") then
                   next_state<= F3IDLE;
                elsif(not FS(1 downto 0)/="11" or not UR(1 downto 0)/="11" or not DR(0)/='1') then
                   next_state<=TP32;
                elsif(not FS(8 downto 3)/="111111" or not UR(7 downto 3)/="11111" or not DR(7 downto 2)/="111111") then
                   next_state<=TP34;
                end if;
                
                
           when TP34 =>
               if (stop = '1') then
                   next_state <= F4IDLE;
               elsif (FS(3)='1' or UR(3)='1') then
                   next_state <= F4UP;
               elsif (FS(3)='0' and UR(3)='0' and DR(2)='0') then
                   next_state <= TP45;
               elsif (FS(8 downto 3)="000000" and UR(7 downto 3)="00000" and DR(2)='1') then
                   next_state<= F4IDLE;
               end if;
           when F4UP =>
               if (stop= '1') then
                  next_state <= F4IDLE;
               elsif (FS (8 downto 4) = "00000" and UR(7 downto 4)="0000") then
                  next_state <= F4IDLE;
               else
                  next_state <= TP45;
               end if;
           when F4IDLE =>
               if (stop ='1') then
                  next_state<= F4IDLE;
               elsif(FS(2 downto 0)="000" and FS(8 downto 4)="00000" and UR(2 downto 0)="000" and UR(7 downto 4)="0000" and DR(1 downto 0)="00" and DR(7 downto 3)="00000") then
                  next_state<= F4IDLE;
               elsif(not FS(2 downto 0)/="111" or not UR(2 downto 0)/="111" or not DR(1 downto 0)/="11") then
                  next_state<=TP43;
               elsif(not FS(8 downto 4)/="11111" or not UR(7 downto 4)/="1111" or not DR(7 downto 3)/="11111") then
                  next_state<=TP45;
               end if;
               
           when TP45 =>
               if (stop = '1') then
                  next_state <= F5IDLE;
               elsif (FS(4)='1' or UR(4)='1')then
                  next_state <= F5UP;
               elsif (FS(4)='0' and UR(4)='0' and DR(3)='0') then
                  next_state <= TP56;
               elsif (FS(8 downto 4)="00000" and UR(7 downto 4)="0000" and DR(3)='1') then
                  next_state<= F5IDLE;
               end if;
           when F5UP =>
               if (stop= '1') then
                  next_state <= F5IDLE;
               elsif (FS (8 downto 5) = "0000" and UR(7 downto 5)="000") then
                  next_state <= F5IDLE;
               else
                  next_state <= TP56;
               end if;
           when F5IDLE =>
               if (stop ='1')then
                  next_state<= F5IDLE;
               elsif(FS(3 downto 0)="0000" and FS(8 downto 5)="0000" and UR(3 downto 0)="0000" and UR(7 downto 5)="000" and DR(2 downto 0)="000" and DR(7 downto 4)="0000") then
                  next_state<= F5IDLE;
               elsif(not FS(3 downto 0)/="1111" or not UR(3 downto 0)/="1111" or not DR(2 downto 0)/="111") then
                  next_state<=TP54;
               elsif(not FS(8 downto 5)/="1111" or not UR(7 downto 5)/="111" or not DR(7 downto 4)/="1111") then
                  next_state<=TP56;
               end if;           
              
           when TP56 =>
               if (stop = '1')then
                  next_state <= F6IDLE;
               elsif (FS(5)='1' or UR(5)='1')then
                  next_state <= F6UP;
               elsif (FS(5)='0' and UR(5)='0' and DR(4)='0')then
                  next_state <= TP67;
               elsif (FS(8 downto 5)="0000" and UR(7 downto 5)="000" and DR(4)='1')then
                  next_state<= F6IDLE;
               end if;
           when F6UP =>
               if (stop= '1')then
                  next_state <= F6IDLE;
               elsif (FS (8 downto 6) = "000" and UR(7 downto 6)="00")then
                  next_state <= F6IDLE;
               else
                  next_state <= TP67;
               end if;
           when F6IDLE =>
               if (stop ='1')then
                  next_state<= F6IDLE;
               elsif(FS(4 downto 0)="00000" and FS(8 downto 6)="000" and UR(4 downto 0)="00000" and UR(7 downto 6)="00" and DR(3 downto 0)="0000" and DR(7 downto 5)="000") then
                  next_state<= F6IDLE;
               elsif(not FS(4 downto 0)/="11111" or not UR(4 downto 0)/="11111" or not DR(3 downto 0)/="1111") then
                  next_state<=TP65;
               elsif(not FS(8 downto 6)/="111" or not UR(7 downto 6)/="11" or not DR(7 downto 5)/="111") then
                  next_state<=TP67;
               end if;                
         
           when TP67 =>
               if (stop = '1') then
                  next_state <= F7IDLE;
               elsif (FS(6)='1' or UR(6)='1') then
                  next_state <= F7UP;
               elsif (FS(6)='0' and UR(6)='0' and DR(5)='0') then
                  next_state <= TP78;
               elsif (FS(8 downto 6)="000" and UR(7 downto 6)="00" and DR(5)='1') then
                  next_state<= F7IDLE;
               end if;
           when F7UP =>
               if (stop= '1') then
                  next_state <= F7IDLE;
               elsif (FS (8 downto 7) = "00" and UR(7)='0') then
                  next_state <= F7IDLE;
               else
                  next_state <= TP78;
               end if;
           when F7IDLE =>
               if (stop ='1') then
                  next_state<= F7IDLE;
               elsif(FS(5 downto 0)="000000" and FS(8 downto 7)="00" and UR(5 downto 0)="000000" and UR(7)='0' and DR(4 downto 0)="00000" and DR(7 downto 6)="00") then
                  next_state<= F7IDLE;
               elsif(not FS(5 downto 0)/="111111" or not UR(5 downto 0)/="111111" or not DR(4 downto 0)/="11111") then
                  next_state<=TP76;
               elsif(not FS(8 downto 7)/="11" or not UR(7)/='1' or not DR(7 downto 6)/="11") then
                  next_state<=TP78;
               end if;             
--Fix the UR vectors. Decrement UR by 1. ie above should be UR(7 downto 6) and UR(5)         
           
           when TP78=>
               if (stop = '1') then
                  next_state <= F8IDLE;
               elsif (FS(7)='1' or UR(7)='1') then
                  next_state <= F8UP;
               elsif (FS(7)='0' and UR(7)='0' and DR(6)='0') then
                  next_state <= TP89;
               elsif (FS(8 downto 7)="00" and UR(7)='0' and DR(6)='1') then
                  next_state<= F8IDLE;
               end if;
          when F8UP =>
               if (stop= '1') then
                  next_state <= F8IDLE;
               elsif (FS (8) = '0') then
                  next_state <= F8IDLE;
               else
                  next_state <= TP89;
               end if;
          when F8IDLE =>
               if (stop ='1') then
                  next_state<= F8IDLE;
               elsif(FS(6 downto 0)="0000000" and FS(8)='0' and UR(6 downto 0)="0000000" and DR(5 downto 0)="000000" and DR(7)='0') then
                  next_state<= F8IDLE;
               elsif(not FS(6 downto 0)/="1111111" or not UR(6 downto 0)/="1111111" or not DR(5 downto 0)/="111111") then
                  next_state<=TP87;
               elsif(FS(8)='1' or DR(7)='1') then
                  next_state<=TP89;
               end if;             
          
          when TP89 =>
               next_state<= F9;
          
--WHEN ELEVATOR IS GOING DOWN
    --FS and DR Vectors decrementing as traveling down and
          when F9 =>
               if (FS(7 downto 0)= "00000000" and UR(7 downto 0)="00000000" and DR(6 downto 0)="0000000") then --No pending requests so elevator stays at floor 9
                   next_state<= F9;
               elsif (not FS(7 downto 0)/= "11111111" or not UR(7 downto 0)/="11111111" or not DR(7 downto 0)="11111111") then --Request for elevator from any floor or to go up or down from inside elevator has been made
                   next_state<= TP98; --Elevator traveling from floor 9 to 8
               end if;
          when TP98 =>
               if (stop='1') then --Stop requested while traveling from floor 9 to 8
                   next_state<= F8IDLE; --Elevator stops at floor 8 and is idle
               elsif (FS(7 downto 0)= "00000000" and DR(6 downto 0)="0000000" and UR(7)='1') then --No request for elevator from lower floor down request made. Pending up request
                   next_state<= F8IDLE; --Elevator remains at floor 8 and is idle
               elsif (FS(7)='1' or DR(6)='1') then --Request for elevator from floor 8 or down requst pending
                   next_state<= F8DOWN; --Elevator to move down
               elsif (FS(7)='0' and DR(6)='0') then --No new requests
                   next_state<= TP87;
               end if;
          when F8DOWN => --Elevator on floor 8 and traveling down
               if (stop='1') then --Stop request made
                   next_state<= F8IDLE; --Elevator remains at floor 8 and is idle
               elsif(FS(6 downto 0)="0000000" and DR(5 downto 0)="000000") then --No pending requests
                   next_state<= F8IDLE; ----Elevator remains at floor 8 is idle
               elsif (not FS(6 downto 0) /="1111111" or not DR(5 downto 0)/="111111") then --Request for elevator from lower floors or request to go down made
                   next_state<= TP87; --Elevator continues traveling down
               end if;
             
         when TP87 =>
              if (stop='1') then
                   next_state<= F7IDLE;
              elsif(FS(6 downto 0)="0000000" and DR(5 downto 0)="000000" and UR(6)='1') then
                   next_state<= F7IDLE;
              elsif(FS(6)='1' or DR(5)='1') then
                   next_state<= F7DOWN;
              elsif(FS(6)='0' and DR(5)='0' and UR(6)='0')  then
                   next_state<= TP76;
              end if;
         when F7DOWN =>
              if (stop='1') then
                   next_state<= F7IDLE;
              elsif(FS(5 downto 0)="000000" and DR(4 downto 0)="00000") then
                   next_state<= F7IDLE;
              elsif(not FS(5 downto 0) /="111111" or not DR(4 downto 0)/="11111") then
                   next_state<= TP76;
              end if;
         
         when TP76=>
              if (stop='1') then
                   next_state<= F6IDLE;
              elsif(FS(5 downto 0)="000000" and DR(4 downto 0)="00000" and UR(5)='1') then
                   next_state<= F6IDLE;
              elsif(FS(5)='1' or DR(4)='1') then
                   next_state<= F6DOWN;
              elsif(FS(5)='0' and DR(4)='0' and UR(5)='0') then
                   next_state<= TP65;
              end if;
          when F6DOWN=>
              if (stop='1') then
                   next_state<= F6IDLE;
              elsif(FS(4 downto 0)="00000" and DR(3 downto 0)="0000") then
                   next_state<= F6IDLE;
              elsif(not FS(4 downto 0) /="11111" or not DR(3 downto 0)/="1111") then
                   next_state<= TP65;
              end if;
             
         when TP65=>
              if (stop='1') then
                   next_state<= F5IDLE;
              elsif(FS(4 downto 0)="00000" and DR(3 downto 0)="0000" and UR(4)='1') then
                   next_state<= F5IDLE;
              elsif(FS(4)='1' or DR(3)='1') then
                   next_state<= F5DOWN;
              elsif(FS(4)='0' and DR(3)='0' and UR(4)='0') then
                   next_state<= TP54;
              end if;
         when F5DOWN=>
              if (stop='1') then
                   next_state<= F5IDLE;
              elsif(FS(3 downto 0)="0000" and DR(2 downto 0)="000") then
                   next_state<= F5IDLE;
              elsif(not FS(3 downto 0) /="1111" or not DR(2 downto 0)/="111") then
                   next_state<= TP54;
              end if;

         when TP54=>
              if (stop='1') then
                   next_state<= F4IDLE;
              elsif(FS(3 downto 0)="0000" and DR(2 downto 0)="000" and UR(3)='1') then
                   next_state<= F4IDLE;
              elsif(FS(3)='1' or DR(2)='1') then
                   next_state<= F4DOWN;
              elsif(FS(3)='0' and DR(2)='0' and UR(3)='0') then
                   next_state<= TP43;
              end if;
         when F4DOWN=>
              if (stop='1') then
                   next_state<= F4IDLE;
              elsif(FS(2 downto 0)="000" and DR(1 downto 0)="00") then
                   next_state<= F4IDLE;
              elsif(not FS(2 downto 0) /="111" or not DR(1 downto 0)/="11") then
                   next_state<= TP43;
              end if;
             
         when TP43=>
              if (stop='1') then
                   next_state<= F3IDLE;
              elsif(FS(2 downto 0)="000" and DR(1 downto 0)="00" and UR(2)='1') then
                   next_state<= F3IDLE;
              elsif(FS(2)='1' or DR(1)='1') then
                   next_state<= F3DOWN;
              elsif(FS(2)='0' and DR(1)='0' and UR(2)='0') then
                   next_state<= TP32;
              end if;
         when F3DOWN=>
              if (stop='1') then
                   next_state<= F3IDLE;
              elsif(FS(1 downto 0)="00" and DR(0)='0') then
                   next_state<= F3IDLE;
              elsif(not FS(1 downto 0) /="11" or not DR(0)/='1') then
                   next_state<= TP32;
              end if;

         when TP32=>
              if (stop='1') then
                   next_state<= F2IDLE;
              elsif(FS(1 downto 0)="00" and DR(0)='0' and UR(1)='1') then
                   next_state<= F2IDLE;
              elsif(FS(1)='1' or DR(0)='1') then
                   next_state<= F2DOWN;
              elsif(FS(1)='0' and DR(0)='0' and UR(1)='0') then
                   next_state<= TP21;
              end if;
         when F2DOWN=>
              if(stop='1') then
                   next_state<=F2IDLE;
              elsif(FS(0)='0') then
                   next_state<=F2IDLE;
              elsif(FS(0)='1') then
                   next_state<=TP21;
              end if;
         
         when TP21=>
              next_state<=F1;
              
    end case;
 end process;
  
  
  --OUTPUT LOGIC WHEN ON FLOOR 1 OR 9 OR TRAVELING BETWEEN FLOORS
process (state_reg, UR, DR, FS, stop)         
   begin
      case state_reg is 
        when F1=>
           up<= '1'; --Send up signal
           down<= '1'; --Send down signal
           CF<="0001"; --Current floor is 1
        when TP12 =>
           up<= '1'; --Send up signal
           down<= '0'; --Don't send down signal
           CF<="0001"; --Current floor is 1
     
        when F2UP | TP23=>
           up<= '1'; --Send up signal
           down<= '0'; --Don't send down signal
           CF<= "0010"; --Current floor is 2
     
        when F3UP | TP34=>
           up<= '1';
           down<='0';
           CF<= "0011";
   
        when F4UP | TP45=>
           up<='1';
           down<='0';
           CF<= "0100";
          
        when F5UP | TP56=>
           up<= '1';
           down<= '0';
           CF<= "0101";
         
        when F6UP | TP67=>
           up<= '1';
           down<='0';
           CF<= "0110";
           
        when F7UP | TP78=>
           up<= '1';
           down<= '0';
           CF<= "0111";
           
        when F8UP | TP89=>
           up<= '1';
           down<= '0';
           CF<= "1000";
          
        when F9=>
           up<='1';
           down<='1';
           CF<= "1001";
        when TP98=>
           down<= '1';
           up<= '0';
           CF<= "1001";
          
        when F8DOWN | TP87=>
           down<= '1';
           up<= '0';
           CF<= "1000";
        
        when F7DOWN | TP76=>
           down<= '1';
           up<= '0';
           CF<= "0111";
           
        when F6DOWN | TP65=>
           down<= '1';
           up<='0';
           CF<= "0110";
           
        when F5DOWN | TP54=>
           down<= '1';
           up<= '0';
           CF<= "0101";
           
        when F4DOWN | TP43=>
           down<= '1';
           up<= '0';
           CF<= "0100";
          
        when F3DOWN | TP32=>
           down<= '1';
           up<= '0';
           CF<= "0011";
          
        when F2DOWN | TP21=>
           down<= '1';
           up<= '0';
           CF<= "0010";
           
        
  --OUTPUT LOGIC WHEN IN IDLE STATES      
        when F2IDLE=>
           down<= '1';  --Send down signal
           up<= '1'; --Send up signal
           CF<="0010"; --Current floor is 2
        when F3IDLE =>
           down<= '1'; --Send down signal
           up<= '1'; --Send up signal
           CF<="0011"; --Current floor is 3
        when F4IDLE =>
           down<= '1';
           up<= '1';
           CF<="0100";
        when F5IDLE =>
           down<= '1';
           up<= '1';
           CF<="0101";
        when F6IDLE =>
           down<= '1';
           up<= '1';
           CF<="0110";
        when F7IDLE =>
           down<= '1';
           up<= '1';
           CF<="0111";
        when F8IDLE =>
           down<= '1';
           up<= '1';
           CF<="1000";
    end case;
 end process;

end Behavioral;
