#!/usr/bin/env python2
# coding=utf-8

'''
	IPN - ESCOM
	Cryptography
	ww ww ww
	ww.com/cryptography
'''

from PIL import Image as mapabits

def leerTexto(fichero):
	return open(fichero, 'r').read()
def escribirTexto(datos, salida):
	f = open(salida, "w")
	f.write(datos)
	f.close()

def leerImagen(fichero, tamanio):
	ii = mapabits.open(fichero).convert("RGB")
	pixeles = []
	for v in ii.size:
		tamanio.append(v) # Arrays son mutables si y sólo si se utiliza append()
	for y in range(tamanio[1]):
		for x in range(tamanio[0]):
			pixeles.append(ii.getpixel((x,y)))
	return pixeles

def escribirImagen(datos, tamanio, salida):
	tupla = 0
	ii = mapabits.new("RGB", tamanio)
	for y in range(tamanio[1]):
		for x in range(tamanio[0]):
			ii.putpixel((x, y), datos[tupla])
			tupla +=  1
	ii.save(salida)
	ii.show()