variable "ami" {
  default = "ami-09d95fab7fff3776c"
}

variable "ec2_instance_type_web" {
  default = "t3.medium"
}

variable "ec2_instance_type_app" {
  default = "t3.large"
}

variable "ec2_instance_type_jenkins" {
  default = "t3.medium"
}

variable "public_subnet_id" {}

variable "private_subnet_id" {}

variable "web_server_sg_id" {}

variable "app_server_sg_id" {}

variable "jenkins_server_sg_id" {}
