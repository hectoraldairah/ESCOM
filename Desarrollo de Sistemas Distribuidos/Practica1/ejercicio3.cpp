/*
	IPN - ESCOM
	Desarrollo de Sistemas Distribuidos
	4CM1

	Equipo 5
	=> Enrique Hernández Jiménez
	=> ww ww ww

	ww.com/sistemasdistribuidos
*/

#include <iostream>
using namespace std;

int main()
{
	int c = 20;
	double f;

	f = (9/5) * c + 32.0;
	cout << "Temperatura = " << f << endl;
	
	static_cast<double> (c);
	f = (9.0/5.0) * c + 32.0;
	cout << "Temperatura = " << f << endl;

	return 0;
}
