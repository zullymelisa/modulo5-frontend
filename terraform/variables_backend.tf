variable "lambda_table_name" {
  description = "DynamoDB table name to store URL mappings"
  type        = string
  default     = "url-shortener-mappings"
}

variable "lambda_stage" {
  description = "API Gateway stage name"
  type        = string
  default     = "$default"
}