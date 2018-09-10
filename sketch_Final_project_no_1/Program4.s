SRAM_BASE	EQU	0x40000000
		AREA	Program4,	CODE,	READONLY
		ENTRY
		
main	LDR	r1,=SRAM_BASE	;r1 = address of array and vector
		MOV	r2,#0			;r2 = 'i' in the first loop as a loop counter
		MOV	r3,#100		;r3 = the range 'N' in which prime numbers need to be found
		MOV	r4,#1			;r4 = 1, representing True in C++ language
		MOV	r6,#2			;r6 = 'P' in the second loop as the loop counter
		MOV	r10,#2
		BL	initialize
		BL	storeValue
stop	B	stop
		
initialize	
		CMP	r2,r3				;compare loop counter to the range N
		BLGE	getPrime		;if r2 is greater or equal to N, get out of the loop
		STRB	r4,[r1],#1		;store True values (1) in address of r1
		ADD	r2,r2,#1			;increment the loop counter by 1
		B	initialize			;stay in the loop whiel the condition is true
		
getPrime
		LDR	r1,=SRAM_BASE		;initialize r1 to 0x40000000
		MUL	r7,r6,r6			;r7 = square of 'P'
		LDRB	r5,[r1],r6		;r5 = value in r1's address
		MUL	r9,r6,r10			;r9 = 'i' in the nested loop as a loop counter
		CMP	r5,r4				;check if the value in r1 is True(1)
		LDR	r1,=SRAM_BASE		;initialize r1 to 0x40000000
		LDRB	r5,[r1],r9		;set r1 to next element
		BLE	changeValue			;if value is True, proceed to changeValue (a nested loop that change the values)
back1
		ADD	r6,r6,#1		;increment r6 (loop counter) by 1
		CMP	r3,r7			;compare range N to r7 (P)
		BLE	storeValue		;if N is greater than r7, stay in the loop. Otherwise get out of the loop 
		B	getPrime

changeValue
		MOV	r8,#0				;r8 = 0, representating False value
		CMP	r3,r9				;compare loop counter to N (the range)
		ADD	r9,r9,r6			;increment loop counter i by value of p
		BLT	back1				;if the range is larger than the loop counter, stay in the loop
		STRB	r8,[r1],r6		;if the counter is smaller than the range, set the value in address r1 to 0 (false)
		B	changeValue
		
		
storeValue
		MOV	r6,#2			;r6 = 'P', the loop counter
		LDR	r1,=SRAM_BASE	;initialize r1 into 0x40000000
		MOV	r2,r1			;copy the address in r1 to r2
		LDRB	r5,[r1],r3	;put the address of r1 after the array

back2
		LDRB	r5,[r2]		;get the value stored in address r2
		CMP	r5,#1			;compare value of each element to 1
		AND	r7,r2,#0xFF		;if the value of element is True, get the lowest 16 bits and store it into r7
		STREQ	r7,[r1],#4		;store the value of r7 into the vector
		LDRB	r4,[r2],#1		;get the value from the each array element, proceed to next element
		CMP	r6,r3			;compare the loop counter to the range
		BLGT	stop		;get out of the loop if the loop counter is greater than range
		ADD	r6,r6,#1		;increment the loop counter by 1
		B	back2		;stay in the loop if the condition is still met
		
		END
		
		