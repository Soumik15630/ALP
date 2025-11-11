; --- PROGRAM 1: MINIMAL TRANSMITTER ---
; Input:   Data in Accumulator (hard-coded here)
; Output:  Sends 1 start bit, 8 data bits, 1 stop bit on SOD pin
; Depends: BIT_DELAY subroutine

TX_START:  MVI A, 55H	; <<< SET DATA TO SEND HERE
           MVI C,08H	; 8 bits to send
           MVI B,A		; Store data in B
           
           ; --- Send Start Bit ---
           MVI A,00H	; Start bit (SOD=0)
           SIM		; Send start bit
           CALL BIT_DELAY
           
           MOV A,B		; Get data back into A

TX_LOOP:   RAR		; Rotate data LSB into Carry
           JC TX_ONE	; If Carry=1, send a '1'
           MVI A,00H	; Else, load 0 (SOD=0)
           JMP TX_SEND

TX_ONE:	   MVI A,40H	; Load 40H (SOD=1)

TX_SEND:   SIM		; Send data bit
           CALL BIT_DELAY
           DCR C		; Decrement bit counter
           JNZ TX_LOOP	; Loop for all 8 bits

           ; --- Send Stop Bit ---
           MVI A,0C0H	; Stop bit (SOD=1) and Enable SOD
           SIM		; Send stop bit
           CALL BIT_DELAY
           RET

; --- PROGRAM 2: MINIMAL RECEIVER ---
; Input:   Serial data on SID pin
; Output:  Received byte stored at 2500H
; Depends: BIT_DELAY, HALF_DELAY subroutines

RX_START:  MVI C,08H	; 8 bits to receive
           MVI B,00H	; Clear result register B

WAIT_START:RIM		; Read SID pin
           ANI 80H		; Mask SID bit
           JNZ WAIT_START ; Wait for SID to go LOW (Start Bit)

           ; --- Start Bit Detected ---
           CALL HALF_DELAY ; Wait 0.5 bit period
           CALL BIT_DELAY  ; Wait 1.0 bit period (Total 1.5)

RX_LOOP:   RIM		; Read SID pin
           RAR		; Rotate SID bit (in A) into Carry
           MOV A,B		; Get partial result
           RAR		; Rotate Carry into MSB of result
           MOV B,A		; Store new partial result
           
           CALL BIT_DELAY ; Wait 1 full bit period for next bit
           DCR C		; Decrement bit counter
           JNZ RX_LOOP

           ; --- All 8 bits received ---
           MOV A,B		; Move final result to A
           STA 2500H	; Store received byte
           RET

; --- Full Bit Delay ---
BIT_DELAY: MVI D,0FFH
DEL_LOOP:  DCR D
           JNZ DEL_LOOP
           RET
           
; --- Half Bit Delay (Only needed for Receiver) ---
HALF_DELAY:MVI D,080H
HALF_LOOP: DCR D
           JNZ HALF_LOOP
           RET