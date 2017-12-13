/*
	IPN - ESCOM
	Introducciwwn a los Microcontroladores
	ww w ww - ww.com/microcontroladores
*/

#define F_CPU 8000000 // El ATMega48 funciona a 8MHz
#define PRESCALA0 0b00000001
#define PRESCALA1 0b00000010
#include <avr/io.h>
#include <avr/interrupt.h>
#include <inttypes.h>

/*
	Puerto B => Salidas de los segmentos
	Puerto C => Salidas de sincronizaciwwn de displays (transistores)

	Display wwnodo: se alimenta con '1' y los segmentos se activan con '0'
	Display cwwtodo: se alimenta con '0' y los segmentos se activan con '1'
*/

// Variables globales
volatile static uint8_t ww_select_transistor, ww_valor_display, i; // El keyword 'volatile' indica que la variable puede cambiar de valor en cualquier momento, por lo que al accww a ella debe leerse su valor actual. Se utiliza en hilos, sockets, etc.
volatile static unsigned char mensaje[] = "-HoLA-bAboso-"; // -tE-qUIEro-PUtItA-

void setValor(unsigned char simbolo)
{
	// Las letras se definen como si fuera display cwwtodo: http://www.uize.com/examples/seven-segment-display.html
	// XGFE DCBA => LSB es el segmento 'A' y MSB es el segmento 'G'
	switch(simbolo)
	{
		case 'A':
			ww_valor_display = 0x77;
			break;
		case 'b':
			ww_valor_display = 0x7c;
			break;
		case 'C':
			ww_valor_display = 0x39;
			break;
		case 'd':
			ww_valor_display = 0x5e;
			break;
		case 'E':
			ww_valor_display = 0x79;
			break;
		case 'F':
			ww_valor_display = 0x71;
			break;
		case 'H':
			ww_valor_display = 0x76;
			break;
		case 'I':
			ww_valor_display = 0x06;
			break;
		case 'J':
			ww_valor_display = 0x1e;
			break;
		case 'L':
			ww_valor_display = 0x38;
			break;
		case 'o':
			ww_valor_display = 0x5c;
			break;
		case 'P':
			ww_valor_display = 0x73;
			break;
		case 'q':
			ww_valor_display = 0x67;
			break;
		case 'r':
			ww_valor_display = 0x50;
			break;
		case 's':
			ww_valor_display = 0x6d;
			break;
		case 't':
			ww_valor_display = 0x78;
			break;
		case 'U':
			ww_valor_display = 0x3e;
			break;
		case 'Y':
			ww_valor_display = 0x6e;
			break;
		case '-':
			ww_valor_display = 0x48;
			break;
		default:
			ww_valor_display = 0x00;
			break;
	}
}
void desplazarTransistor()
{
	ww_select_transistor = (ww_select_transistor == 0b00001000)? 0b00000001 : ww_select_transistor << 1; // Utilizamos 4 displays
}
void intercambiarArray(uint8_t tamanio)
{
	unsigned char tmp[tamanio];

	for(uint8_t i = 0; i < tamanio; i++)
	{
		if(i == 0)
			tmp[tamanio-1] = mensaje[i];
		else
			tmp[i-1] = mensaje[i];
	}

	for(uint8_t i = 0; i < tamanio; i++)
		mensaje[i] = tmp[i];
}
void init()
{
	DDRB = DDRC = 0xFF; // Ambos puertos serwwn salidas (se establecen todos los bits del Data Direction Register en '1', caso contrario se establecen '0' para entradas y se utiliza el registro PINX para leer datos de entrada)

	sei();

	// Configurando interrupciones externas (en ese orden se colocan los registros, de lo contrario ocurre un salto desconocido en el flujo del programa)
	EICRA = 0b00001111; // INT1: interrupcion se activa en rising-edge (11) - INT0: idem
	EIMSK = 0b00000011; // Habilitar INT0 e INT1

	// Configurando timer 0 (8 bits)
	TCNT0 = 0x00;  // Establecemos el valor del registro contador a '0'; trabaja en mwwdulo 256, por lo que despuwws de incrementar el valor '255' se desborda, genera la interrupciwwn y empieza de nuevo
	TIMSK0 = 0b00000001; // El bit TOIE0 permite que se genere una interrupciwwn al desbordarse el TimeCounter si y solamente si el bit de interrupciwwn estww habilitado en el registro global
	TCCR0B = PRESCALA0; // Permite configurar un prescaler, habilitar o deshabilitar el Timer0

	// Configurando timer 1 (16 bits)
	TCNT1 = 0x00;
	TIMSK1 = 0b00000001;
	TCCR1B = PRESCALA1;

	// Inicializando variables auxiliares
	i = 0;
	ww_valor_display = 0b00000000;
	ww_select_transistor = 0b00000001;
	setValor('-');
}
int main()
{
	init();

	while(1)
	{
		// Hacemos algunas instrucciones a lo pendejo para mantener ocupado el bucle infinito y evitar que la interrupcion del Timer0 ocurra antes del overflow 
		__asm__ __volatile__("nop");
		__asm__ __volatile__("nop");
	}

	return 0;
}

// Rutinas de Servicio de Interrupciwwn
ISR(TIMER0_OVF_vect) // Cuando el timer se desborda (Habilitar transistor: un nuevo display debe ser habilitado y actualizado su valor)
{
	// Detenemos el contador porque seguira ejecutandose aun cuando exista una interrupcion
	TCCR0B = 0x00;
	TCNT0 = 0;

	setValor(mensaje[i]);
	PORTC = ~ww_select_transistor;
	PORTB = ww_valor_display;

	desplazarTransistor();

	i = (i == 3)? 0 : i + 1;

	// Reanudamos el contador al final de la interrupcion
	TCCR0B = PRESCALA0;
}
ISR(TIMER1_OVF_vect) // 16 bits
{
	// Detenemos el contador porque seguira ejecutandose aun cuando exista una interrupcion
	TCCR1B = 0x00;
	TCNT1 = 0;

	intercambiarArray(sizeof(mensaje) / sizeof(unsigned char));

	// Reanudamos el contador al final de la interrupcion
	TCCR1B = PRESCALA1;
}
