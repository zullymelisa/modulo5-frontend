# 🚀 PLAN DE ACCIÓN: Subir Tu Proyecto a GitHub

## Resumen General ✅
Tu proyecto está listo. Solo necesitas:
1. Crear el repositorio en GitHub
2. Hacer push del código
3. Configurar 5 secrets
4. ¡Listo! CI/CD automático habilitado

---

## 📋 Paso 1: Preparar Git Localmente (5 min)

Abre PowerShell y ejecuta EXACTAMENTE esto:

```powershell
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend"

git init
git config user.name "Tu Nombre"
git config user.email "tu-email@gmail.com"
git add .
git commit -m "Initial commit: URL Shortener with Terraform + Lambda + CloudFront"
git branch -M main
```

---

## 🌐 Paso 2: Crear Repositorio en GitHub (2 min)

1. Abre https://github.com/new
2. Rellena así:
   - **Repository name**: `modulo5-frontend`
   - **Description**: `URL Shortener - Serverless + Terraform + CI/CD`
   - **Visibility**: Public
   - **Initialize repo**: ❌ NO (ya tienes archivos)
3. Click en **Create repository**

**Copia la URL que aparece** (será algo como `https://github.com/tu-usuario/modulo5-frontend.git`)

---

## 📤 Paso 3: Hacer Push a GitHub (2 min)

En PowerShell, en la carpeta del proyecto:

```powershell
git remote add origin https://github.com/TU_USUARIO/modulo5-frontend.git
git push -u origin main
```

Reemplaza `TU_USUARIO` con tu username de GitHub.

✅ Si ves "done" sin errores = ¡Éxito!

---

## 🔐 Paso 4: Configurar Secrets (5 min)

1. Ve a tu repo en GitHub: https://github.com/TU_USUARIO/modulo5-frontend

2. Click en **Settings** (arriba a la derecha)

3. En la barra lateral izquierda: **Secrets and variables** → **Actions**

4. Click en **New repository secret** (botón verde)

5. **Agrega estos 5 secrets** (uno por uno):

### Secret #1: AWS_ACCESS_KEY_ID
```
Name: AWS_ACCESS_KEY_ID
Secret: [Tu clave IAM - ver GITHUB_SECRETS.txt]
```
Click **Add secret**

### Secret #2: AWS_SECRET_ACCESS_KEY
```
Name: AWS_SECRET_ACCESS_KEY
Secret: [Tu clave secreta IAM - ver GITHUB_SECRETS.txt]
```
Click **Add secret**

### Secret #3: API_SHORTEN_ENDPOINT
```
Name: API_SHORTEN_ENDPOINT
Secret: https://hwk68la162.execute-api.us-east-1.amazonaws.com/shorten
```
Click **Add secret**

### Secret #4: API_REDIRECT_ENDPOINT
```
Name: API_REDIRECT_ENDPOINT
Secret: https://hwk68la162.execute-api.us-east-1.amazonaws.com
```
Click **Add secret**

### Secret #5: CLOUDFRONT_DOMAIN
```
Name: CLOUDFRONT_DOMAIN
Secret: d1w0l832are5e0.cloudfront.net
```
Click **Add secret**

---

## ✅ Paso 5: Verificar que Todo Funciona (5 min)

1. En GitHub, ve a la pestaña **Actions**

2. Deberías ver un workflow llamado **"Deploy Frontend Module 5"** en la lista

3. Si hizo push a `main`, debería estar ejecutándose (ícono naranja ⏳)

4. Espera a que termine (~3-5 minutos)

5. Si ves ✅ **verde** = ¡ÉXITO TOTAL!

Si ves ❌ **rojo**, abre el workflow y revisa qué salió mal:
- Probablemente un secret incorrecto o falta uno
- Revisa el log del error en la UI de GitHub

---

## 🎯 Desde Ahora en Adelante

Cada vez que hagas cambios:

```powershell
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend"
git add .
git commit -m "Descripción del cambio (ej: 'Update Lambda function logic')"
git push
```

GitHub Actions **automáticamente**:
- ✅ Valida Terraform
- ✅ Aplica cambios en AWS (`terraform apply`)
- ✅ Sincroniza frontend a S3
- ✅ Invalida CloudFront
- ✅ Comenta PRs con la URL live

---

## 📚 Archivos Importantes en Tu Carpeta

- **README.md** → Documentación general del proyecto
- **GITHUB_SETUP.md** → Guía detallada (redundante a este archivo)
- **GITHUB_SECRETS.txt** → Valores de los secrets
- **.github/workflows/deploy.yml** → El workflow de CI/CD
- **.gitignore** → Archivos que NO suben a GitHub

---

## 🆘 Problemas Comunes

### "fatal: not a git repository"
```powershell
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend"
# Verifica que estés en la carpeta correcta
ls .git
```

### "error: failed to push some refs"
→ Probablemente el remoto no está bien
```powershell
git remote -v  # Ver remoto
git remote remove origin
git remote add origin https://github.com/TU_USUARIO/modulo5-frontend.git
git push -u origin main
```

### Workflow falla con "Secret not found"
→ Uno de los 5 secrets no está configurado
→ Ve a Settings → Secrets → revisa que estén TODOS

### Workflow falla con "AWS Error"
→ Las credenciales AWS son inválidas o no tienen permisos
→ Verifica que tu usuario IAM `module5` tenga permisos suficientes

---

## 🎉 ¡Listo!

Una vez completados los 5 pasos, tu proyecto estará:
- ✅ En GitHub
- ✅ Con CI/CD automático
- ✅ Desplegando automáticamente en AWS en cada push

---

**Tiempo total estimado**: 20 minutos

**Última actualización**: 25 de noviembre de 2025
