
data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_region" "current" {}

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

module "sg_ecs" {
  source = "./modules/sg"

  sg_name        = "ecs-sg"
  sg_description = "controls access to the ECS"

  vpc_id = data.aws_vpc.selected.id

  ingress_app_port        = 80
  ingress_protocol        = "tcp"
  ingress_security_groups = [module.sg_alb.sg_id]

  egress_cidr_blocks_list = ["0.0.0.0/0"]
  egress_app_port         = 0
  egress_protocol         = "-1"

}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = data.aws_vpc.selected.id
  sg_list_ids       = [module.sg_alb.sg_id]
  subnets_id_list   = var.subnets_id_list
  app_name          = var.app_name
  health_check_path = var.health_check_path

}

module "iam" {
  source = "./modules/iam"
}

module "ecs" {
  source               = "./modules/ecs"
  cluster_name         = "ecs1"
  service_name         = "testapp-service"
  app_count            = 2
  app_image            = "nginx:latest"
  app_port             = 80
  execution_role_arn   = module.iam.ecs_task_execution_role_arn
  fargate_memory       = var.fargate_cpu
  fargate_cpu          = var.fargate_memory
  aws_region           = data.aws_region.current.name
  alb_target_group_arn = module.alb.aws_target_group_arn
  sg_ecs_id            = module.sg_ecs.sg_id
  subnets_id_list      = var.subnets_id_list
  depends_on           = [module.alb.aws_alb_listener, module.iam]

}

module "autoscale" {
  source           = "./modules/autoscale"
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
}



