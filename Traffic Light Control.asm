// Input:   None. Runs in an infinite loop.
// Output:  Writes values to memory location 3000H (simulating a port).
//          Values represent light states (e.g., 21H, 22H, 0CH, 14H)
//          Uses long delays to simulate light timings.
// ----------------------------------------------------------------
START:	   MVI A,21H	// State 1 (e.g., NS Green, EW Red)
	   STA 3000H
	   CALL DELAY_30S

	   MVI A,22H	// State 2 (e.g., NS Yellow, EW Red)
	   STA 3000H
	   CALL DELAY_5S

	   MVI A,0CH	// State 3 (e.g., NS Red, EW Green)
	   STA 3000H
	   CALL DELAY_30S

	   MVI A,14H	// State 4 (e.g., NS Red, EW Yellow)
	   STA 3000H
	   CALL DELAY_5S
	   
	   JMP START	// Repeat the cycle

// --- 30 Second Delay (Approx) ---
DELAY_30S: MVI B,1EH	// 1EH = 30
OUTER_30:  MVI C,0FFH
MID_30:	   MVI D,0FFH
INNER_30:  DCR D
	   JNZ INNER_30
	   DCR C
	   JNZ MID_30
	   DCR B
	   JNZ OUTER_30
	   RET

// --- 5 Second Delay (Approx) ---
DELAY_5S:  MVI B,05H
OUTER_5:   MVI C,0FFH
MID_5:	   MVI D,0FFH
INNER_5:   DCR D
	   JNZ INNER_5
	   DCR C
	   JNZ MID_5
	   DCR B
	   JNZ OUTER_5
	   RET