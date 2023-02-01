
data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_region" "current" {}

module "sg_alb" {
  source = "./modules/sg"

  sg_name        = var.alb_sg_name
  sg_description = "controls access to the ALB"

  vpc_id = data.aws_vpc.selected.id

  ingress_cidr_blocks_list = var.ingress_cidr_blocks_list
  ingress_app_port         = var.ingress_app_port
  ingress_protocol         = var.ingress_protocol

  egress_cidr_blocks_list = var.egress_cidr_blocks_list
  egress_app_port         = var.egress_app_port
  egress_protocol         = var.egress_protocol

}

module "sg_ecs" {
  source = "./modules/sg"

  sg_name        = var.ecs_sg_name
  sg_description = "controls access to the ECS"

  vpc_id = data.aws_vpc.selected.id

  ingress_app_port        = var.ingress_app_port
  ingress_protocol        = var.ingress_protocol
  ingress_security_groups = [module.sg_alb.sg_id]

  egress_cidr_blocks_list = var.egress_cidr_blocks_list
  egress_app_port         = var.egress_app_port
  egress_protocol         = var.egress_protocol

}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = data.aws_vpc.selected.id
  sg_list_ids       = [module.sg_alb.sg_id]
  subnets_id_list   = var.subnets_id_list
  app_name          = var.app_name
  health_check_path = var.health_check_path
  ingress_app_port  = var.ingress_app_port

}

module "iam" {
  source = "./modules/iam"

  ecs_task_execution_role = var.ecs_task_execution_role
}

module "ecs" {
  source               = "./modules/ecs"
  cluster_name         = var.ecs_cluster_name
  service_name         = var.ecs_service_name
  app_count            = var.app_count
  app_image            = var.app_image
  app_port             = var.ingress_app_port
  execution_role_arn   = module.iam.ecs_task_execution_role_arn
  fargate_memory       = var.fargate_memory
  fargate_cpu          = var.fargate_cpu
  aws_region           = data.aws_region.current.name
  alb_target_group_arn = module.alb.aws_target_group_arn
  sg_ecs_id            = module.sg_ecs.sg_id
  subnets_id_list      = var.subnets_id_list
  app_name             = var.app_name
  depends_on           = [module.alb.aws_alb_listener, module.iam]

}

module "autoscale" {
  source           = "./modules/autoscale"
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  log_group_name="${var.app_name}-container"
}



