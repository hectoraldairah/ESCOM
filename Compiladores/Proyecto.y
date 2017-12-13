/*
	IPN - ESCOM
	Compiladores - 3CV5
	ww ww ww - wwwwww.com/compiladores
*/

/* Sección de declaraciones en C */
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "www_Generic_TablaSimbolos.h"

#ifdef __cplusplus
// Al compilar con G++ y linkear la librería de Flex, se produce un error a menos que indiquemos que se debe utilizar el compilador de C (no es válido 'g++ -lfl algo.yy.c')
extern "C"
{
#endif
	FILE *yyin;
	int yylex();
	int yyparse();
#ifdef __cplusplus
}
#endif

// Prototipos de la función
void yyerror(const char *);

// Tabla de símbolos
extern struct Simbolo tablaSimbolos[];
%}

/* Sección de definiciones de Bison */
// Con la estructura UNION, prescindimos de especificar el YYSTYPE (tipo de dato por defecto a utilizar en Bison, el cual puede ser int, double, char *, etc.) y en cambio podemos usar diferentes tipos de datos
%union{
	int www_valorEntero;
	float www_valorFlotante;
	char *www_valorString;
}
// Símbolos terminales
%token <www_valorString> www_TOKEN_STRING
%token <www_valorEntero> www_TOKEN_ENTERO
%token <www_valorFlotante> www_TOKEN_FLOTANTE
%token <www_valorString> www_TOKEN_VARIABLE
%token www_TOKEN_SUMA www_TOKEN_RESTA www_TOKEN_MULTIPLICACION www_TOKEN_DIVISION www_TOKEN_MODULO www_TOKEN_POTENCIA
%token www_TOKEN_ASIGNACION www_TOKEN_PARENTESIS_APERTURA www_TOKEN_PARENTESIS_CIERRE www_TOKEN_SEMICOLON
%token www_TOKEN_KEYWORD_ENTERO www_TOKEN_KEYWORD_DECIMAL www_TOKEN_KEYWORD_CADENA www_TOKEN_KEYWORD_FUNCION www_TOKEN_KEYWORD_SALIR
%token www_TOKEN_DECIMAL
%token www_TOKEN_LINEA
%token www_TOKEN_CAD
// Símbolos no terminales
%type <www_valorEntero> www_expresionEntera
%type <www_valorFlotante> www_expresionDecimal
%type <www_valorString> www_expresionString
%type <www_valorEntero> www_expresionVarEnt
%type <www_valorFlotante> www_expresionVarDec
%type <www_valorString> www_expresionVarStr
// Precedencia de operadores
%left www_TOKEN_SUMA www_TOKEN_RESTA
%left www_TOKEN_MULTIPLICACION www_TOKEN_DIVISION www_TOKEN_MODULO
%left www_TOKEN_POTENCIA

%%
/* Sección de reglas gramaticales (producciones de la gramática) */
www_entrada:
		/* Cadena vacía */
	|	www_entrada www_linea
;
www_linea:
		www_TOKEN_LINEA
	|	www_expresionString www_TOKEN_LINEA {printf("\t\tResultado [str]: %s\n", $1);};
	|	www_expresionEntera www_TOKEN_LINEA {printf("\t\tResultado [int]: %d\n", $1);} 
	|	www_expresionDecimal www_TOKEN_LINEA {printf("\t\tResultado [dec]: %f\n", $1);}
	|	www_expresionFuncion www_TOKEN_LINEA {printf("\t\tFuncion encontrada\n");}
	|	www_expresionDeclaracion www_TOKEN_LINEA {printf("\t\tDeclaracion encontrada\n"); www_DebugTS();}
	|	www_expresionAsignacion www_TOKEN_LINEA {printf("\t\tAsignacion encontrada\n"); www_DebugTS();}
	|	www_TOKEN_KEYWORD_SALIR www_TOKEN_LINEA {printf("Chau!\n"); exit(0);}
;
www_expresionString:
		www_TOKEN_STRING {$$ = $1;}
	|	www_TOKEN_STRING www_TOKEN_SUMA www_TOKEN_STRING {limpiarCadena($1); $$ = strcat($1, $3);}
	|	www_expresionVarStr {$$ = $1;}
