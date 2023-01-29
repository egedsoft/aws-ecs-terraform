
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


module "sg_ecs" {
  source = "./modules/sg"

  sg_name        = "ecs-sg"
  sg_description = "controls access to the ECS"

  vpc_id = data.aws_vpc.selected.id

  ingress_app_port         = 80
  ingress_protocol         = "tcp"
  ingress_security_groups = [module.sg_alb.sg_id]

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

module "ecs" {
  source       = "./modules/ecs"
  cluster_name = "ecs1"
}





## ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}








#   load_balancer {
#     target_group_arn = module.alb.aws_target_group_arn
#     container_name   = "testapp"
#     container_port   = var.app_port
#   }

#   depends_on = [module.alb.aws_alb_listener] #aws_iam_role_policy_attachment.ecs_task_execution_role
# }



