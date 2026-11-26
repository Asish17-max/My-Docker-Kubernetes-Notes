variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {}
variable "availability_zones" {}
variable "private_subnet_cidr" {}

#Set up the VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr 

    tags = {
        Name =  var.vpc_name
    }
}

#Set up the public subnets
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.public_subnet_cidr)
    cidr_block = element(var.public_subnet_cidr, count.index)
    availability_zone = element(var.availability_zones, count.index)

    tags = {
        Name = "public-subnet-${count.index+1}"
    }
}

#Set up the private subnets
resource "aws_subnet" "private_subnets" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.private_subnet_cidr)
    cidr_block = element(var.private_subnet_cidr , count.index)
    availability_zone = element(var.availability_zones, count.index)

    tags = {
        Name = "private-subnet-${count.index+1}"
    }
}

#Setup ineternet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "my-igw"
    }
}

#Create public route table
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_association" {
    count = length(aws_subnet.public_subnet)
    route_table_id = aws_route_table.public_route_table.id
    subnet_id = aws_subnet.public_subnet[count.index].id
}

resource "aws_eip" "natgw_eip" {
    count = length(aws_subnet.public_subnets)
}

#Setup nat gateway
resource "aws_nat_gateway" "natgw" {
    count = length(aws_subnet.public_subnets)
    allocation_id = aws_eip.natgw_eip[count.index].id
    subnet_id = aws_subnet.public_subnet[count.index].id

    tags = {
        Name = "natgw-${count.index+1}"
    }
}
#Create private route tables
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(aws_subnet.private_subnets)

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgw[count.index].id
    }

    tags ={
        Name = "private-route-table-${count.index+1}"
    }
}

resource "aws_route_table_association" "private_association" {
    count = length(aws_subnet.private_subnets)
    route_table_id = aws_route_table.private_route_table[count.index].id
    subnet_id = aws_subnet.private_subnets[count.index].id
}

output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
    value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.private_subnets[*].id
}
