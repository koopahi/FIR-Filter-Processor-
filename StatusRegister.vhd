LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY StatusRegister IS
   PORT (
      --Cin, 
      Zin, SRload, clk : IN std_logic;
      --Cset, Creset, 
      --Zset, 
      Zreset : IN std_logic;
      --Cout,
      Zout : OUT std_logic
   );
END StatusRegister;

ARCHITECTURE dataflow OF StatusRegister IS
BEGIN

   PROCESS (clk)
   BEGIN
      IF (clk = '1') THEN
         IF (SRload = '1') THEN
         --   Cout <= Cin;
            Zout <= Zin;
         --ELSIF (Cset='1') THEN
         --   Cout <= '1';
         --ELSIF (Creset='1') THEN
         --   Cout <= '0';
         --ELSIF (Zset='1') THEN
         --   Zout <= '1';
         ELSIF (Zreset='1') THEN
            Zout <= '0';
         END IF;
      END IF;
   END PROCESS;

END dataflow;