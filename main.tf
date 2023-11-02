
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
  vpc_id = var.vpc_id
  tags = {
    Name = var.igw_name
  }
}


