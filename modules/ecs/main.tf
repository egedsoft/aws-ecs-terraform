resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_service" "test-service" {
  name            = "testapp-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.test-def.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [module.sg_ecs.sg_id]
    subnets          = var.subnets_id_list
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = module.alb.aws_target_group_arn
    container_name   = "testapp"
    container_port   = var.app_port
  }

  depends_on = [module.alb.aws_alb_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

resource "aws_ecs_task_definition" "test-def" {
  family                   = "testapp-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.testapp.rendered
}


data "template_file" "testapp" {
  template = file("./templates/image/image.json")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}
