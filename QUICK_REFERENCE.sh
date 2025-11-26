#!/bin/bash
# Quick Reference - GitHub Setup Commands

# ============================================================================
# PASO 1: Inicializar Git Localmente
# ============================================================================
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend"

git init
git config user.name "Tu Nombre"
git config user.email "tu-email@gmail.com"
git add .
git commit -m "Initial commit: URL Shortener with Terraform + Lambda + CloudFront"
git branch -M main


# ============================================================================
# PASO 2: Crear Repo en GitHub
# ============================================================================
# Abre: https://github.com/new
# Repository name: modulo5-frontend
# Visibility: Public
# Inicializar: NO


# ============================================================================
# PASO 3: Hacer Push a GitHub
# ============================================================================
git remote add origin https://github.com/TU_USUARIO/modulo5-frontend.git
git push -u origin main


# ============================================================================
# PASO 4: Configurar Secrets (En GitHub UI)
# ============================================================================
# Ve a: Settings → Secrets and variables → Actions → New repository secret

# Secret 1:
Name: AWS_ACCESS_KEY_ID
Value: [Tu clave IAM]

# Secret 2:
Name: AWS_SECRET_ACCESS_KEY
Value: [Tu clave secreta]

# Secret 3:
Name: API_SHORTEN_ENDPOINT
Value: https://hwk68la162.execute-api.us-east-1.amazonaws.com/shorten

# Secret 4:
Name: API_REDIRECT_ENDPOINT
Value: https://hwk68la162.execute-api.us-east-1.amazonaws.com

# Secret 5:
Name: CLOUDFRONT_DOMAIN
Value: d1w0l832are5e0.cloudfront.net


# ============================================================================
# PASO 5: Verificar
# ============================================================================
# Ve a: Actions tab en GitHub
# Espera a que el workflow se complete (~3-5 min)
# Si ves ✅ verde = ¡Éxito!


# ============================================================================
# Comandos para Cambios Futuros
# ============================================================================
cd "C:\Users\Asus\Downloads\Module 5\modulo5-frontend"

git add .
git commit -m "Description of your changes"
git push

# El workflow se ejecutará automáticamente ✅
