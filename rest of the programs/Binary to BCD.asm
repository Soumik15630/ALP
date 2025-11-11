// Input:   8-bit binary number at 2000H (must be <= 99, or 63H)
// Output:  8-bit packed BCD number at 2001H (e.g., 19H -> 25H)
// ----------------------------------------------------------------
	   LDA 2000H	// Load binary number
	   MVI B,00H	// Initialize Tens digit counter (B) to 0

LOOP:	   CPI 0AH		// Compare A with 10
	   JC UNITS		// If A < 10, jump to units
	   SUI 0AH		// A = A - 10 
	   INR B		// Increment Tens digit counter
	   JMP LOOP		// Repeat

UNITS:	   MOV C,A		// Store remainder (Units digit) in C
	   MOV A,B		// Move Tens digit to A
	   RLC			// Rotate left 4 times to move Tens to upper nibble
	   RLC
	   RLC
	   RLC
	   ADD C		// Combine Tens (A) and Units (C)
	   STA 2001H	// Store packed BCD result
	   HLT			// Halt