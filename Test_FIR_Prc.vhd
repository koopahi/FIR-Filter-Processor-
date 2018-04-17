LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Test_FIR_Prc IS
END Test_FIR_Prc;

ARCHITECTURE dataflow OF Test_FIR_Prc IS
   COMPONENT cpu 
      PORT (
         clk : IN std_logic;
         ReadMem, WriteMem : OUT std_logic;
         Databus : inout std_logic_vector (15 DOWNTO 0);
         Addressbus : OUT std_logic_vector (15 DOWNTO 0);
         ExternalReset, memdataready : IN std_logic
      );
   END COMPONENT; 
   FOR ALL : cpu USE ENTITY WORK.FIR_Processor (dataflow);
   
   COMPONENT mem
      GENERIC (blocksize : integer := 64; segmentsno : integer := 1);
      PORT (
         clk   : IN  STD_LOGIC;
         readmem : IN  STD_LOGIC;
         writemem : IN  STD_LOGIC;
         addressbus : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
         databus : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
         memdataready : OUT std_logic
      );
   END COMPONENT;
   FOR ALL : mem USE ENTITY WORK.memory (behavioral);

   SIGNAL clk : std_logic := '0';
   SIGNAL ReadMem, WriteMem, ExternalReset, memdataready : std_logic;
   SIGNAL Databus, Addressbus : std_logic_vector (15 DOWNTO 0);
BEGIN

   clk <= not (clk) after 5 ns WHEN now<1000000 ns ELSE clk;
   ExternalReset <= '1', '0' after 27 ns;

   processor : cpu PORT MAP (clk, ReadMem, WriteMem, Databus, Addressbus, ExternalReset, memdataready);
   memory : mem PORT MAP (clk, ReadMem, WriteMem, Addressbus, DataBus, memdataready);

END dataflow;
