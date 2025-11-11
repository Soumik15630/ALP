; --- 1. Setup ---
           LXI SP,2500H	; Initialize Stack Pointer
           MVI A,0BH	; Set mask to unmask RST 7.5
           SIM		; Apply the mask
           EI		; Enable interrupts
           XRA A		; Clear A, so our counter starts at 0

; --- 2. Main Program (Visible Loop) ---
; This loop will continuously count from 00H to FFH
; and output the value to Port 01H.
           ORG 0100H
MAIN:	   INR A		; Increment the counter
           OUT 01H		; Output counter value to Port 01
           CALL DELAY	; A short delay to make the count visible
           JMP MAIN

; --- 3. ISR for RST 7.5 ---
; This code runs ONLY when RST 7.5 is triggered.
; It will output FFH to a DIFFERENT port.
           ORG 003CH
           PUSH PSW	; Save A and Flags (Good Practice)
           MVI A,0FFH	; Load a special "interrupt" value
           OUT 02H		; Output to Port 02
           POP PSW		; Restore A and Flags
           EI		; Re-enable interrupts
           RET		; Return to the MAIN loop

; --- 4. Delay Subroutine ---
DELAY:	   MVI B,0FFH	; A simple delay loop
DEL_LOOP:  DCR B
           JNZ DEL_LOOP
           RET