;
; Seven Segment Display.asm
;
; Created: 2/22/2020 3:48:24 PM
; Author : Leomar Duran
; Board  : ATmega324PB
; For    : ECE 3612, Spring 2020
;


;Start of immediate registers 16:31
.equ	IMED_START=0x0010

;Set the stack pointer
	ldi	r16,high(RAMEND)
	out	sph,r16
	ldi	r16, low(RAMEND)
	out	spl,r16

;Reset address counter
	ldi	zh,high(SRAM_START)
	ldi	zl, low(SRAM_START)

;  A
;F   B
;  G
;E   C
;  D

;Load the bitpatterns for 0 to 9 into registers r16:r25
	ldi	r16,10	;length (0:9)
	mov	r0,r16	;store in r0
	ldi	r16,0b00111111	;LED bit pattern for 0
	ldi	r17,0b00000110	;LED bit pattern for 1
	ldi	r18,0b01011011	;LED bit pattern for 2
	ldi	r19,0b01001111	;LED bit pattern for 3
	ldi	r20,0b01100110	;LED bit pattern for 4
	ldi	r21,0b01101101	;LED bit pattern for 5
	ldi	r22,0b01111101	;LED bit pattern for 6
	ldi	r23,0b00000111	;LED bit pattern for 7
	ldi	r24,0b01111111	;LED bit pattern for 8
	ldi	r25,0b01101111	;LED bit pattern for 9
	call	STORE_FROMR16_LENR0

;Load the bitpatterns for A to J into registers r16:r25
	ldi	r16,10	;length (A:J)
	mov	r0,r16	;store in r0
	ldi	r16,0b01110111	;LED bit pattern for A
	ldi	r17,0b01111100	;LED bit pattern for b
	ldi	r18,0b00111001	;LED bit pattern for C
	ldi	r19,0b01011110	;LED bit pattern for d
	ldi	r20,0b01111001	;LED bit pattern for E
	ldi	r21,0b01110001	;LED bit pattern for F
	ldi	r22,0b00111101	;LED bit pattern for G
	ldi	r23,0b01110110	;LED bit pattern for H
	ldi	r24,0b00110000	;LED bit pattern for I
	ldi	r25,0b00011110	;LED bit pattern for J
	call	STORE_FROMR16_LENR0

;Load the bitpatterns for K to t into registers r16:r25
	ldi	r16,10	;length (K:t)
	mov	r0,r16	;store in r0
	ldi	r16,0b01110101	;LED bit pattern for K
	ldi	r17,0b00111000	;LED bit pattern for L
	ldi	r18,0b01010101	;LED bit pattern for m
	ldi	r19,0b01010100	;LED bit pattern for n
	ldi	r20,0b01011100	;LED bit pattern for o
	ldi	r21,0b01110011	;LED bit pattern for P
	ldi	r22,0b01101011	;LED bit pattern for Q
	ldi	r23,0b01010000	;LED bit pattern for r
	ldi	r24,0b01101101	;LED bit pattern for S
	ldi	r25,0b01111000	;LED bit pattern for t
	call	STORE_FROMR16_LENR0

;Load the bitpatterns for U to Z into registers r16:r21
	ldi	r16,6	;length (U:Z)
	mov	r0,r16	;store in r0
	ldi	r16,0b00111110	;LED bit pattern for U
	ldi	r17,0b00101110	;LED bit pattern for V
	ldi	r18,0b00011101	;LED bit pattern for w
	ldi	r19,0b01001001	;LED bit pattern for X
	ldi	r20,0b01101110	;LED bit pattern for y
	ldi	r21,0b01011011	;LED bit pattern for Z
	call	STORE_FROMR16_LENR0

;Test the bit patterns (0:Z)
	;set PORTA to output
	ldi	r16,$FF
	out	DDRA,r16

REPEAT:
	;Reset address counter
	ldi	zh,high(SRAM_START)
	ldi	zl, low(SRAM_START)
	ldi	r17,36	;counter
NEXT_DIGIT:
	ld	r16,z+	;load next bit pattern
	out	PORTA,R16	;write the digit
	call	DELAY_1_2	;wait 1/2 a second
	dec	r17	;decrease the counter
	brne	NEXT_DIGIT	;if not zero, continue
	rjmp	REPEAT	;repeat indefinitely

;Infinite loop at end
end:	rjmp	end

;---------------APPROXIMATE 1/2 SECOND DELAY
DELAY_1_2:
	ldi r20,32
;Approximate (R20)/64 second delay
DELAY_1_64: LDI R21, 200
DELAY_1_64_L2: LDI R22, 250
DELAY_1_64_L3: NOP
	NOP
	DEC R22
	BRNE DELAY_1_64_L3
	DEC R21
	BRNE DELAY_1_64_L2
	DEC R20
	BRNE DELAY_1_64
	RET

;---------------Stores the registers starting at R16, using R0 as the length.
STORE_FROMR16_LENR0:
	;register counter
	ldi	yh,high(IMED_START)
	ldi	yl, low(IMED_START)
STORE_FROMR16_LENR0_LOOP:
	;load register into r1
	ld  r1,y+
	;store onto the address
	st  z+,r1
	dec	r0	;decrement
	brne	STORE_FROMR16_LENR0_LOOP	;branch until 0
	ret	;end of STORE_FROMR16_LENR0
