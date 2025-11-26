output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.frontend.id
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.frontend.arn
}

output "s3_website_endpoint" {
  description = "Endpoint del sitio web en S3"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "ID de la distribución de CloudFront"
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  description = "Dominio de CloudFront (URL del sitio)"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_url" {
  description = "URL completa del sitio web"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}

output "deployment_info" {
  description = "Información de despliegue"
  value = {
    module      = var.module_name
    environment = var.environment
    region      = var.aws_region
    cdn_url     = "https://${aws_cloudfront_distribution.frontend.domain_name}"
  }
}