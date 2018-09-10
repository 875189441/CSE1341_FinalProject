RCC_APB2ENR	EQU	0x40021018
RCC_CRH		EQU	0x40011804
GPIOE_BSRR	EQU	0x40011810
Delay_Value	EQU	0x1000000

GPIOC_CRL	EQU	0x40011000
ADC1_SQR1	EQU	0x4001242C
ADC1_SQR2	EQU	0x40012430
ADC1_SQR3	EQU	0x40012434
ADC1_SMPR1	EQU	0x4001240C
ADC1_SMPR2	EQU	0x40012410
ADC1_CR1	EQU	0x40012404
ADC1_CR2	EQU	0x40012408
ADC1_SR		EQU	0x40012400
ADC1_DR		EQU	0x4001244C


	AREA JasonAdam,CODE, READONLY
		ENTRY
	
	LDR	r0, =RCC_APB2ENR
	LDR r1, =RCC_CRH
	LDR r2, =GPIOE_BSRR
	
	;RCC_APB2ENR | = 1 << 6
	;RCC_APB2ENR = (RCC_APB2ENR) or (1 << 6)
	LDR	r0, =RCC_APB2ENR
	LDR	r1,[r0]
	MOV	r2,#1
	LSL	r2,r2,#6
	ORR	r1,r1,r2
	STR	r1,[r0]
	
	;RCC_APB2ENR | = 1 << 6
	;RCC_APB2ENR = (RCC_APB2ENR) or (1 << 6)
	LDR	r0, =RCC_APB2ENR
	LDR	r1,[r0]
	MOV	r2,#1
	LSL	r2,r2,#9
	ORR	r1,r1,r2
	STR	r1,[r0]

	;GPIOC_CRL 8 = FFF0FFFF
	;GPIOC_CRL = GPIOC.CRL 8 (FFF0FFFF)
	LDR	r0, =GPIOC_CRL
	LDR	r2,[r0]
	LDR	r2,=0xFFF0FFFF
	AND	r1,r1,r2
	STR	r1,[r0]
	
	;ADC1_CR1 = 1 << 8
	LDR	r0, =ADC1_CR1
	MOV	r1,#1
	LSL	r1,r1,#8
	STR	r1,[r0]
	
	;ADC1_CR2 = (1<< 20) | (7 << 17) | (1 << 1) | (1 << 0)
	LDR	r0, =ADC1_CR2
	MOV	r1,#1
	LSL	r1,#20
	MOV	r2,#7
	LSL	r2,#17
	ORR	r1,r1,r2
	MOV	r2,#1
	LSL	r2,#1
	ORR	r1,r1,r2
	MOV	r2,#1
	LSL	r2,r2,#0
	ORR	r1,r1,r2
	STR	r1,[r0]
	
	;while(ADC_CR2 8 (1 << 3))
while	
		LDR	r0, =ADC1_CR2
		LDR	r1, [r0]
		MOV	r2,#1
		LSL	r2,r2,#3
		AND	r1,r1,r2
		CMP	r1,#0
		BNE	while
	
	;LDR	r4,[r0]
	;MOV r5,#1
	;LSL	r5,r5,#6
	;ORR	r4,r4,r5
	;STR	r4,[r0]
	
	;GPIOE_BSSR
	LDR	r4, =0x40
	STR	r4,[r0]
	LDR	r4, =0x33333333
	STR r4,[r1]
	
	
MainLoop	

	;if(ADC1_SR 8 (1 << 1)
iff	LDR	r0, =ADC1_SR
	LDR	r1, [r0]
	MOV	r2,#1
	LSL	r2,r2,#1
	;AND	r1,r1,#1
	AND	r1,r1,r2
	CMP	r1,#2
	BNE	iff
			
	;AD_cal = ADC1_DR 8 0x0FFF
	LDR	r0, =ADC1_DR
	LDR	r10,[r0]
	LDR	r3, =0xFFF
	AND	r10,r10,r0
	LSL	r10,r10,#8
	
	;LDR r3, =Delay_Value	;load delay value into r3
	LDR	r9, =0x100		;set the first bit of turning on section into 1
	MOV	r6,#0x8			;the counter

;Section for turn on 
TurnOn
	MOV	r7,r10			;move delay value into r7
	STR	r9,[r2]			;store value to BSRR to turn on desired led
delay1					;a loop for delay value1
	SUB	r7,r7,#1		;decrement the delay value by 1
	CMP r7,#0			;comapre the delay value to 0
	BNE	delay1			;stay in the loop if the delay value is not 0
	
	LSL r9,r9,#1		;shift the value in r5 to the left by 1 bit to turn on next led
	SUB r6,r6,#1		;decrement the counter
	CMP r6,#0			;compare the counter to 0
	BNE TurnOn			;if the counter does not equal to 0, stay in the loop
	
;MainDelay Section
	MOV	r7,r10			;load delay value into r7
MainDelay
	SUB	r7,r7,#1		;decrement the value in r7
	CMP r7,#0			;compare the value in r7 to 0
	BNE	MainDelay		;stay in the loop if the value in r7 is not 0
	
	
	;LDR	r3, =Delay_Value	;load delay value into r3
	LDR	r9,=0x01000000		;initialize the first bit for turning on leds
	MOV	r6,#0x8				;the counter
	
;TurnOff Section
TurnOff
	MOV r7,r10			;move delay value into r7
	STR r9,[r2]			;store value to BSRR to turn off desired led
;delay for turn off
delay2
	SUB r7,r7,#1		;decrement the delay value by 1
	CMP r7,#0			;comapre the delay value to 0
	BNE	delay2			;stay in the loop if the delay value is not 0
	
	LSL r9,r9,#1		;shift the value in r5 to the left by 1 bit to turn on next led
	SUB r6,r6,#1		;decrement the counter
	CMP	r6,#0			;compare the counter to 0
	BNE	TurnOff			;if the counter does not equal to 0, stay in the loop
	
	B	MainLoop		;branch to MainLoop
	
stop 	B 		stop
END