;
www_expresionEntera:
		www_TOKEN_ENTERO {$$ = $1;}
	|	www_TOKEN_SUMA www_TOKEN_ENTERO {$$ = $2;}
	|	www_TOKEN_RESTA www_TOKEN_ENTERO {$$ = $2 * -1;}
	| 	www_expresionEntera www_TOKEN_SUMA www_expresionEntera {$$ = $1 + $3;}
	| 	www_expresionEntera www_TOKEN_RESTA www_expresionEntera {$$ = $1 - $3;}
	| 	www_expresionEntera www_TOKEN_MULTIPLICACION www_expresionEntera {$$ = $1 * $3;}
	| 	www_expresionEntera www_TOKEN_DIVISION www_expresionEntera {$$ = $1 / $3;}
	| 	www_expresionEntera www_TOKEN_MODULO www_expresionEntera {$$ = $1 % $3;}
	| 	www_expresionEntera www_TOKEN_POTENCIA www_expresionEntera {$$ = pow($1, $3);}
	|	www_expresionVarEnt {$$ = $1;}
;
www_expresionDecimal:
		www_TOKEN_FLOTANTE {$$ = $1;}
	|	www_TOKEN_SUMA www_TOKEN_FLOTANTE {$$ = $2;}
	|	www_TOKEN_RESTA www_TOKEN_FLOTANTE {$$ = $2 * -1;}
	| 	www_expresionDecimal www_TOKEN_SUMA www_expresionDecimal {$$ = $1 + $3;}
	| 	www_expresionDecimal www_TOKEN_RESTA www_expresionDecimal {$$ = $1 - $3;}
	| 	www_expresionDecimal www_TOKEN_MULTIPLICACION www_expresionDecimal {$$ = $1 * $3;}
	| 	www_expresionDecimal www_TOKEN_DIVISION www_expresionDecimal {$$ = $1 / $3;}
	| 	www_expresionDecimal www_TOKEN_MODULO www_expresionDecimal {$$ = (int) $1 % (int) $3;}
	| 	www_expresionDecimal www_TOKEN_POTENCIA www_expresionDecimal {$$ = pow($1, $3);}
	| 	www_expresionEntera www_TOKEN_SUMA www_expresionDecimal {$$ = (float) $1 + $3;}
	| 	www_expresionEntera www_TOKEN_RESTA www_expresionDecimal {$$ = (float) $1 - $3;}
	| 	www_expresionEntera www_TOKEN_MULTIPLICACION www_expresionDecimal {$$ = (float) $1 * $3;}
	| 	www_expresionEntera www_TOKEN_DIVISION www_expresionDecimal {$$ = (float) $1 / $3;}
	| 	www_expresionEntera www_TOKEN_MODULO www_expresionDecimal {$$ = (int) $1 % (int) $3;}
	| 	www_expresionEntera www_TOKEN_POTENCIA www_expresionDecimal {$$ = pow($1, $3);}
	| 	www_expresionDecimal www_TOKEN_SUMA www_expresionEntera {$$ = $1 + (float) $3;}
	| 	www_expresionDecimal www_TOKEN_RESTA www_expresionEntera {$$ = $1 - (float) $3;}
	| 	www_expresionDecimal www_TOKEN_MULTIPLICACION www_expresionEntera {$$ = $1 * (float) $3;}
	| 	www_expresionDecimal www_TOKEN_DIVISION www_expresionEntera {$$ = $1 / (float) $3;}
	| 	www_expresionDecimal www_TOKEN_MODULO www_expresionEntera {$$ = (int) $1 % (int) $3;}
	| 	www_expresionDecimal www_TOKEN_POTENCIA www_expresionEntera {$$ = pow($1, $3);}
	|	www_expresionVarDec {$$ = $1;}
