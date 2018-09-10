
	AREA	ADAM,	CODE,	READONLY
		ENTRY
		
    	LDR	r1,=0x40000000	;load beginning at address 0x40000000 
		MOV	r2,#0			;r2 is i 
		MOV	r3,#100		    ;for the loop 100count
		MOV	r4,#1			;i set it as 'true'		
        BL L1
        BL L2		
stop	B	stop
		
L1	
		CMP	r2,r3		    ;unsigned int i=0; i<N+1; i++
		BLGE getmain		
		STRB r4,[r1],#1		;prime[i] = true
		ADD	r2,r2,#1			
		B	L1			
		
getmain       
		LDR	r1,=0x40000000
		MOV	r6,#2			;r6 is p
        MOV r10,#2		
		MUL	r7,r6,r6		;r7 = p*p
		STR r6,[r1],r5		;r5 = value in r1's address
		MUL	r9,r6,r10		;r9 is i for count 
		CMP	r5,r4			;check if the value is 1, 1 is true 
		LDR	r1,=0x40000000		;initialize r1 to 0x40000000
		LDRB r5,[r1],r9		;set the register r1 and to next element 
		BEQ	L3			    ;if it is true move to L3
L4		
	    ADD	r6,r6,#1		;increment r6 (loop counter) by 1
		CMP	r3,r7			;compare range N to r7 (P)
		BLE	L2		;if N is greater than r7, stay in the loop. Otherwise get out of the loop 
		B	getmain


L3
		MOV	r8,#0				;r8=0 which is false value 
		CMP	r3,r9				;compare loop with the range 
		ADD r9,r9,r6			;increase the value by p 
		BNE	L4				;if range is larger than count, stay in loop 
		STRB r8,[r1],r6		;if false, set the r1 to 0 
		B	L3
L2
		MOV	r6,#2			;r6 is p 
		LDR	r1,=0x40000000	;initialize r1 to the original address 
		MOV	r2,r1			;copy r1 to r2 
		LDRB r5,[r1],r3	    ;put the address after array 	
		
L5
		LDRB r5,[r2],#1		
		CMP	r5,#1					
		BCS	stop		
		B	L5				
		END
		
			
			