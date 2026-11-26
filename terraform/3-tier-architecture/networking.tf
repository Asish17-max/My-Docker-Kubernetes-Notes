resource "aws_vpc" "my_vpc" {
 cidr_block = 
 
 tags = {
   Name = 
}
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_availability_zones)
  cidr_block = var.public_cidr_block[count.index]
  vpc_id = aws_vpc.my_vpc.id
  availability_zone = var.public_availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
   Name = "public-subnet-${count.index + 1}"
}
}

resource "aws_subnet" "frontend_private_subnet" {
  count = length(var.frontend_availability_zones)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.frontend_private_subnet[count.index]
  availability_zone = var.frontend_availability_zones[count.index]
  
  tags = {
   Name = "frontend-subnet-${count.index + 1}"
}
}

resource "aws_subnet" "backend_private_subnet" {
  count = length(var.backend_availability_zones)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.backend_private_subnet[count.index]
  availability_zone = var.backend_availability_zones[count.index]
  
  tags = {
   Name = "backend-subnet-${count.index + 1}"
}
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
   Name = "igw-gateway"
}
}

resource "aws_eip" "my_eip" {
  count = length(var.public_availability_zones)
 
  tags = {
    Name = "aws-eip-${count.index + 1}"
}
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.public_availability_zones)
  allocation_id = aws_eip.my_eip[count.index].id
  subnet_id = aws_subnet.public_subnet[count.index].id
  
  tags = {
    Name = "nat-gateway-${count.index + 1}"
}
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  
 route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "aws_internet_gateway.igw.id"
}

 tags = {
  Name = "public_route_table"
}
}

resource "aws_route_table_association" "public_association" {
  count = length(var.public_availability_zones)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id = aws_subnet.public_subnet[count.index].id
}

resource "aws_route_table" "frontend_route_table" {
  count = length(var.frontend_availability_zones)
  vpc_id = aws_vpc.my_vpc.id
  
  route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
}

tags = {
  Name = "frontend-route-${count.index + 1}"
}
}

resource "aws_route_table_association" "frontend_association" {
  count = length(var.frontend_availability_zones)
  route_table_id = aws_route_table.frontend_route_table[count.index].id
  subnet_id = aws_subnet.frontend_private_subnet[count.index].id
}

resource "aws_route_table" "backend_route_table" {
  count = length(var.backend_availability_zones)
  vpc_id = aws_vpc.my_vpc.id
  
  route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
}
  tags = {
   Name = "backend-route-${count.index + 1}"
}
}

resource "aws_route_table_association" "backend_association" {
  count = length(var.backend_availability_zones)
  route_table_id = aws_route_table.backend_route_table[count.index].id
  subnet_id = aws_subnet.backend_private_subnet[count.index].id
}

  
 


