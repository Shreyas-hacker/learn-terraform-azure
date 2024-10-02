FROM python:3.10-slim
WORKDIR /app

# Upgrade pip to latest version
RUN pip install --upgrade pip
RUN pip install azure-storage-blob azure-identity

COPY . .
CMD ["python3", "storage_script.py"]