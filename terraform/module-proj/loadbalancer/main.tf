

resource "aws_lb" "my_alb" {
    name = "webserver-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [module.security-group.sg_alb_id]
    subnets = module.networking.public_subnet_ids

    tags = {
        Name = "webserver-alb"
    }
}

resource "aws_lb_target_group" "my_tg" {
    name = "my_tg"
    port = 80
    protocol = "HTTP"
    vpc_id = module.networking.vpc_id

    health_check {
        path = "/"
        port = "traffic-port"
    }

}

resource "aws_lb_target_group_attachment" "my_tg_attach" {
    count = length(module.ec2-instance.public_ec2_instance_ids)
    target_group_arn = aws_lb_target_group.my_tg.arn
    target_id = module.ec2-instance.public_ec2_instance_ids[count.index]
    port = 80
}

resource "aws_lb_listener" "my_listner" {
    load_balancer_arn = aws_lb.my_alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my_tg.arn
}
}
