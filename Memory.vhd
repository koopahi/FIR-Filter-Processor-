
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;  
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.std_logic_arith.ALL;
USE std.textio.ALL;
USE work.FIR_prc_pak.ALL;

ENTITY memory IS
   GENERIC (blocksize : integer := 64; segmentsno : integer := 1);
   PORT (
      clk   : IN  STD_LOGIC;
      readmem : IN  STD_LOGIC;
      writemem : IN  STD_LOGIC;
      addressbus : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
      databus : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      memdataready : OUT std_logic
   );
END memory;


ARCHITECTURE behavioral OF memory IS

   TYPE mem_TYPE IS ARRAY (0 TO blocksize-1) OF STD_LOGIC_VECTOR (15 DOWNTO 0);   --Data TYPE for a seqment OF memory

--Assembler convert and amp asm FILE TO memory
PROCEDURE assembler (VARIABLE mem : OUT mem_type) IS   
   FILE code : text open read_mode IS "prog.txt";           
   VARIABLE instr, outinstr : line; 
   VARIABLE addr_str, memonic : string (4 DOWNTO 1);
   VARIABLE immi_str, dest_str, src_str : string (3 DOWNTO 1);
   VARIABLE immi_str2    : string (2 DOWNTO 1);
   VARIABLE adr, addr    : integer := -1;   

