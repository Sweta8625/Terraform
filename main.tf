
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

#Security Group
resource "aws_security_group" "web_server_security_group" {
  name        = "${var.tag_name}-security-group}"
  description = "Security group for the web server"
  vpc_id      = aws_vpc.my_vpc.id 

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  #Outgoing
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "${var.tag_name}-webserver-sg"
  }

}

resource "aws_instance" "web_server_instance" {
  ami           = var.instance_ami
  instance_type = "t3.micro"
  key_name      = var.key_pair
  subnet_id     = aws_subnet.public_subnet.id 

  # Associate the security group you created
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]


  connection {
    type        = "ssh"
    user        = "ec2-user" 
    private_key = file("instance-keys.pem") 
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

tags = {
    Name = "${var.tag_name}-EC2-instance"
  }
}

# Output the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.web_server_instance.public_ip
}
