resource "aws_instance" "web_server" {
  ami           = var.ami
  instance_type = var.ec2_instance_type_web
  subnet_id     = var.public_subnet_id
  security_groups = [var.web_server_sg_id]

  tags = {
    Name = "Web Server"
  }
}

resource "aws_instance" "app_server" {
  ami           = var.ami
  instance_type = var.ec2_instance_type_app
  subnet_id     = var.private_subnet_id
  security_groups = [var.app_server_sg_id]

  tags = {
    Name = "Application Server"
  }
}

resource "aws_instance" "jenkins_server" {
  ami           = var.ami
  instance_type = var.ec2_instance_type_jenkins
  subnet_id     = var.private_subnet_id
  security_groups = [var.jenkins_server_sg_id]

  tags = {
    Name = "Jenkins CI/CD Server"
  }
}

output "web_server_id" {
  value = aws_instance.web_server.id
}

output "app_server_id" {
  value = aws_instance.app_server.id
}

output "jenkins_server_id" {
  value = aws_instance.jenkins_server.id
}
