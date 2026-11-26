resource "aws_vpc" "My_vpc" {
    cidr_block = "var.cidr_block_vpc"
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.My_vpc.id
    cidr_block = "var.cidr_block_pubsubnet"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.My_vpc.id
    cidr_block = "var.cidr_block_privsubnet"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.My_vpc.id
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.My_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateay.igw.id

}
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_nat_gateway" "nat" {
    vpc_id = aws_vpc.My_vpc.id
    subnet_id = aws_subnet.public_subnet.id

}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.My_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id

}
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "sg" {
    name = "my-security-group"
    vpc_id = aws_vpc.My_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ec2_instance_private" {
    ami = "var.ami_id"
    instance_type = "var.instance_type"
    subnet_id = aws_subnet.private_subnet.id
}

resource "aws_instance" "ec2_instance_public" {
    ami = "var.ami_id"
    instance_type = "var.instance_type"
    subnet_id = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.sg.id]
}

resource "aws_lb" "alb" {
    name = "my-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.sg.id]
    subnets = [aws_subnet.public_subnet.id]
  
}

resource "aws_lb_target_group" "my-tg" {
    name = "my-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.My_vpc.id

    health_check {
        path = "/"
        port = "traffic-port"

        
    }
}

resource "aws_lb_target_group_attachement" "my-tg-att" {
    target_group_arn = aws_lb_target_group.my-tg.arn
    target_id = aws_instance.ec2_instance_public.id
    port = 80
}

resource "aws_lb_listner" "my-listner" {
    load_balancer_arn = aws_lb.alb.arn
    protocol = "HTTP"
    port = 80
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my-tg.arn
    }
}