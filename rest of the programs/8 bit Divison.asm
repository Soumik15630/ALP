// Input:   8-bit Dividend at memory location 8050H
//          8-bit Divisor at memory location 8051H
// Output:  8-bit Quotient at memory location 8052H
//          8-bit Remainder at memory location 8053H
// ----------------------------------------------------------------
	   LDA 8051H	// Load Divisor into A
	   MOV B,A		// Store Divisor in B
	   LDA 8050H	// Load Dividend in A
	   MVI C,00H	// Initialize Quotient (C) to 0

LOOP:	   CMP B		// Compare Dividend (A) with Divisor (B)
	   JC END		// If A < B (Carry=1), jump to END
	   SUB B		// A = A - B (Subtract Divisor)
	   INR C		// Increment Quotient
	   JMP LOOP		// Repeat

END:	   STA 8053H	// Store the final value of A (Remainder) in 8053H
	   MOV A,C		// Move Quotient from C to A
	   STA 8052H	// Store Quotient in 8052H
	   HLT			// Halt the processor