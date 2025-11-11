// Input:   8-bit Gray code at 2000H
// Output:  8-bit packed BCD equivalent at 2001H
// ----------------------------------------------------------------
	   LDA 2000H		// Load Gray code
	   CALL GRAY_BIN	// Convert Gray to Binary (Result in A)
	   CALL BIN_BCD		// Convert Binary to BCD (Result in A)
	   STA 2001H		// Store BCD result
	   HLT

// --- Subroutine: Gray to Binary ---
// Logic:   Binary[i] = Gray[i] XOR Binary[i+1]
//          Iteratively XORs the gray code with itself shifted
// ----------------------------------------------------------------
GRAY_BIN:  MOV B,A		// B = Gray code
	   MVI C,07H	// Loop 7 times (for 8 bits)

LOOP:	   MOV A,B		// A = Gray
	   RRC			// A = Gray >> 1
	   XRA B		// A = Gray XOR (Gray >> 1)
	   MOV B,A		// B = new partial binary
	   DCR C
	   JNZ LOOP
	   MOV A,B		// Final binary result in A
	   RET

// --- Subroutine: Binary to BCD ---
// Input:   A (Binary, must be <= 99)
// Output:  A (Packed BCD)
// ----------------------------------------------------------------
BIN_BCD:   MVI C,00H	// C = Tens digit counter
	   MOV B,A		// Keep copy of A

LOOP_BCD:  CPI 0AH		// Compare with 10
	   JC BCD_UNITS	// If A < 10, done
	   SUI 0AH		// A = A - 10 (FIX)
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