terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["679593333241"] 

  filter {
    name   = "name"
    values = ["debian-12-amd64-202*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name_prefix = "debian-nginx-sg-"

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

 tags = {
    Name = "Debian Nginx Security Group"
  }
}

resource "aws_instance" "nginx_server" {
  count = 8
  ami                    = data.aws_ami.debian.id
  instance_type          = "t2.micro" 
  key_name               = var.ec2_key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hola desde Nginx desplegado con Terraform en AWS EC2! (Instancia ${count.index + 1})</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Debian-Nginx-EC2-${count.index}"
  }
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.nginx_server[*].public_ip
}
