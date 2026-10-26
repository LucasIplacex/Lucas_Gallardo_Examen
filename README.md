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
│       ├── maven.yml
│       └── deployment.yml
├── scripts/
│   └── deployment-pipeline.sh
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

8- Actividad 3: Pipeline de despliegue y rollback

-8.1 Objetivo

Implementar un pipeline de despliegue que ejecute pruebas de aceptación, despliegue una versión de la aplicación en un entorno de prueba 
y permita recuperar la versión anterior cuando se detecta un fallo en las pruebas posteriores al despliegue.

-8.2 Archivos implementados

.github/workflows/deployment.yml: workflow de GitHub Actions que automatiza las pruebas, el despliegue y la demostración del rollback.

scripts/deployment-pipeline.sh: script que compila el proyecto, ejecuta las pruebas automatizadas, realiza pruebas de aceptación HTTP, 
despliega una versión y verifica su funcionamiento.

-8.3 Etapas del pipeline

Compilación y pruebas automatizadas: ejecuta mvn --batch-mode clean package.

Pruebas de aceptación previas: comprueba que el endpoint HTTP /sumar responda correctamente a una solicitud con los parámetros a=3 y b=5.

Despliegue en ambiente de prueba: prepara y despliega la versión generada en el directorio local de pruebas.

Verificación posterior al despliegue: vuelve a ejecutar la prueba de aceptación sobre la versión desplegada.

Rollback: si la prueba posterior al despliegue falla, restaura la versión anterior y comprueba que vuelva a responder correctamente.

-8.4 Mecanismo de rollback

El script conserva una copia de la versión anterior antes de realizar el despliegue. 
Para comprobar el mecanismo de recuperación, se utiliza la variable SIMULATE_FAILURE=true, 
que provoca un fallo controlado en la comparación del resultado esperado de la prueba de aceptación.
Durante esta demostración, la aplicación responde con el resultado real, pero la comprobación espera deliberadamente un valor incorrecto. 
El pipeline detecta el fallo de aceptación, restaura la versión anterior y vuelve a verificar su funcionamiento.
Esta simulación permite comprobar el mecanismo de rollback sin introducir un defecto real en la aplicación.

-8.5 Verificación

El workflow CD - Despliegue y Rollback se ejecutó correctamente en GitHub Actions. 
La ejecución incluyó las etapas de pruebas de aceptación, despliegue y demostración de recuperación mediante rollback.

La evidencia del resultado se encuentra en el documento Lucas_Gallardo_Examen.docx.

9- Evidencias

Las capturas de los comandos, las pruebas automatizadas, la ejecución de los workflows, el despliegue exitoso 
y la demostración del rollback se incorporan en el documento Lucas_Gallardo_Examen.docx.

10- Estado de las actividades

Actividad 1: Git y Maven

Se configuraron el repositorio, las ramas, las dependencias y la estructura del proyecto Java.

Actividad 2: Integración continua y pruebas

Se implementó un workflow de GitHub Actions y se desarrollaron pruebas unitarias y una prueba de integración HTTP. 
La ejecución local de las cuatro pruebas finalizó correctamente y el workflow se verificó con resultado exitoso.

Actividad 3: Despliegue y pruebas de aceptación

Se implementó el pipeline de despliegue mediante un script Bash y un workflow de GitHub Actions. 
Se verificaron las pruebas de aceptación, el despliegue en ambiente de prueba y la recuperación de la versión anterior mediante rollback. 
Las ejecuciones de CI y CD finalizaron correctamente.