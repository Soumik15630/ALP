// Input:   None. Initializes its own time to 00:00:00.
//          Time is stored in:
//          2100H = Seconds (SS)
//          2101H = Minutes (MM)
//          2102H = Hours (HH)
// Output:  Continuously updates time in memory 2100H-2102H.
//          Outputs to simulator ports every "second":
//          Port 01H = Hours (HH)
//          Port 02H = Minutes (MM)
//          Port 03H = Seconds (SS)
// ----------------------------------------------------------------
	   LXI H,2100H	// Point to Seconds
	   MVI M,00H	// Set SS = 00
	   INX H		// Point to Minutes
	   MVI M,00H	// Set MM = 00
	   INX H		// Point to Hours
	   MVI M,00H	// Set HH = 00

MAIN:	   CALL DISPLAY	// Output current time to ports
	   CALL DELAY	// Wait for 1 second (approx)
	   
	   LHLD 2100H	// Load Seconds (L) and Minutes (H)
	   INR L		// Increment Seconds (L)
	   MOV A,L
	   CPI 3CH		// Compare Seconds with 60 (3CH)
	   JNZ SKIP1	// If SS < 60, skip reset
	   MVI L,00H	// Reset Seconds = 00
	   INR H		// Increment Minutes (H)
	   MOV A,H
	   CPI 3CH		// Compare Minutes with 60 (3CH)
	   JNZ SKIP1	// If MM < 60, skip reset
	   MVI H,00H	// Reset Minutes = 00
	   SHLD 2100H	// Store reset SS and MM
	   LHLD 2102H	// Load Hours (L) and [2103] (H)
	   INR L		// Increment Hours (L)
	   MOV A,L
	   CPI 18H		// Compare Hours with 24 (18H)
	   JNZ SKIP1	// If HH < 24, skip reset
	   MVI L,00H	// Reset Hours = 00
	   
SKIP1:	   SHLD 2100H	// Store updated SS and MM (or HH if just reset)
	   MOV A,L		// Get Hours back into A
	   STA 2102H	// Store updated Hours
	   JMP MAIN

DELAY:	   MVI B,0FH	// Shortened delay for simulation
OUTER:	   MVI C,0FFH
MIDDLE:	   MVI D,0FFH
INNER:	   DCR D
	   JNZ INNER
	   DCR C
	   JNZ MIDDLE
	   DCR B
	   JNZ OUTER
	   RET

DISPLAY:   LDA 2102H	// Load Hours
	   OUT 01H		// Output to Port 01
	   LDA 2101H	// Load Minutes
	   OUT 02H		// Output to Port 02
	   LDA 2100H	// Load Seconds
	   OUT 03H		// Output to Port 03
	   RET