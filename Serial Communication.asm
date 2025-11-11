// --- PROGRAM 1: TRANSMITTER ---
// Input:   Data to send is set at line "MVI A, 55H".
// Output:  Simulates serial data on the 'SOD' pin.
// Format:  1 Start bit(0), 8 Data bits(LSB first), 1 Stop bit(1)
// ----------------------------------------------------------------
	   ORG 0000H
	   MVI A, 55H	// <<< SET DATA TO SEND HERE (e.g., 55H)
	   CALL TX_START
	   HLT			// Halt after transmission

TX_START:  MVI C,08H	// 8 bits to send
	   MVI B,A		// Store data in B
	   
	   // Send Start Bit
	   MVI A,00H	// Start bit (SOD=0)
	   SIM			// Send start bit
	   CALL BIT_DELAY
	   
	   MOV A,B		// Get data back into A

TX_LOOP:   RAR			// Rotate data LSB into Carry
	   JC TX_ONE	// If Carry=1, send a '1'
	   MVI A,00H	// Else, load 0 (SOD=0)
	   JMP TX_SEND

TX_ONE:	   MVI A,40H	// Load 40H (SOD=1)

TX_SEND:   SIM			// Send data bit
	   CALL BIT_DELAY
	   DCR C		// Decrement bit counter
	   JNZ TX_LOOP	// Loop for all 8 bits

TX_STOP:   MVI A,0C0H	// Stop bit (SOD=1) and Enable SOD
	   SIM			// Send stop bit
	   CALL BIT_DELAY
	   RET


// ----------------------------------------------------------------
// --- PROGRAM 2: RECEIVER ---
// Input:   Asynchronous serial data on the 'SID' pin.
//          (User must toggle SID pin in simulator I/O)
// Output:  The received 8-bit byte is stored at 2500H.
// ----------------------------------------------------------------
RX_START:  MVI C,08H	// 8 bits to receive
	   MVI B,00H	// Clear result register

WAIT_START:RIM			// Read SID pin
	   ANI 80H		// Mask SID bit
	   JNZ WAIT_START // Wait for SID to go LOW (Start Bit)

	   // --- Start Bit Detected ---
	   CALL HALF_DELAY // Wait 0.5 bit period
	   CALL BIT_DELAY  // Wait 1.0 bit period
	   // (Total 1.5 bit delay to sample middle of first data bit)

RX_LOOP:   RIM			// Read SID pin
	   RAR			// Rotate SID bit (in A) into Carry
	   MOV A,B		// Get partial result
	   RAR			// Rotate Carry into MSB of result
	   MOV B,A		// Store new partial result
	   
	   CALL BIT_DELAY // Wait 1 full bit period for next bit
	   DCR C		// Decrement bit counter
	   JNZ RX_LOOP

	   // --- All 8 bits received ---
	   MOV A,B		// Move final result to A
	   STA 2500H	// Store received byte
	   HLT			// Halt after reception


// ----------------------------------------------------------------
// --- SHARED SUBROUTINES ---
// ----------------------------------------------------------------

// --- Full Bit Delay ---
BIT_DELAY: MVI D,0FFH
DEL_LOOP:  DCR D
	   JNZ DEL_LOOP
	   RET
	   
// --- Half Bit Delay ---
HALF_DELAY:MVI D,080H
HALF_LOOP: DCR D
	   JNZ HALF_LOOP
	   RET