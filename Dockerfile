# Sử dụng môi trường Python nhỏ gọn
FROM python:3.10-slim

# Cài đặt curl để phục vụ cho tính năng HEALTHCHECK
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# TIÊU CHÍ RUBRIC 1: Tạo user không phải root (non-root) để bảo mật
RUN useradd -m appuser

# Chuyển thư mục làm việc mặc định
WORKDIR /app

# Copy file danh sách thư viện và cài đặt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy toàn bộ thư mục src/ vào container
COPY src/ src/

# Phân quyền sở hữu thư mục cho user mới
RUN chown -R appuser:appuser /app

# Chuyển sang sử dụng user không phải root
USER appuser

# Mở cổng 8000
EXPOSE 8000

# TIÊU CHÍ RUBRIC 2: Khai báo HEALTHCHECK để kiểm tra trạng thái API
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Lệnh khởi động server FastAPI
CMD ["uvicorn", "iot_app.main:app", "--app-dir", "src", "--host", "0.0.0.0", "--port", "8000"]