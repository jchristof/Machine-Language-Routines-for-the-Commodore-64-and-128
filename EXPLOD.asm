;Page 226

;Name
;Produce an explosion sound

;Description
;EXPLOD provides the sound of an explosion and could be
;used in any number of game programs, with or without modification.

;Prototype
;1. Clead the SID chip with SIDCLR.
;2. Set the necessary SID chip parameters (volume, 
;attack/decay, sustain/release, and frequency
;3. Select the noise waveform and gate the sound.
;4. Cause a delay (here, 120 jiffies), and then start the release
;cycle (ungate the sound).
;5. Then RTS

;Explanation
;This routine relies on the noise waiveform to achieve its effect.
;You can alter the sound that's produced by varying a number
;of parameters in the routine. These include the attack/decay
;and sustain/release rates, the base frequency for the noise 
;waveform, and the number of jiffies between gating and
;ungating the chip.
;EXPLOD is no different in one respect from other sound 
;effect routines in the book. Agter the release cycle is complete,
;the SID chip hums on in the background. Again, to prevent 
;this, after the explosion sound has soundedm, store zeros in the requency
;registers (FREHI1, FREHI3) or turn the chip off altogether
;by JSRing to SIDCLR

*=$801
        BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $34, $30, $39, $36, $29, $00, $00, $00

sigvol = $d418          ;SID chip volume register
atdcy1 = $d405          ;voice 1 attack/decay register
surel1 = $d406          ;voice 1 sustain/release register
frelo1 = $d400          ;voice 1 frequency control (low byte)
frehi1 = $d401          ;voice 1 frequency control (high byte)
vcreg1 = $d404          ;voice 1 control register
jifflo = $a2            ;low byte of jiffy clock

*=$1000

explod
        jsr sidclr      ;clear the sid chip
        lda #15         ;set volume
        sta sigvol      
        lda #$0c        ;set attack/decay
        sta atdcy1
        lda #$18        ;set sustain/release
        sta surel1
        lda #0          ;set voice 1 low frequency
        sta frelo1
        lda #24         ;set voice 1 high frequency
        sta frehi1
        lda #%10000001  ;select noise waveform and gate sound
        sta vcreg1
        lda #120        ;cause a delay of 120 jiffies
        adc jifflo      ;add current jiffy reading
delay
        cmp jifflo      ;and wait for 120 jiffies to elapse
        bne delay
        lda #%1000000   ;ungate sound
        sta vcreg1
        rts

sidclr                  ;clear the sid chip
        lda #0          ;fill with zeros
        ldy #24         ;index to frelo1
sidlop
        sta frelo1,y    ;store zero in side chip address
        dey             ;for next lower bytes
        bpl sidlop      ;fill 25 bytes
        rts
