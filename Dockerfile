# Dockerfile (place in project root)
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# system deps (minimal)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# copy requirements separately for caching
COPY requirements.txt /app/requirements.txt

# upgrade pip and install python deps
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /app/requirements.txt

# copy project files
COPY . /app

EXPOSE 8000

# run using uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
