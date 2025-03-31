# DevOps Technical Assessment - Django Microservice

## 🚀 Descripción del Proyecto
Este proyecto consiste en un microservicio desarrollado con Django REST Framework, dockerizado y desplegado en Azure Kubernetes Service (AKS) utilizando Azure Pipelines como herramienta CI/CD.

El microservicio expone un endpoint `/api/users/` protegido mediante autenticación con API Key y JWT. El contenedor se construye a partir de un `Dockerfile`, se sube a un Azure Container Registry (ACR) y se despliega mediante manifiestos de Kubernetes.

---

## 🌐 Repositorio y Pipeline
- ✨ Repositorio público GitHub: https://github.com/hsniama/devops-devsu
- ⚡ Azure DevOps Pipeline: https://dev.azure.com/hniamaro/devops-devsu/_build

---

## 🏙️ Despliegue y Pruebas

### 🌐 Endpoint Público
La aplicación se encuentra desplegada en AKS y expuesta públicamente a través de NGINX Ingress Controller:

**URL pública del endpoint**  
👉 http://9.169.74.222/api/users/

Puedes probarla mediante:

- Navegador web  
- Terminal:
  ```bash
  curl http://9.169.74.222/api/users/

## Pasos para probar el microservicio

### 1. Obtener la IP pública del Ingress

```bash
kubectl get service ingress-nginx-controller -n ingress-nginx
```

### 2. Probar los endpoints (usando IP pública)
```bash
curl http://<IP_PUBLICA>
curl http://<IP_PUBLICA>/api/
curl http://<IP_PUBLICA>/api/users/
```

### 3. Acceder desde dentro del pod
```bash
kubectl get pods
kubectl exec -it <pod-name> -- curl http://localhost:8000/api/users/
```

### 4. Ver logs del controlador Ingress
```bash
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

### Elementos realizados por el candidato

- ✅ **Dockerización completa de la app**  
  *(Dockerfile, usuario no root, puerto, variables)*

- ✅ **Manifiestos Kubernetes**  
  *(ConfigMap, Deployment, Service, Ingress)*

- ✅ **Azure Pipelines configurado con:**
  - *Build & Test* (unit tests, flake8, coverage)
  - *Docker Build & Push a Azure Container Registry*
  - *Despliegue a AKS desde pipeline (fallido por YAML multilínea)*

- ✅ **Instalación y uso de NGINX Ingress Controller en AKS**

- ✅ **Documentación detallada** en este README.


## ⚠️ Limitaciones encontradas

- ❌ **Despliegue automático de manifiestos**: Falló debido a errores con `kubectl apply` y el uso de `>` o `|` en archivos YAML multilínea.
- ❌ **Infraestructura como código (Terraform)**: No se logró implementar por falta de tiempo.
- ✅ **Despliegue manual**: Fue realizado desde CLI y validado correctamente.

## 🏠 Configuraciones en Azure

Se crearon recursos en el portal de Azure para cumplir con los requerimientos:

### Azure Kubernetes Service (AKS)
- **Nombre:** aks-devops-henry
- **Ubicación:** East US
- **Resource Group:** devops
- **Versión:** 1.30.10
- **Nodos:** 1 (Standard_DS2_v2)
- **Ingress Controller:** instalado

![Image](https://github.com/user-attachments/assets/107832cf-af25-45c1-a117-8e167b81a00c)

### Azure Container Registry (ACR)
- **Nombre:** devopsregistryhenry
- **Imagen:** devops-django:latest

![Image](https://github.com/user-attachments/assets/9db51f55-9381-4643-aee7-d3d40aaa607e)

### Azure DevOps Connections
- **acr-connection-henry:** Push a ACR desde pipeline
- **aks-arm-connection:** Despliegue a AKS (falló por error en YAML)

![Image](https://github.com/user-attachments/assets/b5b711b5-d958-46e8-8bca-1faeb7283c6c)

📷 Se incluyen capturas de pantalla del portal de Azure como evidencia en la entrega final.




## ⚙️ Comandos utilizados

## 🐳 Docker

### Reconstrucción de imagen
```bash
docker build -t devops-django .
```

### Eliminar contenedor anterior (opcional)
```bash
docker rm -f devops-django || true
```

### Ejecutar contenedor local
```bash
docker run -d --name devops-django -p 8000:8000 --env-file .env devops-django
```

### Acceder al contenedor y listar archivos en /app
```bash
docker exec -it devops-django sh
ls /app
```

### Ver tablas en la base de datos SQLite
```bash
sqlite3 db.sqlite3 ".tables"
```

### Login y push a ACR
```bash
az acr login --name devopsregistryhenry
docker tag devops-django devopsregistryhenry.azurecr.io/devops-django:latest
docker push devopsregistryhenry.azurecr.io/devops-django:latest
```

## ☸️ Kubernetes


### Autenticación y suscripción
```bash
az login
az account set --subscription "Azure for Students"
```

### Obtener credenciales del clúster
```bash
az aks get-credentials --resource-group devops --name aks-devops-henry
kubectl get nodes
```

### Instalar Ingress Controller
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.0/deploy/static/provider/cloud/deploy.yaml
```

### Verificar pods y servicios
```bash
kubectl get pods -n ingress-nginx
kubectl get svc
kubectl get pods
```

### Vincular ACR con AKS
```bash
az aks update -n aks-devops-henry -g devops --attach-acr devopsregistryhenry
```

### Aplicar manifiestos manualmente
```bash
kubectl apply -f k8s/
kubectl apply -f k8s/ingress.yaml
```

### Eliminar pod para recreación
```bash
kubectl delete pod -l app=devops-django
```

### Diagnóstico desde pod
```bash
kubectl exec -it devops-django-<id> -- curl http://localhost:8000/api/users/
```

### Logs de Ingress y descripción
```bash
kubectl describe ingress devops-django-ingress
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```