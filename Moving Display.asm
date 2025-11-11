// Input:   A string of 8 characters (defined by MVI B,08H)
//          stored in memory starting at 2050H.
// Output:  Writes one character at a time to memory 3000H.
//          Loops infinitely, "scrolling" the 8-char string.
// ----------------------------------------------------------------
START:	   MVI B,08H	// Load B with count = 8 characters
	   LXI H,2050H	// HL points to source string
	   LXI D,3000H	// DE points to display/output location

SCROLL:	   PUSH B		// Save registers
	   PUSH H
	   PUSH D
	   CALL DISP_CHAR
	   CALL DELAY
	   POP D
	   POP H
	   POP B
	   INX H		// Move to next character
	   DCR B		// Decrease count
	   JNZ SCROLL	// Loop until all 8 characters displayed
	   JMP START	// Re-initialize and loop infinitely

// --- Subroutine: Display Character ---
DISP_CHAR: MOV A,M		// A = [HL] (read data)
	   STAX D		// Store A into [DE]
	   RET
	   
// --- Subroutine: Delay ---
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