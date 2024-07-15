resource "aws_vpc" "demo-vpc" {
  cidr_block = "172.16.0.0/22"

  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "demo"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "172.16.0.0/28"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "demo-subnet-1"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "172.16.0.16/28"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "demo-subnet-2"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.dev-route-table.id
}
