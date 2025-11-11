// Input:       A block of data starting at START_ADDR.
//              START_ADDR EQU 2002H
//              BLOCK_SIZE EQU 05H (Set desired size to shift)
// Output:      The block from 2003H...2007H is moved to 2002H...2006H
// ----------------------------------------------------------------
START_ADDR EQU 2002H
BLOCK_SIZE EQU 05H

	   LXI H,START_ADDR	// HL = Destination (2002H)
	   MVI C,BLOCK_SIZE	// C = Counter (5)

SHIFT:	   INX H		// HL = Source (e.g., 2003H)
	   MOV A,M		// A = [Source]
	   DCX H		// HL = Destination (e.g., 2002H)
	   MOV M,A		// [Dest] = A
	   INX H		// HL = Source (e.g., 2003H)
	   DCR C		// Decrement counter
	   JNZ SHIFT	// Loop until block is shifted
	   HLT