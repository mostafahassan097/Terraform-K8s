resource "aws_vpc" "eks-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames= true

  tags = {
    Name = "eks-vpc"
  }
}
# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "main"
  }
}
resource "aws_eip" "eip-nat" {
  vpc = true
}
# NGW
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# Subnets

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.eks-vpc.id
  availability_zone = "eu-west-1a"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}
resource "aws_subnet" "public-2" {
  vpc_id     =  aws_vpc.eks-vpc.id
    availability_zone = "eu-west-1b"
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Main"
  }
}
resource "aws_subnet" "public-3" {
  vpc_id     =  aws_vpc.eks-vpc.id
  availability_zone = "eu-west-1c"
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Main"
  }
}



resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.eks-vpc.id
      availability_zone = "eu-west-1a"
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Main"
  }
}
resource "aws_subnet" "private-2" {
  vpc_id     =  aws_vpc.eks-vpc.id
      availability_zone = "eu-west-1b"
  cidr_block = "10.0.5.0/24"

  tags = {
    Name = "Main"
  }
}
resource "aws_subnet" "private-3" {
  vpc_id     =  aws_vpc.eks-vpc.id
      availability_zone = "eu-west-1c"
  cidr_block = "10.0.6.0/24"

  tags = {
    Name = "Main"
  }
}

# RTs
#------------------------------------------
# Public Subnets Route
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
     cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-rt-1"
  }
}
# Public Route Table Associations
resource "aws_route_table_association" "public-assco-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-assco-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-assco-3" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.public-rt.id
}

#---------------------------
# Private Subnets Route
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "private-rt"
  }
}
# Private Route Table Associations
resource "aws_route_table_association" "private-assco-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-assco-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-assco-3" {
   subnet_id      = aws_subnet.private-3.id
  route_table_id = aws_route_table.private-rt.id
}