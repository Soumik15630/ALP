// Input:   8-bit packed BCD number at 2000H (e.g., 25H)
// Output:  8-bit packed Excess-3 number at 2001H (e.g., 58H)
// ----------------------------------------------------------------

	   LDA 2000H	// Load BCD number (e.g., 25H)
	   MVI B,33H	// Load 33H to add to both nibbles
	   ADD B		// A = 25H + 33H = 58H
	   DAA			// Decimal Adjust (ensures BCD-like carry, e.g., 29H + 33H = 5CH, DAA -> 62H)
	   STA 2001H	// Store Excess-3 result
	   HLT			// Halt