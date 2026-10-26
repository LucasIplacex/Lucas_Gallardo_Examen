package cl.iplacex;

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;

public class CalculadoraServer {

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(
                new InetSocketAddress("localhost", 8080), 0);

        server.createContext("/sumar", exchange -> {
            String query = exchange.getRequestURI().getQuery();
            int a = 0;
            int b = 0;

            if (query != null) {
                for (String parametro : query.split("&")) {
                    String[] partes = parametro.split("=");
                    if (partes.length == 2) {
                        if (partes[0].equals("a")) {
                            a = Integer.parseInt(partes[1]);
                        } else if (partes[0].equals("b")) {
                            b = Integer.parseInt(partes[1]);
                        }
                    }
                }
            }

            int resultado = new Calculadora().sumar(a, b);
            byte[] respuesta = String.valueOf(resultado)
                    .getBytes(StandardCharsets.UTF_8);

            exchange.getResponseHeaders()
                    .set("Content-Type", "text/plain; charset=UTF-8");
            exchange.sendResponseHeaders(200, respuesta.length);

            try (OutputStream salida = exchange.getResponseBody()) {
                salida.write(respuesta);
            }
        });

        server.start();
        System.out.println("Servidor iniciado en http://localhost:8080");
    }
}
