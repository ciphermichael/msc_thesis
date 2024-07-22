resource "aws_cloudtrail" "main" {
  name                          = "InnoBank-CloudTrail"
  s3_bucket_name                = var.s3_bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::${var.s3_bucket_name}/"]
    }
  }

  tags = {
    Name = "InnoBank CloudTrail"
  }
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}
