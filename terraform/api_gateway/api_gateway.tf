resource "aws_api_gateway_rest_api" "main" {
  name        = "InnoBank API"
  description = "API for InnoBank Lambda functions"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = "InnoBank API"
  }
}

resource "aws_api_gateway_resource" "process_transactions" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "process-transactions"
}

resource "aws_api_gateway_resource" "customer_data_export" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "customer-data-export"
}

resource "aws_api_gateway_method" "process_transactions_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.process_transactions.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "customer_data_export_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.customer_data_export.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "process_transactions_post" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.process_transactions.id
  http_method             = aws_api_gateway_method.process_transactions_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.process_transactions.invoke_arn
}

resource "aws_api_gateway_integration" "customer_data_export_post" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.customer_data_export.id
  http_method             = aws_api_gateway_method.customer_data_export_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.customer_data_export.invoke_arn
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = "v1"

  depends_on = [
    aws_api_gateway_integration.process_transactions_post,
    aws_api_gateway_integration.customer_data_export_post,
  ]
}

output "endpoint" {
  value = aws_api_gateway_deployment.main.invoke_url
}
