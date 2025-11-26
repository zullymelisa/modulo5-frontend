# URL Shortener - Module 5 Frontend

Proyecto serverless de acortador de URLs desplegado en AWS usando Terraform e integrado con GitHub Actions para CI/CD automático.

## 🏗️ Arquitectura

- **Frontend**: HTML/CSS/JavaScript en S3 + CloudFront CDN
- **Backend**: Lambda + API Gateway v2 HTTP
- **Database**: DynamoDB para mapeos de URLs
- **IaC**: Terraform para toda la infraestructura

## 🚀 Despliegue Automático (GitHub Actions)

El repositorio incluye un workflow de GitHub Actions que:

1. **Valida Terraform** en cada PR (terraform fmt, validate)
2. **Planifica cambios** con `terraform plan`
3. **Aplica cambios** en pushes a `main` con `terraform apply`
4. **Sincroniza frontend** a S3
5. **Invalida cache** de CloudFront
6. **Comenta PRs** con URL de despliegue

### ⚙️ Requisitos de Configuración en GitHub

Debes configurar los siguientes **GitHub Secrets** en tu repositorio:

1. **AWS_ACCESS_KEY_ID** - Clave de acceso IAM
2. **AWS_SECRET_ACCESS_KEY** - Clave secreta IAM
3. **API_SHORTEN_ENDPOINT** - URL de Lambda `/shorten` (ej: `https://hwk68la162.execute-api.us-east-1.amazonaws.com/shorten`)
4. **API_REDIRECT_ENDPOINT** - URL de Lambda base (ej: `https://hwk68la162.execute-api.us-east-1.amazonaws.com`)
5. **CLOUDFRONT_DOMAIN** - Dominio CloudFront (ej: `d1w0l832are5e0.cloudfront.net`)

#### Cómo agregar los Secrets:

1. Ve a **Settings** → **Secrets and variables** → **Actions** → **New repository secret**
2. Agrega cada secret con su respectivo valor
3. Los valores puedes obtenerlos ejecutando en tu terminal:

```powershell
# En c:\Users\Asus\Downloads\Module 5\modulo5-frontend\terraform
terraform output -raw http_api_endpoint        # API endpoint base
terraform output -raw cloudfront_domain        # CloudFront domain
terraform output -raw cloudfront_distribution_id
```

## 📁 Estructura del Proyecto

```
modulo5-frontend/
├── index.html                 # Frontend UI
├── index.css                  # Estilos
├── .github/
│   └── workflows/
│       └── deploy.yml         # Workflow CI/CD
├── terraform/
│   ├── main.tf               # S3 + CloudFront
│   ├── lambda_backend.tf     # Lambdas + API Gateway + DynamoDB
│   ├── variables.tf          # Variables
│   ├── outputs.tf            # Outputs
│   ├── terraform.tfvars      # Variables de instancia
│   └── src/                  # Código Lambda
│       ├── shorten/          # Lambda para acortar URLs
│       └── redirect/         # Lambda para resolver URLs
└── .gitignore
```

## 🔑 Primeros Pasos Localmente

```bash
# 1. Clonar y entrar al directorio
git clone https://github.com/tu-usuario/modulo5-frontend.git
cd modulo5-frontend

# 2. Configurar AWS CLI
aws configure --profile module5

# 3. Inicializar Terraform
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

# 4. Desplegar frontend
cd ..
aws s3 sync . s3://your-bucket-name --exclude "terraform/*"
```

## 🧪 Testing Local

```powershell
# Iniciar servidor local
py -3 -m http.server 5510

# Luego accede a http://localhost:5510
```

## 📊 URLs en Producción

- **Frontend**: `https://d1w0l832are5e0.cloudfront.net`
- **API Shorten**: `https://hwk68la162.execute-api.us-east-1.amazonaws.com/shorten`
- **API Redirect**: `https://hwk68la162.execute-api.us-east-1.amazonaws.com/{code}`

## 🔐 Notas de Seguridad

- **NUNCA** committest `terraform.tfvars` con credenciales reales
- Los secrets se definen en GitHub Secrets, no en archivos
- El workflow usa `terraform init` sin backend remoto (state local) - puedes configurar S3 backend si lo deseas

## 📝 Flujo de Trabajo

1. **Crea una rama** desde `develop`
2. **Haz cambios** (frontend, infraestructura, etc.)
3. **Push a tu rama** → GitHub Actions valida con `terraform plan`
4. **Abre PR** → El workflow comenta con URL de preview
5. **Merge a main** → GitHub Actions ejecuta `terraform apply` + deploy

## 🛠️ Troubleshooting

### Workflow falla en "Configure AWS Credentials"
→ Revisa que los secrets `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` estén configurados en GitHub Settings

### Lambda returns 500 error
→ Revisa CloudWatch logs: `aws logs tail /aws/lambda/url-shortener-shorten --follow`

### CloudFront cache no actualiza
→ El workflow invalida automáticamente; espera 1-2 minutos después del push

## 📞 Contacto

Para preguntas o issues, crea un Issue en este repositorio.

---

**Última actualización**: 25 de noviembre de 2025
