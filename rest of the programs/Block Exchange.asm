// Input:   A block of data at 2000H
//          A block of data at 3000H
//          MVI C,03H defines the block size (3 bytes)
// Output:  The contents of the two memory blocks are swapped.
// ----------------------------------------------------------------
	   LXI H,2000H	// HL points to start of Block 1
	   LXI D,3000H	// DE points to start of Block 2
	   MVI C,03H	// C is the byte counter

LOOP:	   MOV A,M		// A = [Block 1]
	   LDAX D		// Load A from [Block 2]
	   MOV B,A		// B = [Block 2]
	   MOV A,M		// A = [Block 1] (Reload)
	   STAX D		// [Block 2] = A (Original [Block 1])
	   MOV M,B		// [Block 1] = B (Original [Block 2])
	   INX H		// Point to next byte
	   INX D		// Point to next byte
	   DCR C		// Decrement counter
	   JNZ LOOP		// Repeat for all bytes
	   HLT