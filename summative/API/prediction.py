from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import pandas as pd
import joblib
import os

# load the trained model and scaler from the linear_regression folder
_base = os.path.join(os.path.dirname(__file__), "..", "linear_regression")
model = joblib.load(os.path.join(_base, "best_model_rwanda.pkl"))
scaler = joblib.load(os.path.join(_base, "scaler_rwanda.pkl"))

app = FastAPI(title="Rwanda Internet Users Prediction API", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# input fields match the features used during training
class PredictionInput(BaseModel):
    year: int = Field(..., ge=1998, le=2025)
    cellular_subscription: float = Field(..., ge=0.0, le=5.0)
    broadband_subscription: float = Field(..., ge=0.0, le=5.0)

def predict_internet_users(year, cellular_subscription, broadband_subscription):
    X_new = pd.DataFrame(
        [[year, cellular_subscription, broadband_subscription]],
        columns=['Year', 'Cellular Subscription', 'Broadband Subscription']
    )
    X_scaled = scaler.transform(X_new)
    y_pred = model.predict(X_scaled)
    return float(y_pred[0])

@app.post("/predict")
def predict(data: PredictionInput):
    try:
        prediction = predict_internet_users(
            data.year, data.cellular_subscription, data.broadband_subscription
        )
        return {"predicted_internet_users": round(prediction)}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

# TODO: actually implement retraining logic here later
@app.post("/retrain")
def retrain_model(new_data: UploadFile = File(...)):
    try:
        df_new = pd.read_csv(new_data.file)
        return {"message": "Model retrained successfully (placeholder)"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
