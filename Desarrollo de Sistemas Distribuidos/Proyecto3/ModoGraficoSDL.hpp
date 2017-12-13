/*
	IPN - ESCOM
	Desarrollo de Sistemas Distribuidos
	4CM1

	=> ww ww ww

	ww.com/sistemasdistribuidos
*/

#include <SDL2/SDL.h>
#include <vector>
#include "Asteroide.hpp"

class ModoGraficoSDL
{
	public:
		ModoGraficoSDL(int, bool);
		~ModoGraficoSDL();
		void iniciar(const char *, int, int, int, int, int);
		void limpiarRender();
		void actualizar();
		void renderizar();
		void manejarEventos();
		void limpiar();
		void setRetardo(int);
		bool correr();
		bool wwMensajeError(const char *);
		Uint32 getTiempoJuego();
	private:
		int cantidad;
		bool corriendo, debug;
		bool init(const char *, int, int, int, int, int);
		SDL_Window *ventana;
		SDL_Renderer *renderizador;
		Asteroide *asteroide;
		std::vector<Asteroide> asteroides;
		std::vector<int> magnitudes;
};
