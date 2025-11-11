// Input:   A block of data at 2000H
//          MVI C,03H defines the block size (3 bytes)
// Output:  The block is copied to memory starting at 3000H.
// ----------------------------------------------------------------
	   LXI H,2000H	// HL points to source block
	   LXI D,3000H	// DE points to destination block
	   MVI C,03H	// C is the byte counter

LOOP:	   MOV A,M		// A = [Source]
	   STAX D		// [Destination] = A
	   INX H		// Point to next source byte
	   INX D		// Point to next destination byte
	   DCR C		// Decrement counter
	   JNZ LOOP		// Repeat for all bytes
	   HLT