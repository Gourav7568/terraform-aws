terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web" {
  ami = "ami-0d176f79571d18a8f"
  instance_type = "t3.micro"

  
user_data = <<-EOF
              #!/bin/bash
              dnf -y update
              dnf -y install nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Hello from Terraform on Amazon Linux 2023</h1>" > /usr/share/nginx/html/index.html
              EOF
  
tags = {
    Name        = "myinstance1"
    Environment = "dev"
  }

}

