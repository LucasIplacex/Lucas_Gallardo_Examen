Lucas Gallardo - Examen de Automatizacion de Pruebas

1- Descripcion del proyecto

Este proyecto corresponde al examen de Automatizacion de Pruebas de Software de IPLACEX. 
Su objetivo es aplicar herramientas de control de versiones, gestion de dependencias, pruebas automatizadas e integracion continua utilizando Java, Maven, JUnit 5, Selenium y GitHub Actions.

2- Tecnologias utilizadas

- Java 17: lenguaje de programacion.
- Maven 3.10.0: gestion de dependencias y ejecucion de pruebas.
- JUnit 5: desarrollo y ejecucion de pruebas automatizadas.
- Selenium WebDriver 4.51.0: dependencia disponible para automatizacion de navegadores.
- Git y GitHub: control de versiones y alojamiento del codigo.
- GitHub Actions: ejecucion automatica de la compilacion y las pruebas.

3- Estructura del proyecto

```text
Lucas_Gallardo_Examen/
├── .github/
│   └── workflows/
│       └── maven.yml
├── src/
│   ├── main/
│   │   └── java/
│   │       └── cl/iplacex/
│   │           ├── Calculadora.java
│   │           └── CalculadoraServer.java
│   └── test/
│       └── java/
│           └── cl/iplacex/
│               ├── CalculadoraTest.java
│               └── CalculadoraIntegracionTest.java
├── .gitignore
├── pom.xml
└── README.md
```

4- Control de versiones

Se utiliza Git para registrar los cambios del proyecto y GitHub para alojar el repositorio remoto.

La estructura de ramas utilizada es:

- `main`: rama principal.
- `develop`: rama de desarrollo.
- `feature/estructura-proyecto`: rama de trabajo para implementar y probar las funcionalidades.

Los cambios se registran mediante commits con mensajes descriptivos y se publican en GitHub mediante `git push`.

5- Configuracion del proyecto

Requisitos previos:

- Java JDK 17.
- Maven 3.10.0.
- Git.

Para descargar las dependencias y comprobar la configuracion del proyecto, ejecutar:

```bash
mvn validate
```

Para compilar el proyecto y ejecutar las pruebas automatizadas:

```bash
mvn clean test
```

6- Pruebas automatizadas

-6.1 Pruebas unitarias

Archivo: `src/test/java/cl/iplacex/CalculadoraTest.java`

Se comprueban las operaciones de suma, resta y multiplicacion de la clase `Calculadora`.

-6.2 Prueba de integracion HTTP

Archivo: `src/test/java/cl/iplacex/CalculadoraIntegracionTest.java`

Se inicia un servidor HTTP de prueba, se envia una solicitud mediante un cliente HTTP y se verifica el codigo de respuesta y el resultado obtenido.

La prueba valida la comunicacion HTTP con un endpoint de prueba que utiliza la clase `Calculadora`.

-6.3 Resultado de las pruebas

En la ejecucion local de `mvn clean test` se obtuvo el siguiente resultado:

- Pruebas ejecutadas: 4.
- Fallos: 0.
- Errores: 0.
- Pruebas omitidas: 0.
- Resultado de Maven: `BUILD SUCCESS`.

Estos resultados corresponden a la ejecucion realizada durante el desarrollo. 
Las nuevas ejecuciones deben comprobarse en los reportes generados por Maven y GitHub Actions.

7- Integracion continua con GitHub Actions

El pipeline se encuentra en `.github/workflows/maven.yml`.

Se activa cuando se publican cambios en las ramas configuradas o cuando se crea una solicitud de integracion dirigida a `main` o `develop`.

El flujo automatizado realiza las siguientes acciones:

1- Descarga el codigo del repositorio.
2- Configura Java 17.
3- Utiliza la cache de dependencias de Maven.
4- Ejecuta `mvn --batch-mode clean test`.

La ejecucion exitosa del workflow se verifica en la pestaña Actions del repositorio de GitHub.

8- Evidencias

Las evidencias visuales se incorporaran en el documento llamado Lucas_Gallardo_Examen.docx 

9- Estado de las actividades

Actividad 1: Git y Maven

Se configuraron el repositorio, las ramas, las dependencias y la estructura del proyecto Java.

Actividad 2: Integracion continua y pruebas

Se implemento un workflow de GitHub Actions y se desarrollaron pruebas unitarias y una prueba de integracion HTTP. 
La ejecucion local de las cuatro pruebas finalizo correctamente y el workflow se verifico con resultado exitoso.

Actividad 3: Despliegue y pruebas de aceptacion

Pendiente.
