#####################################
## IPN - ESCOM
## Compiladores - 3CV5
## ww ww ww - wwwwww.com/compiladores
#####################################

www_CC = gcc
www_LEX = flex
www_YACC = bison
www_CC_FLAGS = -lfl -g -lm
www_LEX_FLAGS = 
www_YACC_FLAGS = -d

# Unificar todos los componentes en nuestra aplicación final (vinculando la librería de Flex)
#lex.yy.c proyecto.tab.c proyecto.tab.h
ProyectoCompiladores: AnalizadorLexico AnalizadorSintactico
	$(www_CC) $(www_CC_FLAGS) -o proyecto www_Generic_TablaSimbolos.h Proyecto.tab.h Proyecto.tab.c lex.yy.c

# Generar el código para el analizador sintáctico
AnalizadorSintactico: Proyecto.y
	$(www_YACC) $(www_YACC_FLAGS) Proyecto.y

# Generar el código para el analizador léxico
AnalizadorLexico: Proyecto.l
	$(www_LEX) $(www_LEX_FLAGS) Proyecto.l

# Limpiar basura
Limpiador:
	rm Proyecto.tab.h Proyecto.tab.c lex.yy.c proyecto