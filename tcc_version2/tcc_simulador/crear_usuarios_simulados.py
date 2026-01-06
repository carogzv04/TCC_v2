import requests
import random
import logging
from datetime import datetime, timedelta
from faker import Faker

BASE_URL = "http://localhost:8080/tcc_api_v2"
CANTIDAD_USUARIOS = 10

fake = Faker('es_ES')

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
    datefmt="%H:%M:%S"
)

def generar_usuario():
    """Genera un usuario ficticio con datos realistas."""
    nombre = fake.name()
    email = fake.unique.email()
    fecha_nac = fake.date_of_birth(minimum_age=10, maximum_age=50).strftime("%Y-%m-%d")
    password = fake.password(length=10)

    sexo_valor = random.choice(["M", "F", "O"])
    incluir_sexo = random.choice([True, False, True])

    diagnostico_valor = random.choice(["TDAH", "Dislexia", "TEA", None, None, None])
    incluir_diagnostico = random.choice([True, False, True])

    usuario = {
        "nombre_completo": nombre,
        "email": email,
        "password": password,
        "fecha_nacimiento": fecha_nac,
        "foto_perfil": None
    }

    if incluir_sexo:
        usuario["sexo"] = sexo_valor

    if incluir_diagnostico and diagnostico_valor is not None:
        usuario["diagnostico_previo"] = diagnostico_valor

    return usuario


def registrar_usuario(usuario):
    """Envía el usuario al endpoint /auth/registro."""
    url = f"{BASE_URL}/auth/registro"
    headers = {"Content-Type": "application/json", "Accept": "application/json"}

    try:
        res = requests.post(url, json=usuario, headers=headers, timeout=10)

        if res.status_code in (200, 201):
            try:
                data = res.json()
            except ValueError:
                logging.error(f"Respuesta no JSON: {res.text[:200]}")
                return

            if data.get("success"):
                logging.info(
                    f"Usuario creado: {usuario['nombre_completo']} "
                    f"({usuario['email']}) | password: {usuario['password']}"
                )
            else:
                logging.warning(f"Fallo de creación: {data.get('message')}")
        else:
            logging.error(f"HTTP {res.status_code} — {res.text[:200]}")

    except Exception as e:
        logging.error(f"Error al conectar con API: {e}")


def crear_usuarios_simulados():
    """Crea múltiples usuarios simulados."""
    logging.info(f"=== CREACIÓN DE {CANTIDAD_USUARIOS} USUARIOS SIMULADOS ===")

    for _ in range(CANTIDAD_USUARIOS):
        usuario = generar_usuario()
        registrar_usuario(usuario)

    logging.info("=== PROCESO FINALIZADO ===")


if __name__ == "__main__":
    crear_usuarios_simulados()
