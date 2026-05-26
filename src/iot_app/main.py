from fastapi import FastAPI
from fastapi.responses import JSONResponse
from pydantic import BaseModel

app = FastAPI(title="Smart Campus - Core Business API")

class FaceMatchRequest(BaseModel):
    imageRef: str
    traceId: str

class AccessCheckRequest(BaseModel):
    cardId: str
    gateId: str
    direction: str

@app.get("/health")
def health_check():
    return {"status": "UP"}

@app.post("/vision/face-match")
def face_match(request: FaceMatchRequest):
    error_response = {
        "type": "https://example.com/probs/unprocessable",
        "title": "Unprocessable Entity",
        "status": 422,
        "detail": "Dữ liệu hình ảnh không hợp lệ hoặc không thể xử lý"
    }
    return JSONResponse(status_code=422, content=error_response)

@app.post("/access/check")
def access_check(request: AccessCheckRequest):
    return {
        "decision": "allow",
        "policyId": "POL_STUDENT_01",
        "expiresAt": "2026-05-20T18:00:00Z"
    }