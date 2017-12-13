ww_VARIABLES ([a-zA-Z]|\_)+([a-zA-Z]|[0-9]|\_)*
ww_ENTEROS (\+|\-){0,1}[0-9]+
ww_DECIMALES {ww_ENTEROS}*\.{1}[0-9]+
ww_POTENCIAS ({ww_ENTEROS}|{ww_DECIMALES}|{ww_VARIABLES})\^({ww_ENTEROS}|{ww_DECIMALES}|{ww_VARIABLES})
ww_OPERADORES_MATEMATICOS_BASICOS ({ww_VARIABLES}|{ww_ENTEROS}|{ww_DECIMALES})(\+|\-|\*|\/)({ww_VARIABLES}|{ww_ENTEROS}|{ww_DECIMALES})
ww_OPERADORES_MATEMATICOS_MODULO (mod|MOD)\(({ww_ENTEROS}|{ww_DECIMALES}|{ww_VARIABLES})\,({ww_ENTEROS}|{ww_DECIMALES}|{ww_VARIABLES})\)
ww_OPERADORES_MATEMATICOS_RESULTADO {ww_VARIABLES}\=({ww_ENTEROS}|{ww_DECIMALES}|{ww_POTENCIAS}|{ww_OPERADORES_MATEMATICOS_BASICOS}|{ww_OPERADORES_MATEMATICOS_MODULO}|{ww_VARIABLES})
%%
{ww_VARIABLES} printf("Encontrada variable.\n");
{ww_ENTEROS} printf("Encontrado numero entero.\n");
{ww_DECIMALES} printf("Encontrado numero decimal.\n");
{ww_POTENCIAS} printf("Encontrada potencia.\n");
{ww_OPERADORES_MATEMATICOS_BASICOS} printf("Encontrada operacion matematica.\n");
{ww_OPERADORES_MATEMATICOS_MODULO} printf("Encontrada operacion modulo.\n");
{ww_OPERADORES_MATEMATICOS_RESULTADO} printf("Encontrada operacion asignacion.\n");
%%
int main()
{
	/*
	IPN - ESCOM
	ww ww ww - 3CV5
	Compiladores - ww.com/compiladores

	Eliminar este comentario si da errores:
		Variables:
			- Empiezan por una o más letras (min/may) o un guión bajo y pueden tener números, letras o guiones medios/bajos consecuentes
		Enteros
			- Pueden o no tener signo (+, -)
		Decimales
			- Pueden tener o no un número entero al inicio, solamente tienen un punto y al menos un número después del punto
		Potencias
			- Pueden ser números enteros o decimales (reales)
		Operaciones matemáticas
			- Los operadores matemáticos básicos se componen de números reales y se consideran solamente a operadores binarios
			- Una función módulo acepta dos argumentos separados por una coma dentro de paréntesis, los cuales son números reales
			- Una asignación de resultado siempre comienza por una variable seguida del operador y finalmente algún real, otro operador matemático o una potencia
	*/
	yylex();
	return 0;
}