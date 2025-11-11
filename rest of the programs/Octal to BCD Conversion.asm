// Input:   8-bit packed Octal number at 2000H (e.g., 25H for 25 octal)
// Output:  8-bit packed BCD equivalent at 2001H (e.g., 25 octal -> 21H)
// ----------------------------------------------------------------
	   LDA 2000H
	   CALL OCT_BIN	// Convert Octal to Binary
	   CALL BIN_BCD	// Convert Binary to BCD
	   STA 2001H
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
	   RLC			// A = Tens * 2
	   RLC			// A = Tens * 4
	   RLC			// A = Tens * 8
	   ADD B		// A = (Tens * 8) + Units
	   RET

// --- Subroutine: Binary to BCD ---
// Input:   A (Binary, must be <= 99)
// Output:  A (Packed BCD)
// ----------------------------------------------------------------
BIN_BCD:   MVI C,00H	// C = Tens digit counter
	   MOV B,A		// Keep copy of A (for SUI)

LOOP_BCD:  CPI 0AH		// Compare with 10
	   JC BCD_UNITS	// If A < 10, done
	   SUI 0AH		// A = A - 10 
	   INR C		// Increment Tens
	   JMP LOOP_BCD	// Repeat

BCD_UNITS: MOV B,A		// B = Units digit (remainder)
	   MOV A,C		// A = Tens digit
	   RLC			// Shift Tens to upper nibble
	   RLC
	   RLC
	   RLC
	   ADD B		// A = Tens | Units
	   RET