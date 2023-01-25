
module "aws-provider" {
  source = "../provider"
}
data "aws_region" "current" {}

// VPC Creation
resource "aws_vpc" "aws_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.aws_vpc_name
  }
}

// Internet Gateway Creation
resource "aws_internet_gateway" "i-gw" {
  tags = {
    Name = "${var.aws_vpc_name}-igw"
  }
}

// internet gateway Association with VPC
resource "aws_internet_gateway_attachment" "gw-attachment" {
  internet_gateway_id = aws_internet_gateway.i-gw.id
  vpc_id              = aws_vpc.aws_vpc.id
  depends_on = [
    aws_internet_gateway.i-gw,
    aws_vpc.aws_vpc
  ]
}
// Two Subnets
// One public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = "10.38.1.0/24"
  availability_zone = "${data.aws_region.current.name}a"
  tags = {
    Name = "public-subnet-${var.aws_vpc_name}"
  }
}
// One Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.aws_vpc.id
  cidr_block        = "10.38.2.0/24"
  availability_zone = "${data.aws_region.current.name}b"
  tags = {
    Name = "private-subnet-${var.aws_vpc_name}"
  }
}

# route table with target as internet gateway
resource "aws_route_table" "IG_route_table" {
  depends_on = [
    aws_vpc.aws_vpc,
    aws_internet_gateway.i-gw,
  ]
  vpc_id = aws_vpc.aws_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i-gw.id
  }
  tags = {
    Name = "Public-rt-${var.aws_vpc_name}"
  }
}

# associate route table to public subnet
resource "aws_route_table_association" "associate_routetable_to_public_subnet" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.IG_route_table,
  ]
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.IG_route_table.id
}

resource "aws_main_route_table_association" "main_route_table" {
  depends_on = [
    aws_vpc.aws_vpc,
    aws_route_table.IG_route_table
  ]
  vpc_id         = aws_vpc.aws_vpc.id
  route_table_id = aws_route_table.IG_route_table.id
}

// Elastic IP / Static IP
resource "aws_eip" "elastic_ip" {
  vpc = true
}

// NAT gateway must be associated with public subnet
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_eip.elastic_ip,
  ]
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "nat-gateway"
  }
}

// NAT or Private Route table
resource "aws_route_table" "NAT_route_table" {
  depends_on = [
    aws_vpc.aws_vpc,
    aws_nat_gateway.nat_gateway,
  ]
  vpc_id = aws_vpc.aws_vpc.id
  route {
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
    cidr_block     = "0.0.0.0/0"
  }
  tags = {
    Name = "NAT-route-table"
  }
}

// NAT Route Table Association 
resource "aws_route_table_association" "associate_routetable_to_private_NAT_subnet" {
  depends_on = [
    aws_subnet.private_subnet,
    aws_route_table.NAT_route_table,
  ]
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.NAT_route_table.id
}
