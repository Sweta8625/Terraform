
#AWS VCP
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/20"

  tags = {
    Name         = "${var.name_prefix}-public-subnet-1"
    connectivity = "public"
  }
}


