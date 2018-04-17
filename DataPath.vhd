LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY DataPath IS
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
END DataPath;

ARCHITECTURE dataflow OF DataPath IS
   COMPONENT AU
      PORT (
         Rside : IN std_logic_vector (15 DOWNTO 0);
         Iside : IN std_logic_vector (7 DOWNTO 0);
         Address : OUT std_logic_vector (15 DOWNTO 0);
         clk, ResetPC, PCplusI, PCplus1, Rplus0, EnablePC : IN std_logic
      );
   END COMPONENT;
   FOR ALL : AU USE ENTITY WORK.AddressingUnit (dataflow);

   COMPONENT ALU
      PORT (
         A, B : IN std_logic_vector (15 DOWNTO 0);
         B15to0, AaddB, AsubB, AmulB : IN std_logic;
         aluout : OUT std_logic_vector (15 DOWNTO 0);
         zout : OUT std_logic
      );
   END COMPONENT;
   FOR ALL : ALU USE ENTITY WORK.ArithmeticUnit (dataflow);

   COMPONENT RF
      PORT (
         input : IN std_logic_vector (15 DOWNTO 0);
         clk : IN std_logic;
         Laddress, Raddress : IN std_logic_vector (3 DOWNTO 0);
         RFLwrite, RFHwrite : IN std_logic;
         Lout, Rout : OUT std_logic_vector (15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : RF USE ENTITY WORK.RegisterFile (dataflow);

   COMPONENT IR
      PORT (
         input : IN std_logic_vector (15 DOWNTO 0);
         IRload, clk : IN std_logic;
         output : OUT std_logic_vector (15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : IR USE ENTITY WORK.InstrunctionRegister (dataflow);

   COMPONENT SR
      PORT (
         Zin, SRload, clk, Zreset : IN std_logic;
         Zout : OUT std_logic
      );
   END COMPONENT;
   FOR ALL : sr USE ENTITY WORK.StatusRegister (dataflow);
   
   SIGNAL Right, Left, OpndBus, ALUout, IRout, Address, AddressUnitRSideBus : std_logic_vector (15 DOWNTO 0);
   SIGNAL SRZin, SRZout : std_logic; 
   SIGNAL Laddress, Raddress : std_logic_vector (3 DOWNTO 0);-----

BEGIN

   AddressingUnit : AU PORT MAP (
      AddressUnitRSideBus, IRout (7 DOWNTO 0), Address, clk, ResetPC, PCplusI, PCplus1, Rplus0, EnablePC
   );
          
   ArithmeticUnit : ALU PORT MAP (
      Left, OpndBus, B15to0, AaddB, AsubB, AmulB, ALUout, SRZin
   );
          
   RegisterFile : RF PORT MAP (
      Databus, clk, Laddress, Raddress, RFLwrite, RFHwrite, Left, Right
   );
         
   InstrunctionRegister : IR PORT MAP (Databus, IRload, clk, IRout);

   StatusRegister : SR PORT MAP (SRZin, SRload, clk, Zreset, SRZout);

   AddressUnitRSideBus <= 
      Right WHEN Rs_on_AddressUnitRSide='1' ELSE Left WHEN Rd_on_AddressUnitRSide='1' ELSE (OTHERS=>'Z');
   
   Addressbus <= Address;

   --Databus <= Address WHEN Address_on_Databus = '1' ELSE ALUout WHEN ALU_on_Databus = '1' ELSE (OTHERS=>'Z');
   Databus <= ALUout WHEN ALU_on_Databus = '1' ELSE (OTHERS=>'Z');

   OpndBus (7 DOWNTO 0) <= IRout (7 DOWNTO 0) WHEN IR_on_LOpndBus = '1' ELSE (OTHERS=>'Z');

   OpndBus (15 DOWNTO 8) <= IRout (7 DOWNTO 0) WHEN IR_on_HOpndBus = '1' ELSE (OTHERS=>'Z');

   OpndBus <= Right WHEN RFright_on_OpndBus = '1' ELSE (OTHERS=>'Z');

   Zout <= SRZout;

   Instruction <= IRout(15 DOWNTO 0);----------- 8 OR 16?

   Laddress <= IRout (11 DOWNTO 8);-------------

   Raddress <= IRout (7 DOWNTO 4);---------------

END dataflow;