BEGIN     
   WHILE not ENDFILE (code) LOOP   
      readline (code, instr);
      READ (instr, addr_str);
      addr := to_integer (stringHEXtobin (addr_str));
      addr := addr mod blocksize; 
      READ (instr, memonic); 
         CASE memonic IS   
             WHEN " hlt" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "0000"; 
            WHEN " szf" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "0001"; 
            WHEN " czf" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "0010"; 
            WHEN " jpr" =>
               adr := adr+1;
               mem (adr) (15 DOWNTO 12) := "0011";     ----------------------
               READ (instr, immi_str);
               mem (adr) (7 DOWNTO 0) := stringHEXtobin2 (immi_str (2 DOWNTO 1));
            WHEN " brz" =>
               adr := adr+1;
               mem (adr) (15 DOWNTO 12) := "0100"; 
               READ (instr, immi_str);
               mem (adr) (7 DOWNTO 0) := stringHEXtobin2 (immi_str (2 DOWNTO 1));
            WHEN " mvr" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "0101"; 
                 READ (instr, dest_str);
                 mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
                 READ (instr, src_str);
                 mem (adr) (7 DOWNTO 4) := stringHEXtobin4 (src_str (1));
            WHEN " lda" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "0110"; 
                 READ (instr, dest_str);
                 mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
                 READ (instr, src_str);
                 mem (adr) (7 DOWNTO 4) := stringHEXtobin4 (src_str (1));
            WHEN " sta" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "0111"; 
                 READ (instr, dest_str);
                 mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
                 READ (instr, src_str);
                 mem (adr) (7 DOWNTO 4) := stringHEXtobin4 (src_str (1));
            WHEN " mil" =>
               adr := adr+1;
               mem (adr) (15 DOWNTO 12) := "1000"; 
               READ (instr, dest_str);
               mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
            --   mem (adr) (3 DOWNTO 0) := "00"; 
               READ (instr, immi_str);
               mem (adr) (7 DOWNTO 0) := stringHEXtobin2 (immi_str (2 DOWNTO 1));
           WHEN " mih" =>
               adr := adr+1;
               mem (adr) (15 DOWNTO 12) := "1001"; 
               READ (instr, dest_str);
               mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
               --mem (adr) (9 DOWNTO 8) := "01"; 
               READ (instr, immi_str);
               mem (adr) (7 DOWNTO 0) := stringHEXtobin2 (immi_str (2 DOWNTO 1));
            WHEN " add" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "1010"; 
                 READ (instr, dest_str);
                 mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
                 READ (instr, src_str);
                 mem (adr) (7 DOWNTO 4) := stringHEXtobin4 (src_str (1));
            WHEN " sub" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "1011"; 
                 READ (instr, dest_str);
                 mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
                 READ (instr, src_str);
                 mem (adr) (7 DOWNTO 4) := stringHEXtobin4 (src_str (1));
            WHEN " mul" =>
                 adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "1100"; 
                 READ (instr, dest_str);
                 mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
                 READ (instr, src_str);
                 mem (adr) (7 DOWNTO 4) := stringHEXtobin4 (src_str (1));
             WHEN " cmp" =>
                  adr := adr+1;
                 mem (adr) (15 DOWNTO 12) := "1101"; 
                 READ (instr, dest_str);
                 mem (adr) (11 DOWNTO 8) := stringHEXtobin4 (dest_str (1));
                 READ (instr, src_str);
                 mem (adr) (7 DOWNTO 4) := stringHEXtobin4 (src_str (1));
            WHEN OTHERS =>
               mem (adr) := (OTHERS=>'0');
         END CASE; 
      END LOOP;
      file_close (code);
   END;
   
   --Load a segment from a file
   PROCEDURE memload (buffermem : OUT mem_type; fileno : IN integer) IS
      VARIABLE hexcode : String (4 DOWNTO 1);
      VARIABLE memline : line;
      VARIABLE offset : integer := 0;
      VARIABLE err_check : file_open_status;
      FILE f : text;
   BEGIN
      buffermem := (OTHERS => (OTHERS =>'0'));
      file_open (err_check, f, ("mem" & integer'image (fileno) & ".hex"), read_mode);

      IF err_check = open_ok THEN
         WHILE not ENDFILE (f) LOOP
            readline (f, memline);
            READ (memline, hexcode);
            buffermem (offset) := stringHEXtobin (hexcode);
            offset := offset+1;
         END LOOP;
         file_close (f);
      END IF;

   END memload;
 
 --Write memory data OF a segment TO its corresponding file
 PROCEDURE updateFILE (buffermem : IN mem_type; fileno : IN integer) IS
 VARIABLE memline : line;
 FILE f : text open write_mode IS ("mem" & integer'image (fileno) & ".hex");
 BEGIN
 for i in 0 TO blocksize-1 LOOP
  write (memline, bintostringHEX (buffermem (i)));
  writeline (f, memline);
 END LOOP;
 file_close (f);
 END updatefile;

BEGIN
PROCESS (clk)
 VARIABLE buffermem : mem_type := (OTHERS=> (OTHERS=>'0'));
 VARIABLE ad    : INTEGER;
 VARIABLE memloadedno : integer := segmentsno+1;
 VARIABLE changemem : BOOLEAN := false;
    VARIABLE init : boolean := true;
BEGIN      
 IF (init = true) THEN    
  assembler (buffermem);    
  UpdateFILE (buffermem, 1);
  memloadedno := 1;
  init := false;
 END IF;
 ad := to_integer (addressbus);
 IF (clk='0') THEN
  IF (readmem = '0') THEN
   memdataready <= '0';
   databus <= (OTHERS=>'Z');
  END IF;
 END IF;
 IF (clk='1') THEN
  IF (readmem = '1') THEN
   memdataready <= '0';
   IF (ad >= (segmentsno*blocksize)) THEN
    databus <= (OTHERS => 'Z');
   ELSE
    IF (memloadedno /= ( (ad/blocksize)+1)) THEN
     IF memloadedno/= (segmentsno+1) THEN
       IF changemem=true THEN UpdateFILE (buffermem, memloadedno); END IF;
     END IF;
     memload (buffermem, ( (ad/blocksize)+1));
     changemem := false;
     memloadedno := (ad/blocksize)+1;
     databus <= buffermem (ad mod blocksize);
    ELSE
     databus <= buffermem (ad mod blocksize);
    END IF;
   END IF;
   memdataready <= '1';
  ELSIF (writemem = '1') THEN
   memdataready <= '0';
   IF (ad < (segmentsno*blocksize)) THEN
    IF (memloadedno = ( (ad/blocksize)+1)) THEN
      IF buffermem (ad mod blocksize)/=databus THEN changemem := true; END IF;
      buffermem (ad mod blocksize) := databus;
      IF changemem=true THEN 
       UpdateFILE (buffermem, memloadedno);
       changemem := false;
      END IF;
    ELSE
      IF memloadedno/= (segmentsno+1) THEN
       IF changemem=true THEN UpdateFILE (buffermem, memloadedno); END IF;
      END IF;
      memloadedno := (ad/blocksize)+1;
      memload (buffermem, memloadedno);
      changemem := false;
      IF buffermem (ad mod blocksize)/=databus THEN changemem := true; END IF;
      buffermem (ad mod blocksize) := databus;
      IF changemem=true THEN 
       UpdateFILE (buffermem, memloadedno);
       changemem := false;
      END IF;
    END IF;
   END IF;
   memdataready <= '1';
  END IF;
 END IF;
END PROCESS;
END behavioral;

