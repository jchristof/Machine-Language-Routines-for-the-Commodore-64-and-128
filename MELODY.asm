*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $34, $30, $39, $36, $29, $00, $00, $00

sigvol = $d418          ;SID chip volume register
atdcy1 = $d405          ;voice 1 attack/decay register
surel1 = $d406          ;voice 1 sustain/release register
frelo1 = $d400          ;voice 1 frequency control (low byte)
frehi1 = $d401          ;voice 1 frequency control (high byte)
vcreg1 = $d404          ;voice 1 control register
jifflo = $a2            ;low byte of jiffy clock

*=$1000

melody
        lda #0
        sta notenm      ;set a pointer to the first note in the table
        jsr sidclr      ;clear the sid chip
        lda #15         ;set the volume to maximuum
        sta sigvol
        lda #$1a        ;set attack/delay
        sta atdcy1
        lda #$1b
        sta surel1
notelp
        ldx notenm      ;get the note number
        lda notes,x     ;get index into freqtb
        asl             ;double it since freqtb contains two-byte addresses

        tax             ;to index freqtb
        lda freqtb,x    ;get low byte of note's frequency
        sta frelo1     ;store it in voice 1
        lda freqtb+1,x  ;get hight byte of note's frequency
        sta frehi1      ;store it in voice 1
        lda #%00100001  ;gate sawtootch waveform
        sta vcreg1
        ldx notenm      ;put the note number in X
        ldy ndurtb,x    ;get the note's duration from a table
rpt
        lda #8          ;delay for number of jiffies in A
        adc jifflo
delay
        cmp jifflo      ;has time elapsed?
        bne delay       ;if not, continue the delay
        dey
        bne rpt      ;repeat the jiffy delay if necessary
        lda #%00100000  ;ungate waveform
        sta vcreg1
        inc notenm      ;increase note counter
        lda notenm
        cmp #nmnote     ;see if all have played
        bcc notelp      ;if not contine
        rts

sidclr                  ;clear the sid chip
        lda #0          ;fill with zeros
        ldy #24         ;index to frelo1
sidlop
        sta frelo1,y    ;store zero in side chip address
        dey             ;for next lower bytes
        bpl sidlop      ;fill 25 bytes
        rts

notenm  byte 0
                        ;table of notes
notes   byte    0,5,5,7,7,9,12,9,5,0,5,5,7,7,9,5
        byte    0,5,5,7,7,9,12,9,5,14,7,10,9,5

notes_end
                        ;number of notes
nmnote =  notes_end - notes      

                        ;table of note durations
ndurtb  byte    1,2,1,2,1,1,1,1,2,1,2,1,2,1,3,3
        byte    1,2,1,2,1,1,1,1,3,3,2,1,3,3

                        ;table of 2-byte frequency values
freqtb  word    6430,6812,7217,7647,8101,8583,9094
        word    9634,10207,10814,11457,12139,12860,13625,14435
                        


