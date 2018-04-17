LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY InstrunctionRegister IS
   PORT (
      input : IN std_logic_vector (15 DOWNTO 0);
      IRload, clk : IN std_logic;
      output : OUT std_logic_vector (15 DOWNTO 0)
   );
END InstrunctionRegister;

ARCHITECTURE dataflow OF InstrunctionRegister IS
BEGIN

   PROCESS (clk)
   BEGIN
      IF (clk = '1') THEN
         IF (IRload = '1') THEN
            output <= input;
         END IF;
      END IF;
   END PROCESS;

END dataflow;