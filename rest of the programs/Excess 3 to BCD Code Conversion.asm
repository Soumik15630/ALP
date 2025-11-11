// Input:   8-bit packed Excess-3 number at 2000H (e.g., 58H)
// Output:  8-bit packed BCD number at 2001H (e.g., 25H)
// ----------------------------------------------------------------
	   LDA 2000H	// Load Excess-3 number (e.g., 58H)
	   MVI B,33H	// Load 33H to subtract from both nibbles
	   SUB B		// A = 58H - 33H = 25H
	   DAA			// Decimal Adjust (handles borrows correctly)
	   STA 2001H	// Store BCD result
	   HLT			// Halt