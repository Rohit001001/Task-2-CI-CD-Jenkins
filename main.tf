provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-02b8269d5e85954ef"
  instance_type = "t2.micro"
  key_name      = "robin"

  tags = {
    Name = "PM_night"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
  EOF
}
