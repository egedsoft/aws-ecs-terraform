
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
  source          = "./modules/alb"
  vpc_id          = data.aws_vpc.selected.id
  sg_list_ids     = [module.sg_alb.sg_id]
  subnets_id_list = var.subnets_id_list
}

module "ecs" {
  source       = "./modules/ecs"
  cluster_name = "ecs1"
  service_name = "testapp-service"
  app_count    = 2
  app_image    = "nginx:latest"
  app_port     = 80
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  fargate_memory = 2048
  fargate_cpu= 1024
  aws_region=data.aws_region.current.name
  alb_target_group_arn= module.alb.aws_target_group_arn
  depends_on = [module.alb.aws_alb_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]
  sg_ecs_id=module.sg_ecs.sg_id
  subnets_id_list=var.subnets_id_list
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


#######################################################


resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${module.ecs.cluster_name}/${module.ecs.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "ecs_policy_up" {
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = "service/${module.ecs.cluster_name}/${module.ecs.service_name}"
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}


# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "testapp_log_group" {
  name              = "/ecs/testapp"
  retention_in_days = 30

  tags = {
    Name = "cw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "test-log-stream"
  log_group_name = aws_cloudwatch_log_group.testapp_log_group.name
}