;
www_expresionFuncion:
		www_TOKEN_KEYWORD_FUNCION www_TOKEN_KEYWORD_ENTERO www_TOKEN_VARIABLE www_TOKEN_PARENTESIS_APERTURA www_TOKEN_PARENTESIS_CIERRE www_TOKEN_SEMICOLON
	|	www_TOKEN_KEYWORD_FUNCION www_TOKEN_KEYWORD_DECIMAL www_TOKEN_VARIABLE www_TOKEN_PARENTESIS_APERTURA www_TOKEN_PARENTESIS_CIERRE www_TOKEN_SEMICOLON
	|	www_TOKEN_KEYWORD_FUNCION www_TOKEN_KEYWORD_CADENA www_TOKEN_VARIABLE www_TOKEN_PARENTESIS_APERTURA www_TOKEN_PARENTESIS_CIERRE www_TOKEN_SEMICOLON
;
www_expresionDeclaracion:
		www_TOKEN_KEYWORD_ENTERO www_TOKEN_VARIABLE www_TOKEN_SEMICOLON {if(www_InsertarEntero($2, 0) < 0) fprintf(stderr, "\t[Error: variable existente]\n");}
	|	www_TOKEN_KEYWORD_DECIMAL www_TOKEN_VARIABLE www_TOKEN_SEMICOLON {if(www_InsertarDecimal($2, 0.0) < 0) fprintf(stderr, "\t[Error: variable existente]\n");}
	|	www_TOKEN_KEYWORD_CADENA www_TOKEN_VARIABLE www_TOKEN_SEMICOLON {if(www_InsertarCadena($2, "") < 0) fprintf(stderr, "\t[Error: variable existente]\n");}
	|	www_TOKEN_KEYWORD_ENTERO www_expresionEntera www_TOKEN_ASIGNACION www_TOKEN_VARIABLE www_TOKEN_SEMICOLON {if(www_InsertarEntero($4, $2) < 0) fprintf(stderr, "\t[Error: variable existente]\n");}
	|	www_TOKEN_KEYWORD_DECIMAL www_expresionDecimal www_TOKEN_ASIGNACION www_TOKEN_VARIABLE www_TOKEN_SEMICOLON {if(www_InsertarDecimal($4, $2) < 0) fprintf(stderr, "\t[Error: variable existente]\n");}
	|	www_TOKEN_KEYWORD_CADENA www_expresionString www_TOKEN_ASIGNACION www_TOKEN_VARIABLE www_TOKEN_SEMICOLON {if(www_InsertarCadena($4, $2) < 0) fprintf(stderr, "\t[Error: variable existente]\n");}
;
www_expresionAsignacion:
		www_expresionEntera www_TOKEN_ASIGNACION www_TOKEN_VARIABLE {if(www_ActualizarEntero($3, $1) < 0) fprintf(stderr, "\t[Error: variable no existente]\n");}
	|	www_expresionDecimal www_TOKEN_ASIGNACION www_TOKEN_VARIABLE {if(www_ActualizarDecimal($3, $1) < 0) fprintf(stderr, "\t[Error: variable no existente]\n");}
	|	www_expresionString www_TOKEN_ASIGNACION www_TOKEN_VARIABLE {if(www_ActualizarCadena($3, $1) < 0) fprintf(stderr, "\t[Error: variable no existente]\n");}
;
www_expresionVarEnt:
		www_TOKEN_VARIABLE {int iii = www_BuscarElemento($1); if(iii > -1) $$ = tablaSimbolos[iii].valor.entero; else fprintf(stderr, "\t\t[Error: variable no encontrada]\n");}
;
www_expresionVarDec:
		www_TOKEN_DECIMAL www_TOKEN_VARIABLE {int iii = www_BuscarElemento($2); if(iii > -1) $$ = tablaSimbolos[iii].valor.decimal; else fprintf(stderr, "\t\t[Error: variable no encontrada]\n");}
;
www_expresionVarStr:
		www_TOKEN_CAD www_TOKEN_VARIABLE {int iii = www_BuscarElemento($2); if(iii > -1) $$ = tablaSimbolos[iii].valor.cadena; else fprintf(stderr, "\t\t[Error: variable no encontrada]\n");}
%%

/* Sección de código adicional */

// Definimos nuestra propia implementación del control de errores
void yyerror(const char *mensaje)
{
	fprintf(stderr, "\t[Error]: %s\n", mensaje);
}
// Nuestra función main()
int main(int argc, char **argv)
{
	yyin = stdin;

	do
	{
		yyparse();
		fflush(yyin);
	}
	while(!feof(yyin));

	return 0;
}