// Input:       A block of data at START_ADDR.
//              START_ADDR EQU 2002H
//              BLOCK_SIZE EQU 05H (Set desired block size)
// Output:      The block 2002H...2006H is moved to 2003H...2007H.
//              Memory at 2002H is set to 55H.
// ----------------------------------------------------------------

START_ADDR EQU 2002H
BLOCK_SIZE EQU 05H
INSERT_VAL EQU 55H

	   // Point to end of source block
	   LXI H, START_ADDR + BLOCK_SIZE - 1
	   // Point to end of destination block
	   LXI D, START_ADDR + BLOCK_SIZE
	   MVI C, BLOCK_SIZE

SHIFT:	   MOV A,M		// A = [HL] (Source byte)
	   STAX D		// [DE] = A (Store at destination)
	   DCX H		// Move source pointer left
	   DCX D		// Move destination pointer left
	   DCR C		// Decrement counter
	   JNZ SHIFT	// Repeat for all bytes
	   
	   LXI H,START_ADDR	// Point to insertion address
	   MVI M,INSERT_VAL	// Insert the new byte
	   HLT