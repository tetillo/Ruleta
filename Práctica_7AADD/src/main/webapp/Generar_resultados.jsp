<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ page import="java.sql.*, java.util.Random" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="Main.css">
<meta charset="UTF-8">
<title>Girar la rule</title>
</head>
<body>
  <form method="post">
        <h1>Ingrese una fecha (dd/mm/yyyy):</h1><br>
        <input type="text" id="fecha" name="fecha" pattern="\d{2}/\d{2}/\d{4}" placeholder="dd/mm/yyyy" required>
        <button type="submit">Finalizar</button>
    </form><br>
    <a href="Main.jsp">Volver</a>
   <%
    // Obtener la fecha del formulario
    String fecha = request.getParameter("fecha");
    
    if (fecha != null && !fecha.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        Random rand = new Random();

        try {
            // Cargar el driver de Oracle
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexión
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "hr", "hr");

            // Insertar los 500 valores en la tabla "resultados"
            String sql = "INSERT INTO resultados (dia, orden, numero) VALUES (TO_DATE(?, 'DD/MM/YYYY'), ?, ?)";
            pstmt = conn.prepareStatement(sql);

            for (int i = 1; i <= 500; i++) {
                int numeroAleatorio = rand.nextInt(37); // Genera un número entre 0 y 36

                pstmt.setString(1, fecha);  // Fecha ingresada
                pstmt.setInt(2, i);         // Posición en el bucle
                pstmt.setInt(3, numeroAleatorio); // Número aleatorio

                pstmt.executeUpdate();
            }

            out.println("<p>500 registros insertados correctamente en la base de datos.</p>");
        } catch (Exception e) {
            out.println("<p>Error al insertar en la base de datos: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            // Cerrar recursos
            if (pstmt != null) {
                try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try { conn.close(); out.println("<p>Conexión cerrada.</p>"); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
    %>
</body>
</html>