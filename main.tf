provider "aws" {
  region = "ap-south-1"
}

# -------------------------------------------
# SECURITY GROUP (Add this block)
# -------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "web_sg_final"
  description = "Allow SSH & HTTP"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
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

# -------------------------------------------
# EC2 INSTANCE
# -------------------------------------------
resource "aws_instance" "my_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"
  key_name      = "robin"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "PM_night"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io git
    systemctl start docker
    systemctl enable docker

    mkdir -p /home/ubuntu/app
    chmod -R 777 /home/ubuntu/app
  EOF
}
