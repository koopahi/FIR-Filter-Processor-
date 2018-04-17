 
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY controller IS
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
END controller;
ARCHITECTURE dataflow OF controller IS
TYPE state IS (reset, halt, fetch, instread, exec1, exec1lda, exec1sta, incpc);

CONSTANT hlt : std_logic_vector (3 DOWNTO 0) := "0000";
--CONSTANT szf : std_logic_vector (3 DOWNTO 0) := "0001";
--CONSTANT czf : std_logic_vector (3 DOWNTO 0) := "0010";
CONSTANT jpr : std_logic_vector (3 DOWNTO 0) := "0011";
CONSTANT brz : std_logic_vector (3 DOWNTO 0) := "0100";
CONSTANT mvr : std_logic_vector (3 DOWNTO 0) := "0101";
CONSTANT lda : std_logic_vector (3 DOWNTO 0) := "0110";
CONSTANT sta : std_logic_vector (3 DOWNTO 0) := "0111";

CONSTANT mil : std_logic_vector (3 DOWNTO 0) := "1000";
CONSTANT mih : std_logic_vector (3 DOWNTO 0) := "1001";
CONSTANT add : std_logic_vector (3 DOWNTO 0) := "1010";
CONSTANT sub : std_logic_vector (3 DOWNTO 0) := "1011";
CONSTANT mul : std_logic_vector (3 DOWNTO 0) := "1100";
--CONSTANT cmp : std_logic_vector (3 DOWNTO 0) := "1101";


SIGNAL Pstate, Nstate : state;

BEGIN
PROCESS (Instruction, Pstate, ExternalReset, Zflag, memDataReady)
BEGIN  
 ResetPC <= '0'; PCplusI <= '0'; PCplus1 <= '0'; Rplus0 <= '0'; EnablePC <= '0';
 B15to0 <= '0'; AaddB <= '0'; 
 AsubB <= '0'; AmulB <= '0';--AcmpB <= '0';
 RFLwrite <= '0';RFHwrite <= '0'; IRload <= '0'; 
 SRload <= '0'; ALU_on_Databus <= '0'; IR_on_LOpndBus <= '0'; IR_on_HOpndBus <= '0';
 RFright_on_OpndBus  <= '0'; ReadMem <= '0'; WriteMem   <= '0'; 
 --Zset <= '0';
 Zreset <= '0'; Rs_on_AddressUnitRSide <= '0';
 Rd_on_AddressUnitRSide <= '0';
CASE Pstate IS
WHEN reset => 
 IF (ExternalReset = '1') THEN
  ResetPC <= '1';
  EnablePC <= '1';
  Zreset <= '1';
  Nstate <= reset;
 ELSE
  Nstate <= fetch;
 END IF; 
WHEN halt => 
 IF (ExternalReset = '1') THEN
  Nstate <= fetch;
 ELSE
  Nstate <= halt;
 END IF; 
WHEN fetch => 
 IF (ExternalReset = '1') THEN
  Nstate <= reset;
 ELSE
  ReadMem <= '1';
  Nstate <= instread;
 END IF; 
WHEN instread =>
 IF (ExternalReset = '1') THEN
  Nstate <= reset;
 ELSE
  IF (memDataReady = '0') THEN
   ReadMem <= '1';
   Nstate <= instread;
  ELSE  
   IRload <= '1';  
   Nstate <= exec1;
  END IF;
 END IF;
