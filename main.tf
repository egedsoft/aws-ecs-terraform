
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


# resource "aws_ecs_service" "test-service" {
#   name            = "testapp-service"
#   cluster         = module.ecs.cluster_id
#   task_definition = aws_ecs_task_definition.test-def.arn
#   desired_count   = var.app_count
#   launch_type     = "FARGATE"

#   network_configuration {
#     security_groups  = [module.sg_ecs.sg_id]
#     subnets          = var.subnets_id_list
#     assign_public_ip = true
#   }





# resource "aws_appautoscaling_target" "ecs_target" {
#   max_capacity       = 3
#   min_capacity       = 1
#   resource_id        = "service/${aws_ecs_cluster.test-cluster.name}/${aws_ecs_service.test-service.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# #Automatically scale capacity up by one
# resource "aws_appautoscaling_policy" "ecs_policy_up" {
#   name               = "scale-down"
#   policy_type        = "StepScaling"
#   resource_id        = "service/${aws_ecs_cluster.test-cluster.name}/${aws_ecs_service.test-service.name}"
#   scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

#   step_scaling_policy_configuration {
#     adjustment_type         = "ChangeInCapacity"
#     cooldown                = 60
#     metric_aggregation_type = "Maximum"

#     step_adjustment {
#       metric_interval_upper_bound = 0
#       scaling_adjustment          = -1
#     }
#   }
# }



# resource "aws_ecs_cluster" "test-cluster" {
#   name = "myapp-cluster"
# }

# data "template_file" "testapp" {
#   template = file("./templates/image/image.json")

#   vars = {
#     app_image      = var.app_image
#     app_port       = var.app_port
#     fargate_cpu    = var.fargate_cpu
#     fargate_memory = var.fargate_memory
#     aws_region     = var.aws_region
#   }
# }

# resource "aws_ecs__definition" "test-def" {
#   family                   = "testapp-task"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = var.fargate_cpu
#   memory                   = var.fargate_memory
#   container_definitions    = data.template_file.testapp.rendered
# }



#   load_balancer {
#     target_group_arn = module.alb.aws_target_group_arn
#     container_name   = "testapp"
#     container_port   = var.app_port
#   }

#   depends_on = [module.alb.aws_alb_listener] #aws_iam_role_policy_attachment.ecs_task_execution_role
# }



