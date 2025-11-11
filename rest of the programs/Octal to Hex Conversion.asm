// Input:   8-bit packed Octal number at 2000H (e.g., 25H for 25 octal)
//          (Assumes max 2 digits, e.g. 77 octal)
// Output:  8-bit binary equivalent at 2001H (e.g., 25 octal -> 15H)
// ----------------------------------------------------------------
	   LDA 2000H	// Load packed octal
	   CALL OCT_BIN	// Convert to binary
	   STA 2001H	// Store binary
	   HLT

// --- Subroutine: Octal to Binary ---
// Logic:   Binary = (Tens * 8) + Units
// ----------------------------------------------------------------
OCT_BIN:   MOV C,A		// Store octal in C
	   ANI 0FH		// Isolate units (e.g., 05H)
	   MOV B,A		// Store units in B
	   MOV A,C		// Get octal back
	   ANI 0F0H		// Isolate tens (e.g., 20H)
	   RRC			// Rotate 4 times
	   RRC
	   RRC
	   RRC			// A = tens (e.g., 02H)
	   
	   // Multiply A (Tens) by 8 (Shift left 3 times)
	   RLC
	   RLC
	   RLC			// A = Tens * 8
	   
	   ADD B		// A = (Tens * 8) + Units
	   RET