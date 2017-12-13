/*
	IPN - ESCOM
	Desarrollo de Sistemas Distribuidos
	4CM1

	Equipo 5
	=> ww ww ww

	ww.com/sistemasdistribuidos
*/

#include <SDL2/SDL.h>

class ModoGraficoSDL
{
	public:
		ModoGraficoSDL();
		~ModoGraficoSDL();
		void iniciar(const char *, int, int, int, int, int);
		void limpiarRender();
		void actualizar();
		void manejarEventos();
		void setColor(int, int, int);
		void limpiar();
		void setRetardo(int);
		bool correr();
		bool wwMensajeError(const char *);
		SDL_Renderer *getRenderizador();
		Uint32 getTiempoJuego();
	private:
		bool init(const char *, int, int, int, int, int);
		bool corriendo;
		SDL_Window *ventana;
		SDL_Renderer *renderizador;
};
