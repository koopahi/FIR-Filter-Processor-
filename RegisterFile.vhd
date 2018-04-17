LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;  
USE ieee.std_logic_unsigned.ALL;

ENTITY Decoder IS
   PORT (
      input  : in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(0 to 15)
   );
END Decoder;

ARCHITECTURE dataflow OF Decoder IS
BEGIN
   PROCESS (input)
   BEGIN
     output<=(OTHERS=>'0');
     output(CONV_INTEGER(input))<='1';
   END PROCESS;
END dataflow;
-------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY RegisterFile IS
   PORT (
      input : IN std_logic_vector (15 DOWNTO 0);
      clk : IN std_logic;
      Laddress, Raddress : IN std_logic_vector (3 DOWNTO 0);
      RFLwrite, RFHwrite : IN std_logic;
      Lout, Rout : OUT std_logic_vector (15 DOWNTO 0)
   );
END RegisterFile;

ARCHITECTURE dataflow OF RegisterFile IS
   COMPONENT dec
      PORT (
         input : IN std_logic_vector (3 DOWNTO 0);
         output : OUT std_logic_vector (0 TO 15)
      );
   END COMPONENT;
   FOR ALL : dec USE ENTITY WORK.decoder (dataflow);

   TYPE memType IS ARRAY (0 TO 15) OF std_logic_vector (15 DOWNTO 0);

   SIGNAL MemoryFile : memType;
   SIGNAL Ldec, Rdec : std_logic_vector (0 TO 15);

BEGIN
   dec1 : dec PORT MAP (Laddress, Ldec);
   dec2 : dec PORT MAP (Raddress, Rdec);

   g : FOR i IN 0 TO 15 GENERATE
      Lout <= MemoryFile (i) WHEN (Ldec (i)='1') ELSE (OTHERS=>'Z');
      Rout <= MemoryFile (i) WHEN (Rdec (i)='1') ELSE (OTHERS=>'Z');
   END GENERATE; 

   PROCESS (clk)
   BEGIN
      IF (clk = '1') THEN
         IF (RFLwrite = '1') THEN
            MemoryFile (CONV_INTEGER (Laddress)) (7 DOWNTO 0) <= input (7 DOWNTO 0);
         END IF;
         IF (RFHwrite = '1') THEN
            MemoryFile (CONV_INTEGER (Laddress)) (15 DOWNTO 8) <= input (15 DOWNTO 8);
         END IF;
      END IF;
   END PROCESS;

END dataflow;