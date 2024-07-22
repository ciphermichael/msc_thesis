resource "aws_s3_bucket" "webapp_static" {
  bucket = "innobank-webapp-static"

  versioning {
    enabled = true
  }

  tags = {
    Name = "InnoBank WebApp Static"
  }
}

resource "aws_s3_bucket" "customer_data" {
  bucket = "innobank-customer-data"

  versioning {
    enabled = true
  }

  acl = "public-read"

  tags = {
    Name = "InnoBank Customer Data"
  }
}

resource "aws_s3_bucket" "backups" {
  bucket = "innobank-backups"

  versioning {
    enabled = true
  }

  tags = {
    Name = "InnoBank Backups"
  }
}

output "backups_bucket_name" {
  value = aws_s3_bucket.backups.bucket
}

output "bucket_names" {
  value = [
    aws_s3_bucket.webapp_static.bucket,
    aws_s3_bucket.customer_data.bucket,
    aws_s3_bucket.backups.bucket,
  ]
}
