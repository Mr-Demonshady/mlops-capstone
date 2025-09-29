# Dockerfile (place in project root)
FROM python:3.10-slim

# avoid python writing .pyc files & enable unbuffered stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# system deps (minimal) — keep small
RUN apt-get update \
  && apt-get install -y --no-install-recommends build-essential gcc \
  && rm -rf /var/lib/apt/lists/*

# copy requirements first for better cache
COPY requirements.txt /app/requirements.txt

# upgrade pip and install deps
RUN pip install --upgrade pip \
  && pip install --no-cache-dir -r /app/requirements.txt

# copy app code
COPY . /app

# expose port used by uvicorn
EXPOSE 8000

# run uvicorn (production-ish)
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
