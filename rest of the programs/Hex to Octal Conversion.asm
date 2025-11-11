// Input:   8-bit binary number at 2000H
// Output:  8-bit packed Octal number at 2001H
// Note:    This program only converts the lower 6 bits
//          of the input (0-63) into two octal digits (00-77).
// ----------------------------------------------------------------
	   LDA 2000H
	   CALL BIN_OCT	// Convert Binary to Octal
	   STA 2001H
	   HLT

// --- Subroutine: Binary to Octal (6-bit input) ---
// ----------------------------------------------------------------
BIN_OCT:   MOV B,A		// B = Binary Input
	   MVI C,00H	// C = Octal Result
	   MVI D,02H	// Loop for 2 octal digits

LOOP:	   MOV A,B		// Get binary
	   ANI 07H		// Mask last 3 bits (gets one octal digit)
	   ORA C		// Combine with previous result
	   MOV C,A		// Store packed result in C
	   
	   MOV A,B		// Get binary back
	   RRC			// Shift right 3 bits
	   RRC
	   RRC
	   MOV B,A		// Store shifted binary for next loop
	   
	   MOV A,C		// Get packed result
	   RRC			// Shift result right 4 bits to make space
	   RRC
	   RRC
	   RRC
	   MOV C,A      // Store shifted result
	   
	   DCR D
	   JNZ LOOP
	   
	   MOV A,C		// Get final result
	   RRC			// Final shift to align [D2][D1]
	   RRC
	   RRC
	   RRC
	   RET