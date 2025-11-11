; Memory Addresses:
; 2100H = Seconds (SS)
; 2101H = Minutes (MM)
; 2102H = Hours (HH)
;
; Output Ports:
; Port 01H = Hours
; Port 02H = Minutes
; Port 03H = Seconds
; ----------------------------------------------------------------

; --- 1. Initialization ---
; Set the clock to 00:00:00 at the start.
           LXI H,2100H	; Point HL register to Seconds (2100H)
           MVI M,00H	; Set Seconds [HL] to 00
           INX H		; Point to Minutes (2101H)
           MVI M,00H	; Set Minutes [HL] to 00
           INX H		; Point to Hours (2102H)
           MVI M,00H	; Set Hours [HL] to 00

; --- 2. Main Program Loop ---
MAIN:	   CALL DISPLAY	; Go to DISPLAY subroutine to output time
           CALL DELAY	; Go to DELAY subroutine to wait 1 second
           CALL UPDATE_TIME	; Go to UPDATE_TIME subroutine
           JMP MAIN		; Repeat the loop forever

; --- 3. Subroutine: Update Time Logic ---
UPDATE_TIME:
    ; --- Handle Seconds and Minutes ---
           LHLD 2100H	; Load L=Seconds, H=Minutes
           INR L		; Increment Seconds (L = L + 1)
           MOV A,L		; Move Seconds to Accumulator
           CPI 3CH		; Compare Seconds with 60 (3CH)
           JNZ STORE_SS_MM	; If not 60, jump to store
           
    ; --- If Seconds = 60 ---
           MVI L,00H	; Reset Seconds to 00
           INR H		; Increment Minutes (H = H + 1)
           MOV A,H		; Move Minutes to Accumulator
           CPI 3CH		; Compare Minutes with 60 (3CH)
           JNZ STORE_SS_MM	; If not 60, jump to store

    ; --- If Minutes = 60 ---
           MVI H,00H	; Reset Minutes to 00
           SHLD 2100H	; Store reset Seconds(00) and Minutes(00)
           
    ; --- Handle Hours (Only if Minutes just reset) ---
           LDA 2102H	; Load Hours from memory
           INR A		; Increment Hours (A = A + 1)
           CPI 18H		; Compare Hours with 24 (18H)
           JNZ STORE_HH	; If not 24, jump to store
           
    ; --- If Hours = 24 ---
           MVI A,00H	; Reset Hours to 00
           
    STORE_HH:
           STA 2102H	; Store updated Hours
           RET		; Return from subroutine
           
    STORE_SS_MM:
           SHLD 2100H	; Store updated Seconds and/or Minutes
           RET		; Return from subroutine

; --- 4. Subroutine: Display Time to Ports ---
DISPLAY:   LDA 2102H	; Load Hours into A
           OUT 01H		; Output A to Port 01
           LDA 2101H	; Load Minutes into A
           OUT 02H		; Output A to Port 02
           LDA 2100H	; Load Seconds into A
           OUT 03H		; Output A to Port 03
           RET		; Return from subroutine

; --- 5. Subroutine: 1 Second Delay ---
DELAY:	   MVI B,0FH	; Shortened loop count for simulation
OUTER:	   MVI C,0FFH
MIDDLE:	   MVI D,0FFH
INNER:	   DCR D
           JNZ INNER
           DCR C
           JNZ MIDDLE
           DCR B
           JNZ OUTER
           RET		; Return from subroutine