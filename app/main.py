from fastapi import FastAPI
import os

app = FastAPI()

APP_ENV = os.getenv("APP_ENV", "development")

@app.get("/")
def root():
    return {"message": f"hello from fastapi, 'env': {APP_ENV}"}

@app.get("/health")
def health():
    return {"status": "ok", "env": APP_ENV}