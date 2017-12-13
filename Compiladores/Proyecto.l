/*
	IPN - ESCOM
	Compiladores - 3CV5
	ww ww ww - wwwwww.com/compiladores
*/

/* Sección de declaraciones en C */
%{
#include "Proyecto.tab.h"
#define __www__DEBUG_REGLAS 1
#define __www__DEBUG_REGLAS_DEFAULT 0
%}

/* Sección de definiciones de Flex */
www_CADENAS \"[a-zA-Z]*\"
www_VARIABLES ([a-zA-Z]|\_)+([a-zA-Z]|\_)*
www_ENTEROS [0-9]+
www_DECIMALES [0-9]*\.{1}[0-9]+
%%

"entero" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Keyword: entero]\n"); return www_TOKEN_KEYWORD_ENTERO;}
"decimal" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Keyword: decimal]\n"); return www_TOKEN_KEYWORD_DECIMAL;}
"cadena" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Keyword: cadena]\n"); return www_TOKEN_KEYWORD_CADENA;}
"funcion" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Keyword: funcion]\n"); return www_TOKEN_KEYWORD_FUNCION;}
"chau" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Keyword: salir]\n"); return www_TOKEN_KEYWORD_SALIR;}
"+" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Suma]\n"); return www_TOKEN_SUMA;}
"-" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Resta]\n"); return www_TOKEN_RESTA;}
"*" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Multiplicacion]\n"); return www_TOKEN_MULTIPLICACION;}
"/" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Division]\n"); return www_TOKEN_DIVISION;}
"^" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Potencia]\n"); return www_TOKEN_POTENCIA;}
"%" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Modulo]\n"); return www_TOKEN_MODULO;}
"=>" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Asignacion]\n"); return www_TOKEN_ASIGNACION;}
"(" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Parentesis: apertura]\n"); return www_TOKEN_PARENTESIS_APERTURA;}
")" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Parentesis: cierre]\n"); return www_TOKEN_PARENTESIS_CIERRE;}
";" {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Semicolon]\n"); return www_TOKEN_SEMICOLON;}
"\." {return www_TOKEN_DECIMAL;}
"#" {return www_TOKEN_CAD;}
"\n" {return www_TOKEN_LINEA;}
{www_VARIABLES} {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Variable]\n"); yylval.www_valorString = yytext; return www_TOKEN_VARIABLE;}
{www_CADENAS} {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Cadena]\n"); yylval.www_valorString = yytext; return www_TOKEN_STRING;}
{www_ENTEROS} {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Entero]\n"); yylval.www_valorEntero = atoi(yytext); return www_TOKEN_ENTERO;}
{www_DECIMALES} {if(__www__DEBUG_REGLAS) fprintf(stdout, "\t[Decimal]\n"); yylval.www_valorFlotante = atof(yytext); return www_TOKEN_FLOTANTE;}
. {if(__www__DEBUG_REGLAS && __www__DEBUG_REGLAS_DEFAULT) fprintf(stderr, "\t[Regla por defecto]\n");}
%%

/* Sección de código adicional */