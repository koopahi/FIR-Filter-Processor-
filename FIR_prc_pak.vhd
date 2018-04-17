library ieee;
USE IEEE.std_logic_1164.ALL;  
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.ALL;
USE std.textio.ALL;

PACKAGE FIR_prc_pak IS              

   FUNCTION bintostringHEX (arg : std_logic_vector (15 DOWNTO 0)) return string;
   FUNCTION stringHEXtobin (arg : string) return std_logic_vector;
   FUNCTION stringHEXtobin1 (arg : character) return std_logic_vector;
   FUNCTION stringHEXtobin3 (arg : character) return std_logic_vector;
   FUNCTION stringHEXtobin4 (arg : character) return std_logic_vector;
   FUNCTION stringHEXtobin2 (arg : string) return std_logic_vector;
   FUNCTION to_integer (arg : std_logic_vector) return integer;

END FIR_prc_pak;

PACKAGE  body FIR_prc_pak IS 

   --Converting a binary vector TO equvalent hex string 
   FUNCTION bintostringHEX (arg : std_logic_vector (15 DOWNTO 0)) return string IS 
   VARIABLE result : string (4 DOWNTO 1) := "0000";
   BEGIN
      FOR i IN 1 TO 4 LOOP
          IF arg ( (i*4)-1 DOWNTO (i*4)-4)="0000" THEN result (i) := '0';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="0001" THEN result (i) := '1';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="0010" THEN result (i) := '2';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="0011" THEN result (i) := '3';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="0100" THEN result (i) := '4';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="0101" THEN result (i) := '5';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="0110" THEN result (i) := '6';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="0111" THEN result (i) := '7';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1000" THEN result (i) := '8';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1001" THEN result (i) := '9';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1010" THEN result (i) := 'A';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1011" THEN result (i) := 'B';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1100" THEN result (i) := 'C';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1101" THEN result (i) := 'D';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1110" THEN result (i) := 'E';
         ELSIF arg ( (i*4)-1 DOWNTO (i*4)-4)="1111" THEN result (i) := 'F';
         END IF;
      END LOOP;
     RETURN result;
   END;

   --Converting a hex string TO equvalent 16 bit binary vector
   FUNCTION stringHEXtobin (arg : string) return std_logic_vector IS 
      VARIABLE result : std_logic_vector (15 DOWNTO 0);
   BEGIN
      for i in arg'range LOOP
         CASE arg (i) IS
            WHEN '0' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0000";
            WHEN '1' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0001";
            WHEN '2' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0010"; 
            WHEN '3' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0011";
            WHEN '4' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0100";
            WHEN '5' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0101";
            WHEN '6' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0110";
            WHEN '7' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0111";
            WHEN '8' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1000";
            WHEN '9' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1001";
            WHEN 'A' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1010";
            WHEN 'B' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1011";
            WHEN 'C' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1100";
            WHEN 'D' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1101";
            WHEN 'E' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1110";
            WHEN 'F' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1111";
            WHEN OTHERS => result := result;
         END CASE;
      END LOOP;  

      return result;
   END;

   --Converting a hex string TO equvalent 2 bit binary vector
   FUNCTION stringHEXtobin1 (arg : character) return std_logic_vector IS 
      VARIABLE result : std_logic_vector (1 DOWNTO 0);
   BEGIN
      CASE arg IS
         WHEN '0' => result (1 DOWNTO 0) := "00";
         WHEN '1' => result (1 DOWNTO 0) := "01";
         WHEN '2' => result (1 DOWNTO 0) := "10"; 
         WHEN '3' => result (1 DOWNTO 0) := "11";
         WHEN OTHERS => result := result;
      END CASE;
   
      return result;
   END;

   --Converting a hex string TO equvalent 3 bit binary vector
   FUNCTION stringHEXtobin3 (arg : character) return std_logic_vector IS 
      VARIABLE result : std_logic_vector (2 DOWNTO 0);
   BEGIN
      CASE arg IS
         WHEN '0' => result (2 DOWNTO 0) := "000";
         WHEN '1' => result (2 DOWNTO 0) := "001";
         WHEN '2' => result (2 DOWNTO 0) := "010"; 
         WHEN '3' => result (2 DOWNTO 0) := "011";
         WHEN '4' => result (2 DOWNTO 0) := "100";
         WHEN '5' => result (2 DOWNTO 0) := "101";
         WHEN '6' => result (2 DOWNTO 0) := "110";
         WHEN '7' => result (2 DOWNTO 0) := "111";
         WHEN OTHERS => result := result;
      END CASE;

      return result;
   END;
   
    FUNCTION stringHEXtobin4 (arg : character) return std_logic_vector IS 
         VARIABLE result : std_logic_vector (3 DOWNTO 0);
      BEGIN
         CASE arg IS
            WHEN '0' => result (3 DOWNTO 0) := "0000";
            WHEN '1' => result (3 DOWNTO 0) := "0001";
            WHEN '2' => result (3 DOWNTO 0) := "0010"; 
            WHEN '3' => result (3 DOWNTO 0) := "0011";
            WHEN '4' => result (3 DOWNTO 0) := "0100";
            WHEN '5' => result (3 DOWNTO 0) := "0101";
            WHEN '6' => result (3 DOWNTO 0) := "0110";
            WHEN '7' => result (3 DOWNTO 0) := "0111";
            WHEN '8' => result (3 DOWNTO 0) := "1000";
            WHEN '9' => result (3 DOWNTO 0) := "1001";
            WHEN 'A' => result (3 DOWNTO 0) := "1010";
            WHEN 'B' => result (3 DOWNTO 0) := "1011";
            WHEN 'C' => result (3 DOWNTO 0) := "1100";
            WHEN 'D' => result (3 DOWNTO 0) := "1101";
            WHEN 'E' => result (3 DOWNTO 0) := "1110";
            WHEN 'F' => result (3 DOWNTO 0) := "1111";
            
            WHEN OTHERS => result := result;
         END CASE;
   
         return result;
      END;

   
   
   

   --Converting a hex string TO equvalent 8 bit binary vector
   FUNCTION stringHEXtobin2 (arg : string) return std_logic_vector IS 
      VARIABLE result : std_logic_vector (7 DOWNTO 0);
   BEGIN
      for i in arg'range LOOP
         CASE arg (i) IS
            WHEN '0' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0000";
            WHEN '1' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0001";
            WHEN '2' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0010"; 
            WHEN '3' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0011";
            WHEN '4' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0100";
            WHEN '5' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0101";
            WHEN '6' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0110";
            WHEN '7' => result ( (i*4)-1 DOWNTO (i*4)-4) := "0111";
            WHEN '8' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1000";
            WHEN '9' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1001";
            WHEN 'A' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1010";
            WHEN 'B' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1011";
            WHEN 'C' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1100";
            WHEN 'D' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1101";
            WHEN 'E' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1110";
            WHEN 'F' => result ( (i*4)-1 DOWNTO (i*4)-4) := "1111";
            WHEN OTHERS => result := result;
         END CASE;
      END LOOP;  

      return result;
   END;
 
   --Converting a binary vector TO equvalent integer
   FUNCTION to_integer (arg : std_logic_vector) return integer IS
      VARIABLE result : integer;
   BEGIN
      result := 0;
      for i in arg'range LOOP
         IF (arg (i) = '1') THEN
            result := result + 2**i;
         END IF;

      END LOOP;

      return result;
   END to_integer;

END FIR_prc_pak;
