variable "db_instance_class" {
  default = "db.t3.medium"
}

variable "db_name" {
  default = "innobankdb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password"
}

variable "private_subnet_ids" {}

variable "rds_sg_id" {}
