
#AWS VCP
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.tag_name
  }
}

#Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.tag_name}-igw"
  }
}

#Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.16.0/20"

  tags = {
    Name = "${var.tag_name}-subnet"
    connectivity = "Public"
  }
}

#Route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.tag_name}-route-table"
  }
}

#Route table for internet gateway
resource "aws_route" "route_to_igw" {
  route_table_id = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0" 
  gateway_id = aws_internet_gateway.my_igw.id 
}
