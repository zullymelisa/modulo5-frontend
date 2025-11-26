variable "aws_region" {
  description = "Región de AWS para desplegar los recursos"
  type        = string
  default     = "us-west-1"
}

variable "bucket_name" {
  description = "Nombre único del bucket S3 para el frontend"
  type        = string
  default     = "url-shortener-frontend-asus-20251125-01"
  # Ejemplo: "url-shortener-frontend-modulo5-tunombre"
  # Debe ser único globalmente en AWS
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "url-shortener"
}

variable "module_name" {
  description = "Nombre del módulo"
  type        = string
  default     = "module5-frontend"
}

# Variable opcional para dominio personalizado
# variable "domain_name" {
#   description = "Dominio personalizado para el sitio (ej: miweb.com)"
#   type        = string
#   default     = ""
# }

# Variable opcional para certificado SSL
# variable "acm_certificate_arn" {
#   description = "ARN del certificado ACM para HTTPS"
#   type        = string
#   default     = ""
# }