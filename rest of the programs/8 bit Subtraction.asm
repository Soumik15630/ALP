// Input:   8-bit Minuend at memory location 8050H
//          8-bit Subtrahend at memory location 8051H
// Output:  8-bit result (Difference) at memory location 8052H
// ----------------------------------------------------------------
	   LDA 8051H	// Load Subtrahend from 8051H into A
	   MOV B,A		// Store Subtrahend in B
	   LDA 8050H	// Load Minuend from 8050H into A
	   SUB B		// A = A - B (Minuend - Subtrahend)
	   STA 8052H	// Store the result in 8052H
	   HLT			// Halt the processor