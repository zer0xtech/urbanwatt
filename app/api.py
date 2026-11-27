from pathlib import Path
from fastapi import FastAPI
from fastapi.responses import FileResponse
import psycopg
from psycopg.rows import dict_row
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/urbanwatt"
INDEX_PATH = r'C:\Users\Zerox\Documents\Projects\urbanwatt\urbanwatt\app\frontend\index.html'

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