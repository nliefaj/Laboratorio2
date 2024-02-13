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
.DEF count=R24
//*******************************************************************
//CONFIGURACION
//*******************************************************************
MAIN:
	LDI ZH, HIGH(TABLA7SEG<<1)
	LDI ZL, LOW(TABLA7SEG<<1)
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

	SBI DDRB,PB5 ;HABILITANDO PB1 COMO SALIDA
	CBI PORTB, PB5 ;apagar el pb1 del puerto b

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

	IN r16, PINC//PinC presionado o no
	SBRS r16,PC1 
	RJMP btn2

reloj:
	IN R16,TIFR0
	SBRS R16,TOV0
	RJMP LOOP

mostrar:
	LDI R16,100 // carga el valor de desbordamiento
	OUT TCNT0,R16; carga el valor inicial al contador

	SBI TIFR0,TOV0

	INC R20
	CPI R20,10 //para que cumpla el segundo
	BRNE LOOP
	;CLR R20

	OUT PORTB,R20
	CLR R20
	RJMP LOOP

btn1:
	NOP
	CALL delaybounce//espera a que el botón no esté presionado, de lo contrario sigue con el resto
	SBIS PINC, PC0
	JMP btn1
	RJMP suma //llama a etiqueta de incrementar contador

btn2:
	NOP
	CALL delaybounce//espera a que el botón no esté presionado, de lo contrario sigue con el resto
	SBIS PINC, PC0
	JMP btn2
	RJMP resta //llama a etiqueta de incrementar contador

timer_0:
	LDI R16,(1<<CS02)|(1<<CS00)//configura el prescaler a 1024 //nombre del bit que quiero encender
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
	INC count
	CPI count,0b0001_0000
	BRGE overflow
	LDI ZH, HIGH(TABLA7SEG<<1)
	LDI ZL, LOW(TABLA7SEG<<1)
	ADD ZL,count
	LPM R16,Z //Load from program memory R16
	LSL R16
	OUT PORTD,R16
	;CALL COMPARE
	RJMP LOOP
	
//resta de 7SEG
resta:
	DEC count
	CPI count,0xFF
	BREQ reset
	;LDI ZH, HIGH(TABLA7SEG<<1)
	;LDI ZL, LOW(TABLA7SEG<<1)
	LDI R16,1
	SUB ZL,R16
	;ADD ZL,count
	LPM r16,Z
	LSL R16
	OUT PORTD,R16
	;CALL COMPARE
	RJMP LOOP

overflow:
	LDI count,0b0000
	LDI R16,15
	SUB ZL,R16
	LPM R16,Z
	LSL R16
	OUT PORTD,R16
	RJMP LOOP

reset:
	LDI count,0b0000
	LDI ZH, HIGH(TABLA7SEG<<1)
	LDI ZL, LOW(TABLA7SEG<<1)
	LPM R16,Z
	LSL R16
	OUT PORTD,R16
	RJMP LOOP

/*COMPARE:
	CP R20,R24
	BREQ LD_COMP
	JMP LOOP

LD_COMP:
	SBIS*/

//*******************************************************************
//TABLA DE VALORES
//*******************************************************************
TABLA7SEG: .DB 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71; Hacer tabla de verdad para ver bien los números


