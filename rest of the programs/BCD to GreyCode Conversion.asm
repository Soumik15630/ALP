// Input:   8-bit packed BCD number at 2000H
// Output:  8-bit Gray code equivalent at 2001H
// ----------------------------------------------------------------
	   LDA 2000H	// Load BCD number
	   CALL BCD_BIN	// Convert BCD to Binary (Result in A)
	   MOV B,A		// Store binary value in B
	   RRC			// A = A >> 1 (Right shift)
	   XRA B		// A = (A >> 1) XOR A (Gray code logic)
	   STA 2001H	// Store Gray code result
	   HLT
BCD_BIN:   MOV B,A		// Store BCD in B
	   ANI 0FH		// Isolate units digit
	   MOV C,A		// Store units in C
	   MOV A,B		// Get BCD back
	   ANI 0F0H		// Isolate tens digit
	   RRC			// Rotate right 4 times
	   RRC
	   RRC
	   RRC
	   MOV D,A		// Store tens digit in D
	   RLC			// A = A * 2
	   RLC			// A = A * 4
	   ADD D		// A = (Tens * 4) + Tens = Tens * 5
	   RLC			// A = (Tens * 5) * 2 = Tens * 10
	   ADD C		// A = (Tens * 10) + Units
	   RET			// Return with binary value in A