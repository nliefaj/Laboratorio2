;SEGSOLO
.include "M328PDEF.inc"
.cseg //comienza el codigo linea 0
.org 0x00
//*******************************************************************
//STACK
//*******************************************************************
LDI R16, LOW(RAMEND)
OUT SPL,R16
LDI R17,HIGH (RAMEND)
OUT SPH, R17
//*******************************************************************
//TABLA DE VALORES
//*******************************************************************
TABLA7SEG: .DB 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71; Hacer tabla de verdad para ver bien los números
//*******************************************************************
//CONFIGURACION
//*******************************************************************
MAIN:
	LDI ZH, HIGH(TABLA7SEG<<1)
	LDI ZL, LOW(TABLA7SEG<<1)
	ADD ZL, R16
	LPM R16,Z
SETUP:
	SBI DDRB,PB1 ;HABILITANDO PB1 COMO SALIDA
	CBI PORTB, PB1 ;apagar el pb1 del puerto b

	SBI DDRB,PB2 ;HABILITANDO PB1 COMO SALIDA
	CBI PORTB, PB2;apagar el pb1 del puerto b

	SBI DDRB,PB3 ;HABILITANDO PB1 COMO SALIDA
	CBI PORTB, PB3 ;apagar el pb1 del puerto b

	SBI DDRB,PB4 ;HABILITANDO PB1 COMO SALIDA
	CBI PORTB, PB4 ;apagar el pb1 del puerto b

	LDI R16,0b1111_1110
	OUT DDRD,r16; habilita el portD como salida

	LDI R16,0b0000_0000
	OUT DDRC,R16 //portc como inputs

	LDI R16,0b0011
	OUT PORTC,R16 ;pullup para los botones

	LDI R16,0
	STS UCSR0B,R16

	CALL timer_0
	LDI R20,0
	LDI R21,0b0000_0000

LOOP:
	//BOTONES
	IN r16, PINC//PinC presionado o no
	SBRS r16,PC0 
	RJMP btn1

	BRNE LOOP

	/*IN r16, PINC//PinC presionado o no
	SBRS r16,PC1 
	RJMP btn2

	RJMP LOOP*/

btn1:
	NOP
	CALL delaybounce//espera a que el botón no esté presionado, de lo contrario sigue con el resto
	SBIS PINC, PC0
	JMP btn1
	RJMP suma //llama a etiqueta de incrementar contador
/*
btn2:
	NOP
	CALL delaybounce
	SBIS PINC, PC1
	JMP btn2
	RJMP decr*/

delaybounce:
	LDI r16,100
	delay:
		DEC r16
		BRNE delay
	RET

//Sumador de 7SEG
suma:
	LDI R23,1
	ADD ZL,R23
	LPM r16,Z //Load from program memory
	LSL R16
	OUT PORTD,R16
	RJMP loop



