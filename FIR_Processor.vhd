LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY FIR_processor IS
   PORT (
      clk : IN std_logic;
      ReadMem, WriteMem : OUT std_logic;
      --, ReadIO, WriteIO : OUT std_logic;
      Databus : inout std_logic_vector (15 DOWNTO 0);
      Addressbus : OUT std_logic_vector (15 DOWNTO 0);
      ExternalReset, memdataready : IN std_logic
   );
END FIR_processor;

ARCHITECTURE dataflow OF FIR_processor IS
   COMPONENT dp
      PORT (
         clk : IN std_logic;
         Databus : inout std_logic_vector (15 DOWNTO 0);
         Addressbus : OUT std_logic_vector (15 DOWNTO 0);
         ResetPC, PCplusI, PCplus1 : IN std_logic;
         --, RplusI, 
         Rplus0, Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
         B15to0, AaddB, AsubB, AmulB, RFLwrite, RFHwrite,
         IRload, SRload : IN std_logic;
         --, Address_on_Databus, 
         ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, 
         RFright_on_OpndBus : IN std_logic;
         Zreset : IN std_logic;
         Instruction : OUT std_logic_vector (15 DOWNTO 0); -----8 OR 16?!
         Zout : OUT std_logic
      );
   END COMPONENT;
   FOR ALL : dp USE ENTITY WORK.DataPath (dataflow);

   COMPONENT ctrl
      PORT (ExternalReset, clk : IN std_logic;
         ResetPC, PCplusI, PCplus1, Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,
         EnablePC, B15to0, AaddB, AsubB, AmulB : OUT std_logic;
         --AcmpB
         RFLwrite, Rplus0 : OUT std_logic;
         RFHwrite, IRload, SRload, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus,
         RFright_on_OpndBus, ReadMem, WriteMem : OUT std_logic;
         --Zset,
         Zreset : OUT std_logic;
         Instruction : IN std_logic_vector (15 DOWNTO 0);
         Zflag, memDataReady: IN std_logic
      );
   END COMPONENT;
   FOR ALL : ctrl USE ENTITY WORK.Controller (dataflow);

   SIGNAL Instruction : std_logic_vector (15 DOWNTO 0);
   signal
      ResetPC, PCplusI, PCplus1, RplusI, Rplus0, Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,
      EnablePC, B15to0, AaddB, AsubB, AmulB,
      RFLwrite, RFHwrite, RFzeroLeft, RFzeroRight, IRload, SRload,
      --Address_on_Databus, 
      ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
      Zflag, Zreset : std_logic; 

BEGIN

   datapath : dp PORT MAP (
      clk, Databus, Addressbus, ResetPC, PCplusI, PCplus1, Rplus0,
      Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
      B15to0, AaddB, AsubB, AmulB, RFLwrite, RFHwrite, IRload,
       SRload, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus,
       RFright_on_OpndBus, Zreset,Instruction, Zflag
      );
           
   controller : ctrl PORT MAP (
      ExternalReset, clk, ResetPC, PCplusI, PCplus1, 
      Rs_on_AddressUnitRSide,Rd_on_AddressUnitRSide, EnablePC, B15to0,
      AaddB, AsubB, AmulB, RFLwrite, Rplus0, RFHwrite, IRload,
      SRload, ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus,
      RFright_on_OpndBus, ReadMem, WriteMem, Zreset, Instruction,
      Zflag, memdataready
      );

END dataflow;