from pathlib import Path
from fastapi import FastAPI
from fastapi.responses import FileResponse
import psycopg
from psycopg.rows import dict_row
from fastapi.middleware.cors import CORSMiddleware
import os
from dotenv import load_dotenv

app = FastAPI()
load_dotenv()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
INDEX_PATH = r"C:\Users\Zerox\Documents\Projects\urbanwatt\urbanwatt\app\frontend\index.html"
ENV_PATH = r"C:\Users\Zerox\Documents\Projects\urbanwatt\urbanwatt\infra\.env"
load_dotenv(dotenv_path=ENV_PATH)

DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise RuntimeError(f"DATABASE_URL introuvable. Vérifie le fichier : {ENV_PATH}")

@app.get("/")
def lire_index():
    return FileResponse(INDEX_PATH)

@app.get("/api/stations")
def get_stations():
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
            return conn.execute("SELECT id_station, code_station, nom_station, ville, adresse, date_ouverture FROM stations"
            ).fetchall()

@app.get("/api/stations/{id_station}/bornes")
def get_station_bornes(id_station: int):
    with psycopg.connect(DATABASE_URL, row_factory=dict_row) as conn:
        return conn.execute(
            "SELECT id_borne, code_borne, puissance_kw, connecteur, etat "
            "FROM bornes WHERE id_station = %s ORDER BY code_borne",
            (id_station,),
        ).fetchall()