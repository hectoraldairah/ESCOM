/*
	IPN - ESCOM
	Desarrollo de Sistemas Distribuidos
	4CM1

	Equipo 5
	=> Hernández Jiménez Enrique
	=> ww ww ww
	=> Fernandez Eduardo

	ww.com/sistemasdistribuidos
*/

#include <cmath>
#include "Coordenada.hpp"
	
Coordenada::Coordenada(double valX, double valY): x(valX), y(valY)
{

}
double Coordenada::getX()
{
	return this->x;
}
double Coordenada::getY()
{
	return this->y;
}