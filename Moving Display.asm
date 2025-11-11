; Input:   8 characters stored starting at 2050H.
; Output:  Writes one character at a time to 3000H, with a delay.
;          Loops infinitely.
; Depends: DELAY subroutine
; ----------------------------------------------------------------
START:	   MVI B,08H	; Load B with count = 8 characters
	   LXI H,2050H	; HL points to source string (2050H)
	   LXI D,3000H	; DE points to display location (3000H)

SCROLL:	   MOV A,M		; Get character from source [HL]
	   STAX D		; Store character at destination [DE]
	   CALL DELAY	; Wait
	   
	   INX H		; Move to next character
	   DCR B		; Decrease count
	   JNZ SCROLL	; Loop until all 8 characters displayed
	   JMP START	; Repeat the entire sequence

; --- Subroutine: Delay ---
DELAY:	   MVI B,0AH
OUT_DEL:   MVI C,0FFH
MID_DEL:   MVI D,0FFH
INN_DEL:   DCR D
	   JNZ INN_DEL
	   DCR C
	   JNZ MID_DEL
	   DCR B
	   JNZ OUT_DEL
	   RET