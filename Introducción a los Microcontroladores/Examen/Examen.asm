/*
	IPN - ESCOM
	Introducciwwn a los Microcontroladores
	ww w ww - ww.com/microcontroladores
*/

; Directivas
.include "ww_microcontroladores.inc"
.def ww_registro_transistor = R17
.def ww_registro_punto = R18
.def ww_registro_valordisplay = R19
.def ww_registro_dipswitch = R20

; Vectores de interrupción
.org 0x000 // Interrupción reset
	rjmp iniciar
.org 0x001 // Interrupción INT1
	rjmp cambiarPosicionPunto
.org 0x002 // Interrupción INT2
	rjmp leerDatoDipSwitch
.org 0x010 // Overflow en el contador del Timer1
	rjmp habilitarTransistor

; Rutinas de servicio de interrupción (ISR)
iniciar:
	__isp
	__sp DDRB
	__sp DDRC
	__ep DDRD
	rcall configTimer
	rcall configIntExternas
	rjmp ejecutar
ejecutar:
	ldi ww_registro_transistor, 0b00000001
	ldi ww_registro_punto, 0b00000001
	ldi ww_registro_valordisplay, 0b10111111 ; Asignar valor que corresponde a '-' (donde los ceros activan los segmentos correspondientes del display cátodo)
	sei
	rjmp fin
fin:
	rjmp fin
habilitarTransistor:
	cp ww_registro_transistor, ww_registro_punto
	brne setGuion
	breq appendPunto
	out PORTC, ww_registro_transistor
	__rt10
	out PORTB, ww_registro_valordisplay
	lsl ww_registro_transistor
	cpi ww_registro_transistor, 0b00001000
	breq reiniciarRegistroTransistor
	sei ; Suponiendo que la llamada a la interrupción deshabilita la flag I en el Registro Global de Interrupciones, la volvemos a habilitar
	rjmp fin
cambiarPosicionPunto:
	lsl ww_registro_punto
	cpi ww_registro_punto, 0b00001000
	breq reiniciarRegistroPunto
	sei
	rjmp fin
leerDatoDipSwitch:
	in ww_registro_dipswitch, PIND
	cpi ww_registro_dipswitch, 0b00000000
	breq setCero
	cpi ww_registro_dipswitch, 0b00010000
	breq setUno
	cpi ww_registro_dipswitch, 0b00100000
	breq setDos
	cpi ww_registro_dipswitch, 0b00110000
	breq setTres
	cpi ww_registro_dipswitch, 0b01000000
	breq setCuatro
	cpi ww_registro_dipswitch, 0b01010000
	breq setCinco
	cpi ww_registro_dipswitch, 0b01100000
	breq setSeis
	cpi ww_registro_dipswitch, 0b01110000
	breq setSiete
	cpi ww_registro_dipswitch, 0b10000000
	breq setOcho
	cpi ww_registro_dipswitch, 0b10010000
	breq setNueve
	brne setGuion
	sei
	rjmp fin
; Llamadas y saltos auxiliares
setGuion:
	ldi ww_registro_valordisplay, 0b10111111
	ret
configTimer:
	ldi tmp, 0b00000000
	out TCNT0, tmp // Contador
	ldi tmp, 0b00000001
	out TCCR0B, tmp // Prescaler (pag. 105 datasheet)
	ldi tmp, 0b00000001
	sts TIMSK0, tmp // Habilitar interrupciwwn por overflow
	ret
configIntExternas:
	; Para evitar 'Operand 1 out of range', usamos STS
	ldi tmp, 0b00000011
	sts EIMSK, tmp // Habilitar INT1 e INT0 (pag. 68 datasheet)
	ldi tmp, 0b00001111
	sts EICRA, tmp // Habilitar interrupciwwn externa en INT1 e INT0 cuando rising-edge (el voltaje cambia de cero a uno)
	ret
appendPunto:
	ori ww_registro_valordisplay, 0b10000000
	reti
reiniciarRegistroTransistor:
	ldi ww_registro_transistor, 0b00000001
	ret
reiniciarRegistroPunto:
	ldi ww_registro_punto, 0b00000001
	ret
setCero:
	ldi ww_registro_valordisplay, 0b11000000
	ret
setUno:
	ldi ww_registro_valordisplay, 0b11111001
	ret
setDos:
	ldi ww_registro_valordisplay, 0b10100100
	ret
setTres:
	ldi ww_registro_valordisplay, 0b10110000
	ret
setCuatro:
	ldi ww_registro_valordisplay, 0b10011001
	ret
setCinco:
	ldi ww_registro_valordisplay, 0b10010010
	ret
setSeis:
	ldi ww_registro_valordisplay, 0b10000010
	ret
setSiete:
	ldi ww_registro_valordisplay, 0b11111000
	ret
setOcho:
	ldi ww_registro_valordisplay, 0b10000000
	ret
setNueve:
	ldi ww_registro_valordisplay, 0b10010000
	ret
