LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY AddressLogic IS
   PORT (
      PCside, Rside : IN std_logic_vector (15 DOWNTO 0);
      Iside : IN std_logic_vector (7 DOWNTO 0);
      ALout : OUT std_logic_vector (15 DOWNTO 0);
      ResetPC, PCplusI, PCplus1 : IN std_logic;
      --, RplusI,
      Rplus0 : IN std_logic
   );
END AddressLogic;

ARCHITECTURE dataflow OF AddressLogic IS
   CONSTANT one   : std_logic_vector (3 DOWNTO 0) := "1000";
   CONSTANT two   : std_logic_vector (3 DOWNTO 0) := "0100";
   CONSTANT three : std_logic_vector (3 DOWNTO 0) := "0010";
   CONSTANT four  : std_logic_vector (3 DOWNTO 0) := "0001";
   SIGNAL IL : std_logic := Iside(7);

BEGIN

   PROCESS (PCside, Rside, Iside, ResetPC, PCplusI, PCplus1, Rplus0)
      VARIABLE temp : std_logic_vector (3 DOWNTO 0);
   BEGIN
      temp := (ResetPC & PCplusI & PCplus1 & Rplus0 );
      CASE temp IS
         WHEN one  => ALout <= (OTHERS=>'0');
         WHEN two  => ALout <= PCside + (IL&IL&IL&IL&IL&IL&IL&IL&Iside);
         WHEN three => ALout <= PCside + 1;
         --WHEN four  => ALout <= Rside + Iside; For JMA instruction
         WHEN four  => ALout <= Rside; -- For LDA instruction
         WHEN OTHERS => ALout <= PCside;
      END CASE;
   END PROCESS;

END dataflow;
-----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY ProgramCounter IS
   PORT (
      EnablePC : IN std_logic;
      input : IN std_logic_vector (15 DOWNTO 0);
      clk : IN std_logic;
      output : OUT std_logic_vector (15 DOWNTO 0)
   );
END ProgramCounter;

ARCHITECTURE dataflow OF ProgramCounter IS
BEGIN

   PROCESS (clk)
   BEGIN
      IF (clk = '1') THEN
         IF (EnablePC = '1') THEN
            output <= input;
         END IF;
      END IF;
   END PROCESS;

END dataflow;
-----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY AddressingUnit IS
   PORT (
      Rside : IN std_logic_vector (15 DOWNTO 0);
      Iside : IN std_logic_vector (7 DOWNTO 0);
      Address : OUT std_logic_vector (15 DOWNTO 0);
      clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
      --RplusI,
      Rplus0, EnablePC : IN std_logic
   );
END AddressingUnit;

ARCHITECTURE dataflow OF AddressingUnit IS
   COMPONENT pc
      PORT (
         EnablePC : IN std_logic;
         input : IN std_logic_vector (15 DOWNTO 0);
         clk : IN std_logic;
         output : OUT std_logic_vector (15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : pc USE ENTITY WORK.ProgramCounter (dataflow);

   COMPONENT al
      PORT (
         PCside, Rside : IN std_logic_vector (15 DOWNTO 0);
         Iside : IN std_logic_vector (7 DOWNTO 0);
         ALout : OUT std_logic_vector (15 DOWNTO 0);
         ResetPC, PCplusI, PCplus1, Rplus0 : IN std_logic
      );
   END COMPONENT;
 FOR ALL : al USE ENTITY WORK.AddressLogic (dataflow);

 SIGNAL pcout : std_logic_vector (15 DOWNTO 0);
 SIGNAL AddressSignal : std_logic_vector (15 DOWNTO 0);

BEGIN
   Address <= AddressSignal;

   l1 : pc PORT MAP (EnablePC, AddressSignal, clk, pcout);
   l2 : al PORT MAP (pcout, Rside, Iside, AddressSignal, ResetPC, PCplusI, PCplus1, Rplus0);
END dataflow;