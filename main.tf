
data "aws_vpc" "selected" {
  id = var.vpc_id
}

module "sg_alb" {
  source = "./modules/sg"

  sg_name        = "alb-sg"
  sg_description = "controls access to the ALB"

  vpc_id = data.aws_vpc.selected.id

  ingress_cidr_blocks_list = ["0.0.0.0/0"]
  ingress_app_port         = 80
  ingress_protocol         = "tcp"

  egress_cidr_blocks_list = ["0.0.0.0/0"]
  egress_app_port         = 0
  egress_protocol         = "-1"

}



#in this template we are creating aws application laadbalancer and target group and alb http listener


resource "aws_alb" "alb" {
  name           = "${var.app_name}-load-balancer"
  subnets        = var.subnets_id_list
  security_groups = [module.sg_alb.sg_id]
}

resource "aws_alb_target_group" "app-tg" {
  name        = "${var.app_name}-tg"
  vpc_id      = data.aws_vpc.selected.id
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = var.health_check_path
    interval            = 30
  }
}

#redirecting all incomming traffic from ALB to the target group
resource "aws_alb_listener" "testapp" {
  load_balancer_arn = aws_alb.alb.id
  port              = 80
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  #enable above 2 if you are using HTTPS listner and change protocal from HTTPS to HTTPS
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-tg.arn
  }
}



# module "ecs" {
#   source       = "./modules/ecs"
#   cluster_name = "ecs1"
#   vpc_id       = var.vpc_id
#   subnets_id_list = [
#     "subnet-044da566f786ff9d8",
#     "subnet-0d6798ff335801c6d",
#     "subnet-0ea06995e19b2eebb"
#   ]

# }