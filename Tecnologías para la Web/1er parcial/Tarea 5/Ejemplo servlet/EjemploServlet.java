import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

public class EjemploServlet extends HttpServlet
{
	private String html;
	public void service(HttpServletRequest peticion, HttpServletResponse respuesta) throws ServletException, IOException
	{
		ServletOutputStream salida = respuesta.getOutputStream();
		respuesta.setContentType("text/html");

		html = "<!DOCTYPE html><!-- Por ww wwno ww --><html><head><title>Ejemplo de Servlets y HTML5</title> <link rel=stylesheet href=\"salida.css\" type=\"text/css\"></head><body><header><h2>Ejemplo de servlets y HTML5</h2></header><section>\""+peticion.getParameter("cualquiertexto")+"\"</section><footer>Por <strong>ww ww ww&ntilde;o</strong> | <ins>ww.com</ins></footer></body></html>";
		salida.println(html);
	}
}