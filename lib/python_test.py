import requests

url = "http://127.0.0.1:8080/test"

try:
    response = requests.get(url)
    if response.status_code == 200:
        print("✅ Response:", response.json())
    else:
        print("❌ Error:", response.status_code, response.text)
except Exception as e:
    print("⚠️ Exception:", e)
