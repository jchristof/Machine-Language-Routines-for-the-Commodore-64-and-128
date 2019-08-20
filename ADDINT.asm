;Page 85
;Name
;Add two 2-byte integer values and store the result in memory

;Description
;Adding two integers is a matter of clearing the carry flag and
;then using the ADC (ADd with Carry) instruction, first on the 
;low byte and then on the high byte.

;Prototype
;1. Clear the carry flag.
;2. Load the low bute of the first number int A.
;3. Add the low byte of the sectond number and store the result.
;4. Repeat by adding the high bytes of the two numbers.

;Explanation
;Addint multiple-byte numbers is reasonably easy. The important
;thing is to start with the low byte and work your way
;up to the higher bytes. Remember the convention that low
;bytes are stored in memory before the high bytes. The number
;1000 is hex $03e8, which would be stored as an $e8 followed
;by an $03
;For each byte, addition is a three-step process: Load the
;first number (LDA), and then second (ADC), and stor the result
;somewhere (STA). Also, carry should be cleared before the 
;first byte is added. After that, carry handles iteself.
;The following program starts with the number 1000 and
;loops 30 times, repetedly adding 350 to the total in NUM1.
;After each step, the current value is printed to the screen.

;Routine

*=$801
        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $34, $30, $39, $36, $29, $00, $00, $00

lnprt = $bdcd           ;lnprt = $8e32 on the 128
chrout = $ffd2
num1    byte 0,0
num2    byte 0,0
rpt     byte 0

*=$1000
                        ;start with a value of 1000 and add 350, repeating 30 times
        lda #<1000      ;set up num1
        sta num1        ;with the low bytes
        lda #>1000      ;and high byte
        sta num1 + 1
        lda #<350       ;num2 needs
        sta num2        ;a low bytes
        lda #>350       ;and
        sta num2 + 1    ;a high bytes
        
        lda #30         ;the counter
        sta rpt         ;is stored in rpt (repetitions)
loop
        jsr prnnum      ;print the number
        lda #32         ;space character
        jsr chrout      ;print it

        jsr addint      ;add num2 to num1
        dec rpt         ;rpr counts down
        bne loop
        rts             ;finished

prnnum
        ldx num1        ;low byte of num1
        lda num1 + 1    ;high bytes
        jmp lnprt      ;print it (rts is implied)

addint
        clc             ;always clear the carry before adding
        lda num2        ;low byte of numb2
        adc num1        ;add to low bute of num1
        sta num1        ;store it
                        ;Nor carry is indeterminate, but it's
                        ;handled byt adc below.
                        ;Note that you don't clc before adding
                        ;the high byte.
        lda num2 + 1    ;high bytes
        adc num1 + 1    ;add it
        sta num1 + 1    ;store it
        rts             ;done
