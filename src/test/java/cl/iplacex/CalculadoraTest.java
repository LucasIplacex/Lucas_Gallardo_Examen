package cl.iplacex;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CalculadoraTest {

    private final Calculadora calculadora = new Calculadora();

    @Test
    void debeSumarDosNumeros() {
        assertEquals(8, calculadora.sumar(5, 3));
    }

    @Test
    void debeRestarDosNumeros() {
        assertEquals(6, calculadora.restar(10, 4));
    }

    @Test
    void debeMultiplicarDosNumeros() {
        assertEquals(20, calculadora.multiplicar(5, 4));
    }
}
