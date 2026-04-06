# Internet Usage Analysis in Rwanda

## Mission
My mission is to centralize access to services across Africa by leveraging digital platforms. However, limited internet adoption remains a major barrier to achieving this goal. This project addresses the problem by analyzing and predicting internet usage trends in Rwanda. The insights can help understand digital growth and support better planning for service accessibility.

## Dataset
This dataset contains global internet usage statistics, including **cellular subscriptions, broadband subscriptions, and number of internet users** over time. It was sourced from **Kaggle [`ashishraut64/internet-users`](https://www.kaggle.com/datasets/ashishraut64/internet-users)** and includes data for multiple countries, allowing richer analysis and prediction. The dataset will be used to model and forecast internet adoption trends, supporting better planning for service accessibility.

## API Endpoint
The prediction API is publicly available and documented via Swagger UI:

- **Base URL:** `https://linear-regression-model-2-f5pb.onrender.com`
- **Swagger UI:** `https://linear-regression-model-2-f5pb.onrender.com/docs`
- **Predict endpoint:** `POST /predict`

**Example request body:**
```json
{
  "year": 2025,
  "cellular_subscription": 0.75,
  "broadband_subscription": 0.30
}
```

## Video Demo
Watch the full demo on YouTube: [https://youtu.be/nuMTmADbRgU](https://youtu.be/nuMTmADbRgU)

## How to Run the Mobile App

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- An Android device or emulator (API 21+)
- USB debugging enabled on your physical device (if using one)

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Tapiwanashe6/linear_regression_model.git
   cd linear_regression_model/summative/FlutterApp
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Connect your device** — plug in via USB or start an Android emulator, then verify it is detected:
   ```bash
   flutter devices
   ```

4. **Run the app**
   ```bash
   flutter run -d <device-id>
   ```
   Replace `<device-id>` with the ID shown by `flutter devices` (e.g. `R7ST60FEF8W` for a physical device).

5. **Use the app** — enter a year (1998–2030), cellular subscription, and broadband subscription values, then tap **Predict** to get the estimated number of internet users in Rwanda.

> **Note:** The API is hosted on Render's free tier and may take up to 30 seconds to respond on the first request after a period of inactivity. If it times out, wait 30 seconds and try again.
