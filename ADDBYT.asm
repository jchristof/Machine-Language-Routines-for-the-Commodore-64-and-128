;Name 
;Add two bytes and store the result

;Description
;Adding is one of the essential arithmetic function in machine
;language (or in any computer language). This routine simply
;adds two number and stores the rest in memory

;Prototype
;1. Load the first number from memory.
;2. Clear the carry flag with a CLC instruction.
;3. Add the second number with ADC.
;4. Save the result in memory.

;Explanation
;The framing routine waits for a keypress, then stores the 
;ASCII value in memory. It gets a second ASCII value, then
;prints the two numbers. After the ADDBYT routine is called,
;the answer is printed.

;If you rant a proper result, you should always clear the carr
;before using the ADC instruction. ADC really adds three num-
;bers: two that are in the rance 0-255 and one (the carry flag)
;that's either 0 or 1. Adding 10 + 10 with carry set 
;(10 + 10 + 1) will give you a result of 21

;Note:If the result of the addition is greater than 255, the
;additional bit which represents a value of 256 will be in the 
;carry flag (carry will be set). If you're adding signed bytes and
;the answer is greater than 127, the overflow (V) flag will be set.

; 10 SYS (2049)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $34, $30, $39, $36, $29, $00, $00, $00

getin   = $ffe4
linprt  = $bdcd  ;linprt = $8e32 on the 128
chrout  = $ffd2

number1 byte 0
number2 byte 0
total   byte 0

*=$1000

        jsr getkey      ;get a key (ASCII value)
        sta number1     ;store it
        jsr getkey      ;get a second key
        sta number2     ;store it too
        ldx number1     ;now print it
        lda #0
        jsr linprt
        lda #13
        jsr chrout      ;print <RETURN>
        ldx number2     ;second number
        lda #0
        jsr linprt      ;print it
        lda #13
        jsr chrout      ;<RETURN> again
        
addbyt
        lda number1     ;the first number
        clc             ;clear the carry flag
        adc number2     ;add the second number
        sta total       ;total
        tax             ;put it in x
        lda #0
        jsr linprt      ;and print it
        
getkey
        jsr getin
        beq getkey
        rts

