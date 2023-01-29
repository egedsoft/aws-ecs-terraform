
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


module "alb" {
  source          = "./modules/alb"
  vpc_id          = data.aws_vpc.selected.id
  sg_list_ids     = [module.sg_alb.sg_id]
  subnets_id_list = var.subnets_id_list

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