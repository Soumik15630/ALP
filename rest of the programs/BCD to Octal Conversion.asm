// Input:   8-bit packed BCD number at 2000H
// Output:  8-bit Octal equivalent at 2001H
// ----------------------------------------------------------------
	   LDA 2000H
	   CALL BCD_BIN	// Convert BCD to Binary (Result in A)
	   CALL BIN_OCT	// Convert Binary to Octal (Result in A)
	   STA 2001H
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
BIN_OCT:   MOV B,A		// Store binary value in B
	   MVI C,00H	// Clear result
	   MVI D,02H    // Loop for 2 octal digits (6 bits)

LOOP:	   MOV A,B
	   ANI 07H		// Mask last 3 bits (one octal digit)
	   ADD C        // Add to packed result (this is flawed, should be ORA)
	   RRC			// Rotate result right 3 bits
	   RRC
	   RRC
	   MOV C,A		// Store packed result
	   MOV A,B		// Get binary value back
	   RRC			// Shift binary value right 3 bits
	   RRC
	   RRC
	   MOV B,A		// Store shifted binary value
	   DCR D
	   JNZ LOOP
	   MOV A,C
	   RET