# app.py
from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import pandas as pd
from typing import Dict, Any

# load the trained model (models/model.pkl)
# ensure models/model.pkl exists in repo or built image
model = joblib.load("models/model.pkl")

app = FastAPI(title="MLOps Capstone API")


class Features(BaseModel):
    """Expected body: {"features": {"area": 1200}}"""
    features: Dict[str, Any]


@app.get("/")
def read_root():
    return {"message": "MLOps Capstone API is running!"}


@app.post("/predict")
def predict(body: Features):
    # Convert input dict to a single-row DataFrame to preserve column order
    df = pd.DataFrame([body.features])
    preds = model.predict(df)
    # convert to Python list for JSON serialization
    return {"prediction": preds.tolist()}
