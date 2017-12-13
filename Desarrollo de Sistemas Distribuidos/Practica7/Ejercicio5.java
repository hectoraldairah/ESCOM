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

//package com.ww.sistemasdistribuidos;

import java.math.*;

public class Ejercicio5
{
	public static void main(String args[])
	{
		double i = 0, seno = 0, coseno = 0, tangente = 0, logaritmo = 0, raiz = 0, max = Double.parseDouble(args[0]);
		
		while(i < max)
		{
			seno += Math.sin(i);
			coseno += Math.cos(i);
			tangente += Math.tan(i);
			logaritmo += Math.log10(i);
			raiz += Math.sqrt(i);
			i++;
		}
	}
}