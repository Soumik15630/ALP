// Input:   User must trigger the RST 5.5 interrupt in the simulator.
// Output:  
//   Main Loop: Writes AAH, ABH, AAH, ABH... to 2100H and 2101H.
//   On RST 5.5:
//     1. Jumps to ISR at 002CH.
//     2. Writes 55H to memory 2110H.
//     3. Outputs FFH to Port 00H.
//     4. Returns to the main loop.
// ----------------------------------------------------------------
	   LXI SP,2500H	// Initialize Stack Pointer
	   MVI A,0CH	// 1100: EI, M7.5, M6.5, M5.5 (Unmask RST 5.5)
	   SIM			// Set Interrupt Mask
	   EI			// Enable Interrupts
	   
	   ORG 002CH	// === ISR for RST 5.5 ===
	   PUSH PSW		// Save registers
	   PUSH B
	   PUSH D
	   PUSH H
	   MVI A,55H	// ISR: Load 55H
	   STA 2110H	// Store at 2110H
	   CALL DELAY	// Wait
	   MVI A,0FFH	// ISR: Load FFH
	   OUT 00H		// Output to Port 00H
	   POP H		// Restore registers
	   POP D
	   POP B
	   POP PSW
	   EI			// Re-enable interrupts
	   RET			// Return from interrupt
	   // === End of ISR ===
	   
	   ORG 0100H    // === Main Program Start ===
MAIN:	   MVI A,0AAH	// Load AAH
	   STA 2100H	// Store in 2100H
	   INR A		// A = ABH
	   STA 2101H	// Store in 2101H
	   JMP MAIN		// Repeat indefinitely

DELAY:	   MVI B,0FFH
DEL_LOOP:  DCR B
	   JNZ DEL_LOOP
	   RET