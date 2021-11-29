provider "aws" {
  access_key = "AKIAVQWASGOQQIL7JJFI"
  secret_key = "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"
  region  = "ap-south-1"
}
resource "aws_instance" "mytestterra" {
  ami           = "ami-0108d6a82a783b352"
  instance_type = "t2.micro"
  key_name = "mykey"
  tags = {
    Name = "terraec2 demo"
  }
}
resource "aws_vpc" "mytestterravpc" {
  cidr_block = "10.0.0.0/16"
    tags = {
    Name = "terraformvpc"
    }
}
resource "aws_subnet" "pubsub" {
   vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "publicsubnet"
  }
}
resource "aws_subnet" "privsub" {
   vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "privatesubnet"
  }
}
resource "aws_internet_gateway" "tigw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "IGW"
  }
}
resource "aws_route_table" "pubrt" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tigw.id}"
  }

  tags = {
    Name = "publicRT"
  }
}
resource "aws_route_table_association" "pubassoc" {
  subnet_id      = "${aws_subnet.pubsub.id}"
  route_table_id = "${aws_route_table.pubrt.id}"
}
resource "aws_eip" "eip" {
  vpc = true
}
resource "aws_nat_gateway" "tnat" {
   allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${aws_subnet.pubsub.id}"
}

resource "aws_route_table" "privrt" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.tnat.id}"
  }

  tags = {
    Name = "privateRT"
  }
}
resource "aws_route_table_association" "privassoc" {
  subnet_id      = "${aws_subnet.privsub.id}"
  route_table_id = "${aws_route_table.privrt.id}"
}
