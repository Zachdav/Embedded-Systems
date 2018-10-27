;Including a few of the BUFFALO utility subroutines for the program.
OUTA     EQU  $FFB8
OUTSTRG  EQU  $FFC7
OUTSTRGO EQU  $FFCA
OUTRHLF  EQU  $FFB5
OUTCRLF  EQU  $FFC4
INCHAR   EQU  $FFCD

;Defining useful program messages.
Message1 FCC  "Enter a Character: "
         FCB  $04
Message2 FCC  "The Voltage is: "
         FCB  $04
Message3 FCC  "."
         FCB  $04
Message4 FCC  " Volts."

         ;An org statement for the memory of the program.  This reserves two 
         ;bytes of memory for part 3 of the lab.  It is intended for the user
         ;to memory modify (MM) the address of D000 and D001 with a mV in hex.
         ORG  $D000
MVOLTS   RMB  2
         
	      ;This is the main of the program.  Each subroutine that follows
         ;is labeled corresponding to each part of the lab.
         ;To test a part of the lab you simply change the label following
         ;jump to subroutine.
         ORG  $D002
Main:    JSR  Part1
         SWI
         END

         ;Prints the string stored in Message1 and waits for the user to
         ;input a character.  It then in responce returns the string in
         ;Message2.  The procedure is in an infinite loop.
Part1:   LDX  #Message1
         JSR  OUTSTRG
         JSR  INCHAR
         LDX  #Message2
         JSR  OUTSTRG
         RTS

         ;Print the right nibble of DB01 and DB02, then print the "." string,
         ;then the right nibble of DB03 and DB04, followed finally by the
         ;string " Volts."
Part2:   LDAA $DB01
         JSR  OUTRHLF
         LDAA $DB02
         JSR  OUTRHLF
         LDX  #Message3
         JSR  OUTSTRGO
         LDAA $DB03
         JSR  OUTRHLF
         LDAA $DB04
         JSR  OUTRHLF
         LDX  #Message4
         JSR  OUTSTRGO
         JSR  OUTCRLF
         RTS
         
         ;This program combines all the parts of the previous labs and parts.
         ;It waits for the user to enter any random character and then converts
         ;the value stored in D000 and D001 from hex to binary coded decimal.
         ;Finally it outputs that BCD to the terminal along with a message.
Part3:   JSR  Part1
         JSR  BINBCD
         JSR  Part2
         RTS

         ;This subroutine takes the values stored in D000 and D001 into 
         ;accumulator D (2 bytes).  Then it converts the value from hex
         ;to binary coded decimal storing each digit in DB00-DB04.
BINBCD   LDD  $D000
         LDX  #$2710
         IDIV
         XGDX
         STAB $DB00
         XGDX
         LDX  #$3E8
         IDIV
         XGDX
         STAB $DB01
         XGDX
         LDX  #$64
         IDIV
         XGDX
         STAB $DB02
         XGDX
         LDX  #$A
         IDIV
         XGDX
         STAB $DB03
         XGDX
         STAB $DB04
         RTS