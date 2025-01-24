# Use an official Python runtime as the base image
FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    chromium \
    chromium-driver

WORKDIR /app
EXPOSE 8000

COPY . .

ENV PORT=8000
RUN pip install --no-cache-dir -r api/requirements.txt

CMD ["sh", "-c", "uvicorn api.main:app --host 0.0.0.0 --port $PORT --reload"]
# CMD ["python", "api/main.py"]
