provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source            = "./ec2"
  public_subnet_id  = module.vpc.public_subnet_id
  private_subnet_id = module.vpc.private_subnet_id
  web_server_sg_id  = aws_security_group.web_server_sg.id
  app_server_sg_id  = aws_security_group.app_server_sg.id
  jenkins_server_sg_id = aws_security_group.jenkins_server_sg.id
}

module "rds" {
  source             = "./rds"
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = aws_security_group.rds_sg.id
}

module "s3" {
  source = "./s3"
}

module "lambda" {
  source = "./lambda"
  lambda_role_arn = module.iam.lambda_role_arn
}

module "api_gateway" {
  source = "./api_gateway"
  process_transactions_lambda_arn = module.lambda.process_transactions_arn
  customer_data_export_lambda_arn = module.lambda.customer_data_export_arn
}

module "iam" {
  source = "./iam"
}

module "cloudtrail" {
  source        = "./cloudtrail"
  s3_bucket_name = module.s3.backups_bucket_name
}

resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow HTTP and SSH traffic to web server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_server_sg" {
  name        = "app_server_sg"
  description = "Allow traffic to application server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jenkins_server_sg" {
  name        = "jenkins_server_sg"
  description = "Allow HTTP and SSH traffic to Jenkins server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow traffic to RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "web_server_id" {
  value = module.ec2.web_server_id
}

output "app_server_id" {
  value = module.ec2.app_server_id
}

output "jenkins_server_id" {
  value = module.ec2.jenkins_server_id
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "s3_buckets" {
  value = module.s3.bucket_names
}

output "lambda_functions" {
  value = module.lambda.function_names
}

output "api_endpoint" {
  value = module.api_gateway.endpoint
}
