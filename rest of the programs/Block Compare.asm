// Input:   A block of data at 2000H
//          A block of data at 3000H
//          MVI C,03H defines the block size (3 bytes)
// Output:  Program halts. Check simulator flags for result:
//          Zero Flag (Z) = 1 : Blocks are EQUAL
//          Zero Flag (Z) = 0 : Blocks are NOT EQUAL
// ----------------------------------------------------------------
	   LXI H,2000H	// HL points to start of Block 1
	   LXI D,3000H	// DE points to start of Block 2
	   MVI C,03H	// C is the byte counter

LOOP:	   MOV A,M		// Load byte from Block 1 into A
	   LDAX D		// Load byte from Block 2 into A (via DE)
	   MOV B,A		// Store Block 2 byte in B
	   MOV A,M		// Reload Block 1 byte into A
	   CMP B		// Compare A (Block 1) with B (Block 2)
	   JNZ NOTEQUAL	// If not equal (Z=0), jump
	   INX H		// Point to next byte in Block 1
	   INX D		// Point to next byte in Block 2
	   DCR C		// Decrement counter
	   JNZ LOOP		// If counter not zero, repeat
	   JMP EQUAL	// If loop finishes, all bytes were equal

NOTEQUAL: HLT		// Halt (Z flag will be 0)

EQUAL:	   HLT		// Halt (Z flag will be 1)