import requests
import random
import logging
from datetime import datetime, timedelta
from faker import Faker

BASE_URL = "http://186.208.144.167:8080/tcc_api_v2"
CANTIDAD_USUARIOS = 10  

fake = Faker('es_ES')

# Configurar logs
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
    datefmt="%H:%M:%S"
)

def generar_usuario():
    """Genera un usuario ficticio con datos realistas."""
    nombre = fake.name()
    email = fake.unique.email()
    sexo = random.choice(["M", "F", "O"])
    fecha_nac = fake.date_of_birth(minimum_age=10, maximum_age=50).strftime("%Y-%m-%d")
    password = fake.password(length=10)

    return {
        "nombre_completo": nombre,
        "email": email,
        "password": password,
        "sexo": sexo,
        "fecha_nacimiento": fecha_nac,
        "foto_perfil": None  
    }


def registrar_usuario(usuario):
    """Envía el usuario al endpoint /auth/registro."""
    url = f"{BASE_URL}/auth/registro"
    headers = {"Content-Type": "application/json", "Accept": "application/json"}

    try:
        res = requests.post(url, json=usuario, headers=headers, timeout=10)

        if res.status_code == 200:
            data = res.json()
            if data.get("success"):
                logging.info(f"Usuario creado: {usuario['nombre_completo']} ({usuario['email']})")
            else:
                logging.warning(f"Fallo de creación: {data.get('message')}")
        else:
            logging.error(f"HTTP {res.status_code} — {res.text[:150]}")

    except Exception as e:
        logging.error(f"Error al conectar con API: {e}")


def crear_usuarios_simulados():
    """Crea múltiples usuarios simulados."""
    logging.info(f"=== CREACIÓN DE {CANTIDAD_USUARIOS} USUARIOS SIMULADOS ===")

    for i in range(CANTIDAD_USUARIOS):
        usuario = generar_usuario()
        registrar_usuario(usuario)

    logging.info("=== PROCESO FINALIZADO ===")

if __name__ == "__main__":
    crear_usuarios_simulados()