WHEN exec1 => 
 IF (ExternalReset = '1') THEN
  Nstate <= reset;
 ELSE
  CASE Instruction (15 DOWNTO 12)is
     WHEN hlt =>
      Nstate <= halt;
     --WHEN szf =>
     -- zset <= '1';
     -- PCplus1 <= '1';
     -- EnablePC <= '1';
     -- Nstate <= fetch; 
     --WHEN czf =>
     -- zreset <= '1';
     -- PCplus1 <= '1';
     -- EnablePC <= '1';
     -- Nstate <= fetch; 
     WHEN jpr =>
       PCplusI <= '1';
       EnablePC <= '1';
       Nstate <= fetch; 
     WHEN brz =>
      IF (Zflag = '1') THEN
       PCplusI <= '1';
       EnablePC <= '1';
      ELSE
       PCplus1 <= '1';
       EnablePC <= '1';
      END IF;
      Nstate <= fetch; 
   WHEN mvr =>
    RFright_on_OpndBus <= '1';
    B15to0 <= '1';
    ALU_on_Databus <= '1';
    RFLwrite <= '1';
    RFHwrite <= '1';
    SRload <= '1';
    PCplus1 <= '1';
    EnablePC <= '1';
    Nstate <= fetch; 
   WHEN lda =>
    Rplus0 <= '1';
    Rs_on_AddressUnitRSide <= '1';
    ReadMem <= '1';
    Nstate <= exec1lda;
   WHEN sta =>
    Rplus0 <= '1';
    Rd_on_AddressUnitRSide <= '1';
    RFright_on_OpndBus <= '1';
    B15to0 <= '1';
    ALU_on_Databus <= '1';
    WriteMem <= '1';
    Nstate <= exec1sta;
   WHEN add =>
    RFright_on_OpndBus <= '1';
    AaddB <= '1';
    ALU_on_Databus <= '1';
    RFLwrite <= '1';
    RFHwrite <= '1';
    SRload <= '1';
    Pcplus1 <= '1';
    EnablePC <= '1';
    Nstate <= fetch; 
   WHEN sub =>
    RFright_on_OpndBus <= '1';
    AsubB <= '1';
    ALU_on_Databus <= '1';
    RFLwrite <= '1';
    RFHwrite <= '1';
    SRload <= '1';
    Pcplus1 <= '1';
    EnablePC <= '1';
    Nstate <= fetch; 
  WHEN mul =>
    RFright_on_OpndBus <= '1';
    AmulB <= '1';
    ALU_on_Databus <= '1';
    RFLwrite <= '1';
    RFHwrite <= '1';
    SRload <= '1';
    Pcplus1 <= '1';
    EnablePC <= '1';
    Nstate <= fetch; 
   --WHEN cmp =>
   -- RFright_on_OpndBus <= '1';
   -- AcmpB <= '1';
   -- SRload <= '1';
   -- Pcplus1 <= '1';
   -- EnablePC <= '1';
   -- Nstate <= fetch; 
   WHEN mil =>
    IR_on_LOpndBus <= '1';
    ALU_on_Databus <= '1';
    B15to0 <= '1';
    RFLwrite <= '1';
    SRload <= '1';
    Pcplus1 <= '1';
    EnablePC <= '1';
    Nstate <= fetch;
   WHEN mih =>
    IR_on_HOpndBus <= '1';
    ALU_on_Databus <= '1';
    B15to0 <= '1';
    RFHwrite <= '1';
    SRload <= '1';
    Pcplus1 <= '1';
    EnablePC <= '1';
    Nstate <= fetch;
   WHEN OTHERS =>  Nstate <= fetch;
  END CASE;
 END IF; 
WHEN exec1lda => 
 IF (ExternalReset = '1') THEN
  Nstate <= reset;
 ELSE
  IF (memDataReady = '0') THEN
   Rplus0 <= '1';
   Rs_on_AddressUnitRSide <= '1';
   ReadMem <= '1';
   Nstate <= exec1lda;
  ELSE  
   RFLwrite <= '1';
   RFHwrite <= '1';
   PCplus1 <= '1';
   EnablePC <= '1';
   Nstate <= fetch;
  END IF;
 END IF;
WHEN exec1sta => 
 IF (ExternalReset = '1') THEN
  Nstate <= reset;
 ELSE
  IF (memDataReady = '0') THEN
   Rplus0 <= '1';
   Rd_on_AddressUnitRSide <= '1';
   RFright_on_OpndBus <= '1';
   B15to0 <= '1';
   ALU_on_Databus <= '1';
   WriteMem <= '1';
   Nstate <= exec1sta;
  ELSE  
  Nstate <= incpc; 
  END IF;
 END IF;
WHEN incpc => 
 PcPlus1 <= '1';
 EnablePC <= '1';
 Nstate <= fetch;
WHEN OTHERS => Nstate <= reset;
END CASE;
END PROCESS;

PROCESS (clk)
BEGIN
IF (clk = '0') THEN
 Pstate <= Nstate;
END IF;
END PROCESS;
END dataflow; 
-----------------------------------------------------------------------------
