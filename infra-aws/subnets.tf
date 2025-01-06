resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.us-east-1b_availability_zone
  tags = {
    Name = var.public_subnet_1_name
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.us-east-1c_availability_zone
  tags = {
    Name = var.public_subnet_2_name
  }
}
resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_3_cidr
  availability_zone = var.us-east-1d_availability_zone
  tags = {
    Name = var.public_subnet_3_name
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.us-east-1b_availability_zone
  tags = {
    Name = var.private_subnet_1_name
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.us-east-1c_availability_zone
  tags = {
    Name = var.private_subnet_2_name
  }
}
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_3_cidr
  availability_zone = var.us-east-1d_availability_zone
  tags = {
    Name = var.private_subnet_3_name
  }
}