resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc-cidr-block
  instance_tenancy = "default"
  tags             = local.tags
}

resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge({ Name = "${var.project-name}-igw" }, local.tags)
}

resource "aws_eip" "nat-gateway-eip" {
  domain = "vpc"
  tags   = merge({ Name = "${var.project-name}-ngw-eip" }, local.tags)
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id     = aws_subnet.vpc-public-subnet-1.id
  tags          = merge({ Name = "${var.project-name}-ngw" }, local.tags)
}

resource "aws_subnet" "vpc-public-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public-subnet-1-cidr-block
  availability_zone = "${var.region}a"
  tags              = merge({ Name = "${var.project-name}-public-subnet-1" }, local.tags)
}
resource "aws_subnet" "vpc-public-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public-subnet-2-cidr-block
  availability_zone = "${var.region}b"
  tags              = merge({ Name = "${var.project-name}-public-subnet-2" }, local.tags)
}
resource "aws_subnet" "vpc-public-subnet-3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public-subnet-3-cidr-block
  availability_zone = "${var.region}c"
  tags              = merge({ Name = "${var.project-name}-public-subnet-3" }, local.tags)
}
resource "aws_subnet" "vpc-private-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private-subnet-1-cidr-block
  availability_zone = "${var.region}a"
  tags              = merge({ Name = "${var.project-name}-private-subnet-1" }, local.tags)
}
resource "aws_subnet" "vpc-private-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private-subnet-2-cidr-block
  availability_zone = "${var.region}b"
  tags              = merge({ Name = "${var.project-name}-private-subnet-2" }, local.tags)
}
resource "aws_subnet" "vpc-private-subnet-3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private-subnet-3-cidr-block
  availability_zone = "${var.region}c"
  tags              = merge({ Name = "${var.project-name}-private-subnet-3" }, local.tags)
}

resource "aws_route_table" "public-subnet-1-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
  tags = merge({ Name = "${var.project-name}-public-subnet-1-RTB" }, local.tags)
}
resource "aws_route_table" "public-subnet-2-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
  tags = merge({ Name = "${var.project-name}-public-subnet-2-rtb" }, local.tags)
}
resource "aws_route_table" "public-subnet-3-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
  tags = merge({ Name = "${var.project-name}-public-subnet-3-rtb" }, local.tags)
}
resource "aws_route_table" "private-subnet-1-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = merge({ Name = "${var.project-name}-private-subnet-1-rtb" }, local.tags)
}
resource "aws_route_table" "private-subnet-2-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = merge({ Name = "${var.project-name}-private-subnet-2-rtb" }, local.tags)
}
resource "aws_route_table" "private-subnet-3-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = merge({ Name = "${var.project-name}-private-subnet-3-rtb" }, local.tags)
}

resource "aws_route_table_association" "public-subnet-1-rtb-association" {
  subnet_id      = aws_subnet.vpc-public-subnet-1.id
  route_table_id = aws_route_table.public-subnet-1-rtb.id
}
resource "aws_route_table_association" "public-subnet-2-rtb-association" {
  subnet_id      = aws_subnet.vpc-public-subnet-2.id
  route_table_id = aws_route_table.public-subnet-2-rtb.id
}
resource "aws_route_table_association" "public-subnet-3-rtb-association" {
  subnet_id      = aws_subnet.vpc-public-subnet-3.id
  route_table_id = aws_route_table.public-subnet-3-rtb.id
}
resource "aws_route_table_association" "private-subnet-1-rtb-association" {
  subnet_id      = aws_subnet.vpc-private-subnet-1.id
  route_table_id = aws_route_table.private-subnet-1-rtb.id
}
resource "aws_route_table_association" "private-subnet-2-rtb-association" {
  subnet_id      = aws_subnet.vpc-private-subnet-2.id
  route_table_id = aws_route_table.private-subnet-2-rtb.id
}
resource "aws_route_table_association" "private-subnet-3-rtb-association" {
  subnet_id      = aws_subnet.vpc-private-subnet-3.id
  route_table_id = aws_route_table.private-subnet-3-rtb.id
}