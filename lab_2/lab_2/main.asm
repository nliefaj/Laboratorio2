//******************************************************************
/*
Universidad del VAlle de Guatemala
IE2023:Programacion de microcontroladores
Proyecto: laboratorio2
Creado: 2/7/2024 2:37:54 PM
Autor: lefaj : Nathalie Fajardo
*/
//*******************************************************************
//ENCABEZADO
//*******************************************************************
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
	IN R16,TIFR0
	CPI R16,(1<<TOV0)
	BRNE LOOP

	LDI R16,100
	OUT TCNT0,R16; carga el valor inicial al contador

	SBI TIFR0,TOV0

	INC R20
	CPI R20,10
	LSL R20
	OUT PORTB,R20
	LSR R20
	BRNE LOOP

	CLR R20

	//BOTONES
	IN r16, PINC//PinC presionado o no
	SBRS r16,PC0 
	RJMP btn1

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

timer_0:
	LDI R16,(1<<CS02)|(1<<CS00)
	OUT TCCR0B,R16
	
	LDI R16,100
	OUT TCNT0,R16
	
	RET 

delaybounce:
	LDI r16,100
	delay:
		DEC r16
		BRNE delay
	RET

//Sumador de 7SEG
suma:
	LDI 23,
	ADD ZL,1
	LPM r16,Z //Load from program memory
	LSL R16
	OUT PORTD,R16



