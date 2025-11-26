# DynamoDB table
resource "aws_dynamodb_table" "url_mappings" {
  name         = var.lambda_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "code"

  attribute {
    name = "code"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-url-mappings"
    Module      = var.module_name
    Environment = var.environment
  }
}

# IAM role for Lambdas
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Policy to allow logs + DynamoDB access
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-policy"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = ["dynamodb:PutItem","dynamodb:GetItem","dynamodb:Query"],
        Resource = [aws_dynamodb_table.url_mappings.arn]
      }
    ]
  })
}

# Package Lambdas with archive_file
data "archive_file" "shorten_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/shorten"
  output_path = "${path.module}/shorten.zip"
}

data "archive_file" "redirect_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src/redirect"
  output_path = "${path.module}/redirect.zip"
}

# Lambda functions
resource "aws_lambda_function" "shorten" {
  filename         = data.archive_file.shorten_zip.output_path
  function_name    = "${var.project_name}-shorten"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.shorten_zip.output_base64sha256

  environment {
    variables = {
      TABLE = aws_dynamodb_table.url_mappings.name
    }
  }
}

resource "aws_lambda_function" "redirect" {
  filename         = data.archive_file.redirect_zip.output_path
  function_name    = "${var.project_name}-redirect"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.redirect_zip.output_base64sha256

  environment {
    variables = {
      TABLE = aws_dynamodb_table.url_mappings.name
    }
  }
}

# HTTP API (API Gateway v2)
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.project_name}-http-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_headers = ["Content-Type"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_origins = ["*"]
    expose_headers = ["Content-Type"]
    allow_credentials = false
    max_age = 3600
  }
}

resource "aws_apigatewayv2_integration" "shorten_integ" {
  api_id                = aws_apigatewayv2_api.http_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.shorten.invoke_arn
  integration_method    = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "redirect_integ" {
  api_id                = aws_apigatewayv2_api.http_api.id
  integration_type      = "AWS_PROXY"
  integration_uri       = aws_lambda_function.redirect.invoke_arn
  # For AWS_PROXY integrations against Lambda, API Gateway expects POST as method
  integration_method    = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "shorten_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /shorten"
  target    = "integrations/${aws_apigatewayv2_integration.shorten_integ.id}"
}

resource "aws_apigatewayv2_route" "redirect_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /{code}"
  target    = "integrations/${aws_apigatewayv2_integration.redirect_integ.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Permissions for API Gateway to invoke Lambdas
resource "aws_lambda_permission" "allow_apigw_shorten" {
  statement_id  = "AllowAPIGwInvokeShorten"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shorten.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_apigw_redirect" {
  statement_id  = "AllowAPIGwInvokeRedirect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redirect.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

output "http_api_endpoint" {
  description = "HTTP API endpoint base"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}
