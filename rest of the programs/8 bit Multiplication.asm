// Input:   8-bit Multiplicand at 8050H
//          8-bit Multiplier at 8051H
// Output:  8-bit Product at 8052H
// ----------------------------------------------------------------
	   LDA 8050H	// Load Multiplicand into A
	   MOV B,A		// Store Multiplicand in B
	   LDA 8051H	// Load Multiplier into A
	   MOV C,A		// Store Multiplier in C (as counter)
	   MVI A,00H	// Initialize Accumulator (Product) to 0

LOOP:	   ADD B		// Product = Product + Multiplicand
	   DCR C		// Decrement Multiplier (counter)
	   JNZ LOOP		// If counter not zero, add again
	   STA 8052H	// Store 8-bit product in 8052H
	   HLT			// Halt the processor