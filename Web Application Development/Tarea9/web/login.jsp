<%--
    @: Directiva => Modifican la arquitectura del programa
    !: Declaraciones => Permiten declarar m�todos, atributos, ...
    =: Expresiones => Permiten insertar valores en la salida
    : Scriptlets => Permiten embeber c�digo Java separando la vista de la business logic
--%>

<%@ page import="com.ww.tarea3.modelo.BaseDatos, com.ww.tarea3.control.Utilidad" %>
<%!
    String usuario, clave; // Aqu� no se reconoce el objeto request
    HttpSession sesion;
    Cookie cookie;
%>
<%
    BaseDatos.obtenerInstancia();
    Utilidad.obtenerInstancia();
    
    usuario = request.getParameter("sr");
    clave = request.getParameter("wd");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
    </head>
    <body>
        <%
            if(usuario != null && clave != null)
            {
                if(BaseDatos.checarLogin(usuario, clave))
                {
                    sesion = request.getSession();
                    sesion.setAttribute("usuario", usuario);
                    cookie = new Cookie("usuario", usuario);
                    cookie.setMaxAge(Utilidad.getTiempoSesion());

                    response.addCookie(cookie);
        %>
                    <a href="logout.jsp">Cerrar sesi�n: <strong><%= usuario %></strong></a>
        <%
                }
                else
                {
        %>
                    <h1>Login incorrecto</h1>
        <%
                }
            }
            else
            {
        %>
                <h1>Acceso denegado</h1>
        <%
            }
        %>
        
    </body>
</html>
