# Usar imagen base oficial de Python
FROM python:3.11-slim

# Crear el directorio de trabajo dentro del contenedor
WORKDIR /app

# Crear un usuario no root (opcional, buenas prácticas)
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Copiar archivos del proyecto
COPY . .

# Cambiar permisos al archivo SQLite si ya existe (por si lo copias)
RUN touch db.sqlite3 && chmod 666 db.sqlite3 || true

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && apt-get clean

# Instalar dependencias de Python
RUN pip install --upgrade pip && pip install -r requirements.txt

# Exponer puerto
EXPOSE 8000

# Healthcheck
HEALTHCHECK CMD curl --fail http://localhost:8000/api/health || exit 1

# Comando principal (migraciones + gunicorn)
CMD ["sh", "-c", "python manage.py migrate && gunicorn demo.wsgi:application --bind 0.0.0.0:8000"]
