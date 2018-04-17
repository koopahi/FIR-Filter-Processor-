LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 

ENTITY m1x1 IS
   PORT (xi, yi, pi, ci : IN std_logic; 
      xo, yo, po, co : OUT std_logic);
END m1x1;
ARCHITECTURE bitwise OF m1x1 IS
SIGNAL xy : std_logic;
BEGIN
   xy <= xi AND yi;
   co <= (pi AND xy) OR (pi AND ci) OR (xy AND ci);
   po <= pi XOR xy XOR ci;
   xo <= xi;
   yo <= yi;
END bitwise;
-----------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 

ENTITY mult_8by8 IS
   PORT (x, y : IN std_logic_vector (7 DOWNTO 0); 
       z : OUT std_logic_vector (15 DOWNTO 0));
END mult_8by8;   

ARCHITECTURE bitwise OF mult_8by8 IS 

COMPONENT m1x1 
   PORT (xi, yi, pi, ci : IN std_logic; 
   xo, yo, po, co : OUT std_logic); 
END COMPONENT; 

TYPE pair IS ARRAY (8 DOWNTO 0, 8 DOWNTO 0) OF std_logic;
SIGNAL xv, yv, cv, pv : pair;

BEGIN 
   
   rows : FOR i IN x'RANGE GENERATE
      cols : FOR j IN y'RANGE GENERATE
         cell : m1x1 PORT MAP (xv (i, j), yv (i, j), pv (i, j+1), cv (i, j), xv (i, j+1), yv (i+1, j), pv (i+1, j), cv (i, j+1));
      END GENERATE;
   END GENERATE; 
   
   sides : FOR i IN x'RANGE GENERATE
      xv (i, 0) <= x (i);
      cv (i, 0) <= '0';
      pv (0, i+1) <= '0';
      pv (i+1, x'LENGTH) <= cv (i, x'LENGTH);
      yv (0, i) <= y (i);
      z (i) <= pv (i+1, 0);
      z (i+x'LENGTH) <= pv (x'LENGTH, i+1);
   END GENERATE;    
   
END bitwise;
-----------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_unsigned.ALL;

ENTITY ArithmeticUnit IS
   PORT (
      A, B : IN std_logic_vector (15 DOWNTO 0);
      B15to0 : IN std_logic;
      --, AandB, AorB, notB, shlB, shrB : IN std_logic;
      AaddB, AsubB, AmulB : IN std_logic;
      --AcmpB : IN std_logic;
      aluout : OUT std_logic_vector (15 DOWNTO 0);
      --cin : IN std_logic;
      zout : OUT std_logic
      --cout : OUT std_logic
   );
END ArithmeticUnit;

ARCHITECTURE dataflow OF ArithmeticUnit IS
   COMPONENT mult 
      PORT (
         x, y : IN std_logic_vector (7 DOWNTO 0); 
         z : OUT std_logic_vector (15 DOWNTO 0)
      );
   END COMPONENT;
   FOR ALL : mult USE ENTITY work.mult_8by8 (bitwise);

   CONSTANT B15to0H : std_logic_vector (3 DOWNTO 0) := "1000";
   --CONSTANT AandBH  : std_logic_vector (9 DOWNTO 0) := "0100000000";
   --CONSTANT AorBH   : std_logic_vector (9 DOWNTO 0) := "0010000000";
   --CONSTANT notBH   : std_logic_vector (9 DOWNTO 0) := "0001000000";
   --CONSTANT shlBH   : std_logic_vector (9 DOWNTO 0) := "0000100000";
   --CONSTANT shrBH   : std_logic_vector (9 DOWNTO 0) := "0000010000";
   CONSTANT AaddBH  : std_logic_vector (3 DOWNTO 0) := "0100";
   CONSTANT AsubBH  : std_logic_vector (3 DOWNTO 0) := "0010";
   CONSTANT AmulBH  : std_logic_vector (3 DOWNTO 0) := "0001";
   --CONSTANT AcmpBH  : std_logic_vector (9 DOWNTO 0) := "0000000001";
   SIGNAL aluoutSignal, product : std_logic_vector (15 DOWNTO 0);

BEGIN
   PROCESS (A, B, B15to0, AaddB, AsubB, AmulB, aluoutSignal, product)
   --B15to0, AandB, AorB, notB, shlB, shrB, --, AcmpB)--signal, product are added
      VARIABLE temp :  std_logic_vector (3 DOWNTO 0);
      VARIABLE sum :  std_logic_vector (15 DOWNTO 0);
      VARIABLE sub :  std_logic_vector (15 DOWNTO 0);
   BEGIN
      zout <= '0';
      --cout <= '0';
      aluoutSignal <= (OTHERS=>'0');
      temp := (B15to0, AaddB, AsubB, AmulB);--, AcmpB);
      sum := A + B ;
      sub := A - B ;

      CASE temp IS
         WHEN B15to0H => aluoutSignal <= B;
         --WHEN AandBH  => aluoutSignal <= A and B;
         --WHEN AorBH  => aluoutSignal <= A or B;
         --WHEN notBH  => aluoutSignal <= not (B);
         --WHEN shlBH  => aluoutSignal <= B (14 DOWNTO 0) & B (0);
         --WHEN shrBH  => aluoutSignal <= B (15) & B (15 DOWNTO 1);
         WHEN AaddBH  => aluoutSignal <= sum;
         WHEN AsubBH  => aluoutSignal <= sub;
         WHEN AmulBH  => aluoutSignal <= product; --A (7 DOWNTO 0) * B (7 DOWNTO 0);
         --WHEN AcmpBH  => aluoutSignal <= (OTHERS=>'1');
          --  IF (A>B) THEN
          --     cout <= '1';
          --  ELSE
          --     cout <= '0';
          --  END IF;
--
          --  IF (A=B) THEN
          --     zout <= '1';
          --  ELSE
          --     zout <= '0';
          --  END IF;
         WHEN OTHERS => aluoutSignal <= (OTHERS=>'0');
      END CASE;

      IF (aluoutSignal = "0000000000000000") THEN
         zout <= '1';
      END IF;

   END PROCESS;
   
   l1 : mult PORT MAP (A (7 DOWNTO 0), B (7 DOWNTO 0), product);
   
   aluout <= aluoutSignal;

END dataflow;