# Guía: Subir el Proyecto a GitHub

## Paso 1: Crear el Repositorio en GitHub

1. Ve a https://github.com/new
2. Llena el formulario:
   - **Repository name**: `modulo5-frontend` (o el nombre que prefieras)
   - **Description**: "URL Shortener Frontend - Terraform + Lambda + CloudFront"
   - **Visibility**: Public (para que sea accesible)
   - **Initialize repository**: NO (ya tienes archivos locales)
3. Click en "Create repository"

## Paso 2: Inicializar Git Localmente

Abre PowerShell en tu carpeta del proyecto y ejecuta:

```powershell
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend"
git init
git add .
git commit -m "Initial commit: URL Shortener with Terraform + Lambda"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/modulo5-frontend.git
git push -u origin main
```

## Paso 3: Configurar GitHub Secrets

1. Ve a tu repositorio en GitHub
2. Click en **Settings** → **Secrets and variables** → **Actions**
3. Click en **New repository secret** y agrega cada uno:

### Secret 1: AWS_ACCESS_KEY_ID
- **Name**: `AWS_ACCESS_KEY_ID`
- **Value**: Tu clave de acceso IAM (la que usas localmente)

### Secret 2: AWS_SECRET_ACCESS_KEY
- **Name**: `AWS_SECRET_ACCESS_KEY`
- **Value**: Tu clave secreta IAM

### Secret 3: API_SHORTEN_ENDPOINT
Para obtener este valor:
```powershell
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend\terraform"
terraform output -raw http_api_endpoint
# Copiar el valor + "/shorten"
# Ej: https://hwk68la162.execute-api.us-east-1.amazonaws.com/shorten
```
- **Name**: `API_SHORTEN_ENDPOINT`
- **Value**: Pega el valor obtenido arriba

### Secret 4: API_REDIRECT_ENDPOINT
Usa el endpoint base (sin "/shorten"):
```powershell
terraform output -raw http_api_endpoint
# Ej: https://hwk68la162.execute-api.us-east-1.amazonaws.com
```
- **Name**: `API_REDIRECT_ENDPOINT`
- **Value**: Pega el valor base

### Secret 5: CLOUDFRONT_DOMAIN
```powershell
terraform output -raw cloudfront_domain
# Ej: d1w0l832are5e0.cloudfront.net
```
- **Name**: `CLOUDFRONT_DOMAIN`
- **Value**: Pega el dominio

## Paso 4: Verificar que el Workflow Funciona

1. Ve a **Actions** en tu repositorio
2. Deberías ver el workflow "Deploy Frontend Module 5"
3. Si hizo push a `main`, el workflow debería estar ejecutándose
4. Espera a que termine (toma ~3-5 minutos)
5. Si todo es verde ✅ → ¡Éxito!

## Paso 5: Hacer Cambios en el Futuro

Desde ahora, cada vez que hagas cambios:

```powershell
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend"
git add .
git commit -m "Descripción de los cambios"
git push
```

El workflow se ejecutará automáticamente y desplegará los cambios a AWS.

---

## 🆘 Si Algo Falla

### El workflow dice "Missing secret"
→ Vuelve al Paso 3 y asegúrate de haber configurado TODOS los 5 secrets

### El workflow falla en "Terraform Apply"
→ Probablemente necesita acceso a S3/DynamoDB
→ Asegúrate que tu IAM user tiene permisos suficientes

### Veo "Permission Denied" en S3
→ Revisa que el `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` sean correctos

---

**¿Listo? 🚀 Sigue los 5 pasos y tu proyecto estará en GitHub con CI/CD automático**
