OUTA     EQU  $FFB8
OUTSTRG  EQU  $FFC7
OUTSTRGO EQU  $FFCA
OUTCRLF  EQU  $FFC4
OUTRHLF  EQU  $FFB5
INCHAR   EQU  $FFCD

PORTB    EQU  $1004
PORTE    EQU  $100A
ADCTL    EQU  %00100011
DIGI     EQU  $1034

PROMPT:  FCC  "Enter a Character To Take A Measurement: "
         FCB  $04
RESULT:  FCC  " Degrees Celcius"
         FCB  $04

         ORG  $D000
TEMP     RMB  2

         ORG  $D002
         LDS  $DFFF
         LDAA #ADCTL
         STAA $1030
MAIN:    LDX  #PROMPT
         JSR  OUTSTRG
         JSR  INCHAR
         LDAA DIGI
         ;LDAA #127
         LDAB #40
         MUL
         STD  TEMP
         JSR  BINBCD
         JSR  PRINT
         JSR  LED
         JSR  MAIN
         SWI
         END
         
LED:     LDD  TEMP
         LDX  #13
         IDIV
         XGDX
         CPD  #700
         BGT  EIGHT
         CPD  #600
         BGT  SEVEN
         CPD  #500
         BGT  SIX
         CPD  #400
         BGT  FIVE
         CPD  #300
         BGT  FOUR
         CPD  #200
         BGT  THREE
         CPD  #100
         BGT  TWO
         CPD  #0
         BGT  ONE
         BRA  ZERO
         SWI
         
EIGHT:   LDAA #255
         STAA PORTB
RANGE:   BRA  MAIN
SEVEN:   LDAA #254
         STAA PORTB
         BRA  RANGE
SIX:     LDAA #252
         STAA PORTB
         BRA  RANGE
FIVE:    LDAA #248
         STAA PORTB
         BRA  RANGE
FOUR:    LDAA #240
         STAA PORTB
         BRA  RANGE
THREE:   LDAA #224
         STAA PORTB
         BRA  RANGE
TWO:     LDAA #192
         STAA PORTB
         BRA  RANGE
ONE:     LDAA #128
         STAA PORTB
         BRA  RANGE
ZERO:    LDAA #0
         STAA PORTB
         BRA  RANGE
         
PRINT:   LDAA $DB00
         JSR  OUTRHLF
         LDAA $DB01
         JSR  OUTRHLF
         LDAA $DB02
         JSR  OUTRHLF
         ;LDX  #RESULT
         ;JSR  OUTSTRG
         JSR  OUTCRLF
         RTS
         
BINBCD:  LDD  TEMP
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
         