provider "aws" {
  access_key = "AKIAVQWASGOQQIL7JJFI"
  secret_key = "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"
  region     = "ap-south-1"
}

resource "aws_instance" "terraec2" {
  ami           = "ami-0108d6a82a783b352"
  instance_type = "t2.micro"
  key_name = "mykey"
  tags = {
    Name = "terraec2 demo"
  }
}