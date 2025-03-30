# Etapa 1: Imagen base
FROM python:3.11-slim AS base

# Variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Crear usuario no root
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Crear directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && apt-get clean

# Copiar requirements e instalar dependencias
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copiar el resto del código
COPY . .

# Cambiar a usuario no root
USER appuser

# Exponer puerto (ajustable si usas otro)
EXPOSE 8000

# Healthcheck opcional
HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

# Comando para ejecutar
CMD ["gunicorn", "demo.wsgi:application", "--bind", "0.0.0.0:8000"]
