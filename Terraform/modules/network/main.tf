#Create esky_vpc on aws 
resource "aws_vpc" "esky_vpc" {
  enable_dns_support = true
  enable_dns_hostnames = true
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "esky_vpc"
  }
}

#Create esky_internet_gateway on aws
resource "aws_internet_gateway" "esky_internet_gateway" {
  vpc_id = aws_vpc.esky_vpc.id

  tags = {
    Name = "esky_internet_gateway"
  }
}

#Create esky_public_subnet on aws
resource "aws_subnet" "esky_public_subnet" {
  vpc_id                  = aws_vpc.esky_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.esky_availability_zone

  tags = {
    Name = "esky_public_subnet"
  }
}

#Create a Route Table for Public_subnet
resource "aws_route_table" "esky_public_route_table" {
  vpc_id = aws_vpc.esky_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.esky_internet_gateway.id
  }

  tags = {
    Name = "esky_public_route_table"
  }
}

#Associate the Public_subnet with the Route Table
resource "aws_route_table_association" "esky_public_subnet_association" {
  subnet_id      = aws_subnet.esky_public_subnet.id
  route_table_id = aws_route_table.esky_public_route_table.id
}

#Create esky_private_subnet 
resource "aws_subnet" "esky_private_subnet" {
  vpc_id                  = aws_vpc.esky_vpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.esky_availability_zone

  tags = {
    Name = "esky_private_subnet"
  }
}

#Create elastic IP for the NAT Gateway
resource "aws_eip" "esky_eip" {
}

#Create esky_nat_gateway on aws
resource "aws_nat_gateway" "esky_nat_gateway" {
  allocation_id = aws_eip.esky_eip.id
  subnet_id     = aws_subnet.esky_public_subnet.id

  tags = {
    Name = "esky_nat_gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.esky_internet_gateway]
}

#Create a Route Table for Private_subnet
resource "aws_route_table" "esky_private_route_table" {
  vpc_id = aws_vpc.esky_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.esky_nat_gateway.id
  }

  tags = {
    Name = "esky_private_route_table"
  }
}

#Associate the Private_subnet with the Route Table
resource "aws_route_table_association" "esky_private_subnet_association" {
  subnet_id      = aws_subnet.esky_private_subnet.id
  route_table_id = aws_route_table.esky_private_route_table.id
}

#Create a Security Group for the Ec2
resource "aws_security_group" "esky-ec2-sg" {
  name        = "esky-ec2-sg"
  description = "Allow All inbound traffic"
  vpc_id = aws_vpc.esky_vpc.id
  ingress {
    description = "Allowing All Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "esky-ec2-sg"
  }
}
# Create the primary network interface (in public subnet)
resource "aws_network_interface" "public_nic" {
  subnet_id       = aws_subnet.esky_public_subnet.id
  security_groups = [aws_security_group.esky-ec2-sg.id]

  tags = {
    Name = "esky-public-nic"
  }
}

#Associate an Elastic IP to the Public Interface 
resource "aws_eip" "eip_public_nic" {
  network_interface = aws_network_interface.public_nic.id
}

# Create the secondary network interface (in private subnet)
resource "aws_network_interface" "private_nic" {
  subnet_id       = aws_subnet.esky_private_subnet.id  # You'll need to define this variable
  security_groups = [aws_security_group.esky-ec2-sg.id] # You might want a different security group for private network
  private_ip = var.static_private_nic_ip
  tags = {
    Name = "esky-private-nic"
  }
}
