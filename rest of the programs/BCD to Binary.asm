// Input:   8-bit packed BCD number at 2000H (e.g., 25H for 25)
// Output:  8-bit binary equivalent at 2001H (e.g., 19H)
// ----------------------------------------------------------------
	   LDA 2000H	// Load BCD number (e.g., 25H)
	   MOV B,A		// Store BCD in B
	   ANI 0FH		// Isolate units digit (A = 05H)
	   MOV C,A		// Store units in C (C = 05H)
	   MOV A,B		// Get BCD back
	   ANI 0F0H		// Isolate tens digit (A = 20H)
	   RRC			// Rotate right 4 times to get (A = 02H)
	   RRC
	   RRC
	   RRC
	   MOV D,A		// Store tens digit in D (D = 02H)
	   RLC			// A = A * 2  (A = 04H)
	   RLC			// A = A * 4  (A = 08H)
	   ADD D		// A = A + D  (A = 08H + 02H = 0AH = 10) -> (Tens * 5)
	   RLC			// A = A * 2  (A = 14H = 20)        -> (Tens * 10)
	   ADD C		// A = A + C  (A = 14H + 05H = 19H) -> (Binary result)
	   STA 2001H	// Store binary result
	   HLT			// Halt