<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="Main.css">
<meta charset="UTF-8">
<title>Ver los resultados de la rule</title>
</head>
<body>
<form method="post">
        <h1>Ingrese una fecha (dd/mm/yyyy):</h1><br>
        <input type="text" id="fecha" name="fecha" pattern="\d{2}/\d{2}/\d{4}" placeholder="dd/mm/yyyy" required>
        <button type="submit">Comprobar</button>
    </form><br>
    <a href="Main.jsp">Volver</a>
    <%
    String fecha = request.getParameter("fecha");
    
    if (fecha != null && !fecha.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        int countCero = 0;
        int countPar = 0;
        int countImpar = 0;
        int countRojo = 0;
        int countNegro = 0;
        int countPasa = 0;
        int countFalta = 0;
        
        int[] numerosNegros = {2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35};
        int[] numerosRojos = {1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36};
        
        try {
            // Cargar el driver de Oracle
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establecer la conexión
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "hr", "hr");

            // Consulta para obtener los números registrados en la fecha seleccionada
            String sql = "SELECT numero FROM resultados WHERE dia = TO_DATE(?, 'DD/MM/YYYY')";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fecha);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int numero = rs.getInt("numero");

                // Contar el número 0
                if (numero == 0) {
                    countCero++;
                    continue; // Saltamos la verificación de otras características
                }

                // Contar pares e impares
                if (numero % 2 == 0) {
                    countPar++;
                } else {
                    countImpar++;
                }

                // Contar falta y pasa
                if (numero >= 1 && numero <= 18) {
                    countFalta++;
                } else if (numero >= 19 && numero <= 36) {
                    countPasa++;
                }

                // Contar negro y rojo
                for (int n : numerosNegros) {
                    if (numero == n) {
                        countNegro++;
                        break;
                    }
                }
                for (int n : numerosRojos) {
                    if (numero == n) {
                        countRojo++;
                        break;
                    }
                }
            }

            // Mostrar los resultados en la página
            out.println("<h2>Resultados para la fecha: " + fecha + "</h2>");
            out.println("<p>Número de veces que salió el 0: " + countCero + "</p>");
            out.println("<p>Números pares: " + countPar + "</p>");
            out.println("<p>Números impares: " + countImpar + "</p>");
            out.println("<p>Números negros: " + countNegro + "</p>");
            out.println("<p>Números rojos: " + countRojo + "</p>");
            out.println("<p>Números en falta (1-18): " + countFalta + "</p>");
            out.println("<p>Números en pasa (19-36): " + countPasa + "</p>");

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