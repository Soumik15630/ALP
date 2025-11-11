; Input:   2201H: Requested Floor (User must set this)
; Internal:2200H: Current Floor (Starts at 01H)
; Output:  Port 01H: Displays Current Floor
;          Port 02H: 01H (Open) then 00H (Close)
; ----------------------------------------------------------------

	   MVI A,01H	; Set initial floor
	   STA 2200H	; Store Current Floor = 01H
	   MVI A,00H	; Clear initial request
	   STA 2201H	; Store Requested Floor = 00H

; --- Main loop: Waits for a request ---
MAIN:	   LDA 2201H	; Load Requested Floor
	   ORA A		; Check if Request is 0
	   JZ MAIN		; If 0, wait for a request
	   CALL SCAN_REQ	; If not 0, service request
	   JMP MAIN		; Loop back to wait

; --- Service request: Decide where to move ---
SCAN_REQ:  LDA 2201H	; Load Requested Floor
	   MOV B,A		; Store in B
	   LDA 2200H	; Load Current Floor
	   CMP B		; Compare Current (A) with Requested (B)
	   JZ AT_FLOOR	; If equal, open door
	   JP MOVE_DOWN	; If A > B (Positive), move down
	   JMP MOVE_UP	; If A < B, move up

MOVE_UP:   INR A		; A = A + 1
	   STA 2200H	; Update Current Floor
	   JMP MOVE_EL	; Show movement
	   
MOVE_DOWN: DCR A		; A = A - 1
	   STA 2200H	; Update Current Floor
	   JMP MOVE_EL	; Show movement

; --- Reached destination floor ---
AT_FLOOR:  CALL DOOR_CTRL ; Operate door
	   MVI A,00H	; Clear the request
	   STA 2201H	; Store 00H in Requested Floor
	   RET

; --- Show movement on Port 01 ---
MOVE_EL:   LDA 2200H	; Load Current Floor
	   OUT 01H		; Output to Port 01
	   CALL DELAY	; Simulate travel time
	   RET

; --- Open and close door on Port 02 ---
DOOR_CTRL: MVI A,01H	; Door Open
	   OUT 02H		; Output to Port 02
	   CALL DELAY	; Hold door open
	   CALL DELAY
	   MVI A,00H	; Door Close
	   OUT 02H		; Output to Port 02
	   CALL DELAY
	   RET

; --- Standard Delay ---
DELAY:	   MVI B,0FFH
DEL_LOOP:  DCR B
	   JNZ DEL_LOOP
	   RET