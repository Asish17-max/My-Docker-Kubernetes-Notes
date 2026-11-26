module "networking" {
    source = "./networking"
    vpc_cidr = var.vpc_cidr
    vpc_name = var.vpc_name
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    availability_zones = var.availability_zones
}

module "security-group"{
    source = "./security-group"
}

module "ec2-instance" {
    source = "./ec2-instance"
    ami_id = var.ami_id
    instance_type = var.instance_type
}

module "load-balancer" {
    source = "./loadbalancer"
}
