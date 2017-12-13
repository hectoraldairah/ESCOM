; 	IPN - ESCOM
;	Introducción a los Microcontroladores	
;	ww ww ww - escom.www.com/microcontroladores

.include "m48def.inc"
.def __www__regTmp1 = R16
.def __www__regTmp2 = R17
.def __www__regDato = R18
.def __www__regFinal = R19

; Vectores de interrupción
.org 0x000
	rjmp __www__iniciar
.org 0x012 // USART Rx completo (Recepción finalizada)
	rjmp __www__recepcionCompleta

__www__iniciar:
	; Inicializar Stack Pointer
	ldi __www__regTmp1, low(RAMEND)
	out SPL, __www__regTmp1
	ldi __www__regTmp1, high(RAMEND)
	out SPH, __www__regTmp1
	rjmp __www__main

	; Configurar USART en la pinche cucaracha rompebolas
	ldi __www__regTmp1, 0b00000010 // Establecemos el bit "U20n" (donde '0' corresponde al registro cero) para doblar la velocidad de transferencia asíncrona
	out USCR0A, __www__regTmp1 // Registro 0 de control "A"
	ldi __www__regTmp1, 0b00001100 // Habilitar transmisor y receptor USART
	out USCR0B, __www__regTmp1 // Registro 0 de control "B"
	sei

__www__recepcionCompleta:
	in __www__regDato, UDR0
	subi __www__regDato, 32 // Restar 32 al dato recibido
	rcall __www__setBit // Esperar hasta que los bits sean iguales
	mov __www__regFinal, __www__regDato
	reti // Habilita las interrupciones globales automáticamente

__www__setBit:
	mov __www__regTmp1, UCSR0A
	mov __www__regTmp2, UDRE0 // USART Data Register Empty
	cp __www__regTmp1, __www__regTmp2 // Comparar dos registros
	brne __www__setBit__noIgual
	ret

__www__setBit__noIgual:
	nop
	nop
	rjmp __www__setBit

__www__main:
	rjmp __www__main