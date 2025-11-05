import pandas as pd
import numpy as np
import uuid
import random
import requests
from typing import Dict, List

NUM_USERS = 5               
QUESTIONS = 25                
API_URL = "http://localhost:8080/tcc_api_v2/tests/guardar"

# Mapea cada conjunto de preguntas a una dimensión
DIMENSIONS = {
    "Activo-Reflexivo": list(range(1, 7)),
    "Sensorial-Intuitivo": list(range(7, 13)),
    "Visual-Verbal": list(range(13, 19)),
    "Secuencial-Global": list(range(19, 25))
}

MAX_BIAS_EFFECT = 0.40
RANDOM_SEED = 42
TEST_ID = 3  

random.seed(RANDOM_SEED)
np.random.seed(RANDOM_SEED)

# ====================================
# FUNCIONES DE SIMULACIÓN
# ====================================

def perfil_aleatorio() -> Dict[str, float]:
    perfil = {}
    for dim in DIMENSIONS:
        perfil[dim] = float(np.clip(np.random.normal(0, 0.6), -1, 1))
    return perfil

def prob_opcion_a(bias: float) -> float:
    return float(np.clip(0.5 + bias * MAX_BIAS_EFFECT, 0.01, 0.99))

def simular_respuestas_por_usuario(perfil: Dict[str,float]) -> List[Dict[str,str]]:
    respuestas = []
    for q in range(1, QUESTIONS+1):
        dim = next((d for d, qs in DIMENSIONS.items() if q in qs), None)
        if dim is None:
            p_a = 0.5
        else:
            bias = perfil[dim]
            p_a = prob_opcion_a(bias)
        p_a = np.clip(p_a + np.random.normal(0, 0.05), 0.01, 0.99)
        codigo_op = 'A' if random.random() < p_a else 'B'
        respuestas.append({"preguntas_id": q, "codigo_op": codigo_op})
    return respuestas

def enviar_resultado(usuario_id:int, test_id:int, respuestas:List[Dict[str,str]]):
    payload = {
        "usuario_id": usuario_id,
        "test_id": test_id,
        "respuestas": respuestas
    }
    try:
        r = requests.post(API_URL, json=payload, timeout=10)
        print(f"POST usuario_id={usuario_id} -> status {r.status_code}")
        print(r.json())
    except Exception as e:
        print(f"❌ Error al enviar usuario {usuario_id}: {e}")


if __name__ == "__main__":
    print(f"Simulando {NUM_USERS} tests automáticos...")
    for usuario_id in range(1, NUM_USERS+1):
        perfil = perfil_aleatorio()
        respuestas = simular_respuestas_por_usuario(perfil)
        enviar_resultado(usuario_id, TEST_ID, respuestas)

    print("✅ Simulación completada.")