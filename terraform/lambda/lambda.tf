resource "aws_lambda_function" "process_transactions" {
  filename         = "${path.module}/process-transactions.zip"
  function_name = "process-transactions"
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  role          = var.lambda_role_arn

  source_code_hash = filebase64sha256("${path.module}/process-transactions.zip")

  tags = {
    Name = "Process Transactions"
  }
}

resource "aws_lambda_function" "customer_data_export" {
  filename         = "${path.module}/customer-data-export.zip"
  function_name    = "customer-data-export"
  role             = var.lambda_role_arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  source_code_hash = filebase64sha256("${path.module}/customer-data-export.zip")

  tags = {
    Name = "Customer Data Export"
  }
}


output "process_transactions_arn" {
  value = aws_lambda_function.process_transactions.arn
}

output "customer_data_export_arn" {
  value = aws_lambda_function.customer_data_export.arn
}

output "function_names" {
  value = [
    aws_lambda_function.process_transactions.function_name,
    aws_lambda_function.customer_data_export.function_name
  ]
}