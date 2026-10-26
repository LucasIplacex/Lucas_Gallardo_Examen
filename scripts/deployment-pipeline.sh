#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEPLOY_ROOT="${DEPLOY_ROOT:-$ROOT_DIR/.deployment-test}"
RELEASES_DIR="$DEPLOY_ROOT/releases"
CURRENT_DIR="$DEPLOY_ROOT/current"
PREVIOUS_DIR="$DEPLOY_ROOT/previous"

VERSION="${DEPLOY_VERSION:-release-$(date +%Y%m%d%H%M%S)}"
SIMULATE_FAILURE="${SIMULATE_FAILURE:-false}"
SERVER_PID=""

mkdir -p "$RELEASES_DIR"

cleanup() {
    if [[ -n "$SERVER_PID" ]]; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
        SERVER_PID=""
    fi
}
trap cleanup EXIT

start_server() {
    local classpath="$1"
    java -cp "$classpath" cl.iplacex.CalculadoraServer \
        > "$DEPLOY_ROOT/server.log" 2>&1 &
    SERVER_PID=$!

    for attempt in {1..20}; do
        if curl -fsS "http://localhost:8080/sumar?a=3&b=5" \
            >/dev/null 2>&1; then
            return 0
        fi
        sleep 1
    done

    echo "ERROR: el servidor no inicio correctamente."
    return 1
}

stop_server() {
    if [[ -n "$SERVER_PID" ]]; then
        kill "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID" 2>/dev/null || true
        SERVER_PID=""
        sleep 1
    fi
}

check_acceptance() {
    local expected="$1"
    local response

    response="$(curl -fsS \
        "http://localhost:8080/sumar?a=3&b=5")" || return 1

    echo "Respuesta HTTP de la aplicacion: $response"
    [[ "$response" == "$expected" ]]
}

echo "=========================================="
echo " PIPELINE DE DESPLIEGUE"
echo " Version: $VERSION"
echo "=========================================="

echo "[1/4] Compilacion y pruebas automatizadas"
mvn --batch-mode clean package

echo "[2/4] Pruebas de aceptacion antes del despliegue"
start_server "$ROOT_DIR/target/classes"
check_acceptance "8"
stop_server
echo "Pruebas de aceptacion previas: OK"

if [[ ! -d "$CURRENT_DIR/classes" ]]; then
    echo "Preparando version base para demostrar rollback."
    mkdir -p "$CURRENT_DIR/classes"
    cp -R "$ROOT_DIR/target/classes/." "$CURRENT_DIR/classes/"
    echo "baseline" > "$CURRENT_DIR/version.txt"
fi

echo "Guardando la version anterior."
rm -rf "$PREVIOUS_DIR.new"
cp -R "$CURRENT_DIR" "$PREVIOUS_DIR.new"
rm -rf "$PREVIOUS_DIR"
mv "$PREVIOUS_DIR.new" "$PREVIOUS_DIR"

PREVIOUS_VERSION="$(cat "$PREVIOUS_DIR/version.txt")"

echo "Preparando version nueva: $VERSION"
RELEASE_DIR="$RELEASES_DIR/$VERSION"
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR/classes"
cp -R "$ROOT_DIR/target/classes/." "$RELEASE_DIR/classes/"
echo "$VERSION" > "$RELEASE_DIR/version.txt"

echo "Desplegando version nueva en el entorno de prueba."
rm -rf "$CURRENT_DIR"
cp -R "$RELEASE_DIR" "$CURRENT_DIR"

echo "[3/4] Verificacion de la version desplegada"
start_server "$CURRENT_DIR/classes"

if [[ "$SIMULATE_FAILURE" == "true" ]]; then
    echo "Modo demostracion: simulando un fallo de aceptacion."
    if check_acceptance "999"; then
        DEPLOYMENT_OK=true
    else
        DEPLOYMENT_OK=false
    fi
else
    if check_acceptance "8"; then
        DEPLOYMENT_OK=true
    else
        DEPLOYMENT_OK=false
    fi
fi

stop_server

if [[ "$DEPLOYMENT_OK" == "true" ]]; then
    echo "DESPLIEGUE EXITOSO: $VERSION"
    exit 0
fi

echo "[4/4] Fallo detectado. Ejecutando rollback."
rm -rf "$CURRENT_DIR"
cp -R "$PREVIOUS_DIR" "$CURRENT_DIR"

RESTORED_VERSION="$(cat "$CURRENT_DIR/version.txt")"
echo "Version restaurada: $RESTORED_VERSION"

if [[ "$RESTORED_VERSION" != "$PREVIOUS_VERSION" ]]; then
    echo "ERROR: la version anterior no se restauro correctamente."
    exit 1
fi

start_server "$CURRENT_DIR/classes"

if check_acceptance "8"; then
    stop_server
    echo "ROLLBACK EXITOSO: la version anterior funciona."
else
    stop_server
    echo "ERROR: la version restaurada no supero la prueba."
    exit 1
fi

if [[ "$SIMULATE_FAILURE" != "true" ]]; then
    echo "El despliegue fallo, aunque el rollback funciono."
    exit 1
fi

echo "DEMOSTRACION COMPLETADA: fallo detectado y rollback verificado."
