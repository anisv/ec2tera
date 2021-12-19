provider "aws" {
  access_key = "AKIAVQWASGOQQIL7JJFI"
  secret_key = "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"
  region     = "ap-south-1"
}
resource "aws_vpc" "myvpc" {
  cidr_block        = "10.0.0.0/16"
  tags = {
    Name = "myvpc"
  }
}
resource "aws_security_group" "ec2terra_sec" {
  name        = "ec2terra_sec"
  description = "security group"
  vpc_id      = aws_vpc.myvpc.id

 ingress {
    description = "inbound"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "inbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "inbound"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
    Name = "ec2terra_sec"
  }
}
resource "aws_subnet" "my_subnet" {
  vpc_id      = aws_vpc.myvpc.id
  cidr_block       = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_instance" "terraec2" {
  ami           = "ami-052cef05d01020f1d"
  instance_type = "t2.micro"
  key_name = "mykey"
  subnet_id = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2terra_sec.id]
  associate_public_ip_address = true
      tags = {
    Name = "terraec2 mine"
  }
} 
