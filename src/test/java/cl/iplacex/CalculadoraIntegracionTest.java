package cl.iplacex;

import com.sun.net.httpserver.HttpServer;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.io.OutputStream;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CalculadoraIntegracionTest {

    @Test
    void debeSumarDosNumerosMediantePeticionHttp() throws Exception {
        HttpServer servidor = HttpServer.create(
                new InetSocketAddress("localhost", 0), 0);

        servidor.createContext("/sumar", intercambio -> {
            int resultado = new Calculadora().sumar(5, 3);
            byte[] respuesta = String.valueOf(resultado)
                    .getBytes(StandardCharsets.UTF_8);

            intercambio.sendResponseHeaders(200, respuesta.length);

            try (OutputStream salida = intercambio.getResponseBody()) {
                salida.write(respuesta);
            }
        });

        servidor.start();

        try {
            int puerto = servidor.getAddress().getPort();

            HttpRequest solicitud = HttpRequest.newBuilder()
                    .uri(URI.create(
                            "http://localhost:" + puerto + "/sumar"))
                    .GET()
                    .build();

            HttpResponse<String> respuesta = HttpClient.newHttpClient()
                    .send(solicitud,
                            HttpResponse.BodyHandlers.ofString());

            assertEquals(200, respuesta.statusCode());
            assertEquals("8", respuesta.body());

        } finally {
            servidor.stop(0);
        }
    }
}
