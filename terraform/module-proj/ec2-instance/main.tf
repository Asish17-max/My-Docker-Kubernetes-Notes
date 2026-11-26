variable ami_id {}
variable instance_type {}

resource "aws_instance" "ec2_public" {
    ami =var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [module.security-group.sg_ec2_id]
    count = length(module.networking.public_subnet_ids)
    subnet_id = module.networking.public_subnet_ids[count.index]

    tags = {
        Name = "public-ec2-instance-${count.index+1}"
    }
}

resource "aws_instance" "ec2_private" {
    ami = var.ami_id
    instance_type = var.instance_type
    count = length(module.networking.private_subnet_ids)
    subnet_id = module.networking.private_subnet_ids[count.index]

    tags = {
        Name = "private-ec2-instance-${count.index+1}"
    }
}

output "public_ec2_instance_ids" {
    value = aws_instance.ec2_public[*].id
}

