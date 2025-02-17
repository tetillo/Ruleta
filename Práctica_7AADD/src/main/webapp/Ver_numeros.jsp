<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
       <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="Main.css">
<meta charset="UTF-8">
<title>Ver número de un día</title>
</head>
<body>
<h1>Ingrese un número del 0 al 36</h1>
<form method="post">
 <input type="number" id="num" name="num" min="0" max="36" required>
        <button type="submit">Comprobar</button>
    </form><br>
    <a href="Main.jsp">Volver</a>
    
    <%
    String num = request.getParameter("num");
    if (num != null && !num.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            // Cargar el driver de Oracle
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexión
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "hr", "hr");

            // Consulta para obtener los números registrados en la fecha seleccionada
            String sql = "SELECT count(*), dia FROM resultados WHERE numero = ? GROUP BY dia";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, num);
            rs = pstmt.executeQuery();
            out.println("<h2>Resultados para el número " + num + ":</h2>");
            
            while (rs.next()) {
           
                
            	int cantidad = rs.getInt(1);
                String fecha = rs.getString(2);
                out.println("<p>Veces que ha salido el " + num + " el día " + fecha + ": " + cantidad + "</p>");
              

              
                    }
             

        } catch (Exception e) {
            out.println("<p>Error al obtener los resultados: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            // Cerrar recursos
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    %>
</body>
</html>