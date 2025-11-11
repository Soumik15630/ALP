// Input:   8-bit number at memory location 8050H
//          8-bit number at memory location 8051H
// Output:  8-bit sum at memory location 8052H (Carry is ignored)
// ----------------------------------------------------------------
	   LDA 8050H	// Load the first number from 8050H into A
	   MOV B,A		// Store it in B
	   LDA 8051H	// Load the second number from 8051H into A
	   ADD B		// Add the content of B (first number) to A
	   STA 8052H	// Store the 8-bit result in 8052H
	   HLT			// Halt the processor