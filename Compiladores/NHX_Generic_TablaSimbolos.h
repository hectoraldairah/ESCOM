/*
	IPN - ESCOM
	Compiladores - 3CV5
	ww ww ww - wwwwww.com/compiladores
*/

#include <stdio.h>
#include <string.h>
#define __www__TS__MAXELEMENTOS 100
#define __www__TS__MAXVARNAME 256
#define __www__TIPO__ENTERO 1
#define __www__TIPO__DECIMAL 2
#define __www__TIPO__CADENA 3

// Implementación genérica de una tabla de símbolos para el prototipo de un compilador

struct Simbolo
{
	char variable[__www__TS__MAXVARNAME];
	unsigned short tipo;
	union
	{
		int entero;
		float decimal;
		char *cadena;
	} valor;
};

static struct Simbolo tablaSimbolos[__www__TS__MAXELEMENTOS];
static unsigned int indiceActual = 0;

// Busca un elemento y devuelve el índice o -1 si no existe
static int www_BuscarElemento(const char *nombreVar)
{
	int i;
	for(i = 0; i <= indiceActual; i++)
		if(strcmp(tablaSimbolos[i].variable, nombreVar) == 0)
			return i;
	return -1;
}

static void limpiarCadena(char *v)
{
	int i;
	for(i = 0; i < strlen(v); i++)
	{
		if(v[i] == '\n' || v[i] == ';' || v[i] == '+' || v[i] == '=')
			v[i] = '\0';
		else if(v[i] == '\"')
			v[i] = ' ';
	}
}

// Busca el registro de la variable en la base de datos, si existe arroja un error. Si no existe entonces crea un nuevo elemento
static int www_InsertarEntero(char *var, int val)
{
	limpiarCadena(var);
	if(www_BuscarElemento(var) < 0)
	{
		strcpy(tablaSimbolos[indiceActual].variable, var);
		tablaSimbolos[indiceActual].tipo = __www__TIPO__ENTERO;
		tablaSimbolos[indiceActual].valor.entero = val;
		indiceActual++;
		return 0;
	}

	return -1;
}
static int www_InsertarDecimal(char *var, float val)
{
	limpiarCadena(var);
	if(www_BuscarElemento(var) < 0)
	{
		strcpy(tablaSimbolos[indiceActual].variable, var);
		tablaSimbolos[indiceActual].tipo = __www__TIPO__DECIMAL;
		tablaSimbolos[indiceActual].valor.decimal = val;
		indiceActual++;
		return 0;
	}

	return -1;
}
static int www_InsertarCadena(char *var, char *val)
{
	limpiarCadena(var);
	if(www_BuscarElemento(var) < 0)
	{
		strcpy(tablaSimbolos[indiceActual].variable, var);
		tablaSimbolos[indiceActual].tipo = __www__TIPO__CADENA;
		tablaSimbolos[indiceActual].valor.cadena = val;
		indiceActual++;
		return 0;
	}

	return -1;
}
static int www_ActualizarEntero(char *var, int val)
{
	int indice = www_BuscarElemento(var);
	if(indice > -1)
	{
		tablaSimbolos[indice].valor.entero = val;
		return 0;
	}

	return -1;
}
static int www_ActualizarDecimal(char *var, float val)
{
	int indice = www_BuscarElemento(var);
	if(indice > -1)
	{
		tablaSimbolos[indice].valor.decimal = val;
		return 0;
	}

	return -1;
}
static int www_ActualizarCadena(char *var, char *val)
{
	/*
	if(www_BuscarElemento(var) < 0)
	{
		strcpy(tablaSimbolos[indiceActual].variable, var);
		tablaSimbolos[indiceActual].tipo = __www__TIPO__ENTERO;
		tablaSimbolos[indiceActual].valor->cadena = val;
		indiceActual++;
		return 0;
	}
	*/

	return -1;
}

// Depurar los datos de la base de datos
void www_DebugTS()
{
	int i;
	fprintf(stderr, "====== <tabla_simbolos> =====\n");
	for(i = 0; i <= indiceActual; i++)
		fprintf(stderr, "==\t[%d]. %s\n", i, tablaSimbolos[i].variable);
	fprintf(stderr, "====== <tabla_simbolos> =====\n");
}