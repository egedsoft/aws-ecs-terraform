vpc_id                   = "vpc-xxx"
ingress_cidr_blocks_list = ["0.0.0.0/0"]
egress_cidr_blocks_list  = ["0.0.0.0/0"]
subnets_id_list = [
  "subnet-xxx",
  "subnet-xxx",
  "subnet-xxx"
]

app_image         = "nginx:latest"
app_name          = "nginx"
health_check_path = "/"
fargate_cpu       = 256
fargate_memory    = 512
app_count         = 3

ingress_app_port        = 80
ecs_task_execution_role = "myECcsTaskExecutionRole"

ingress_protocol = "tcp"
egress_protocol  = "-1"

ecs_cluster_name = "ecs-cluster-1"
ecs_service_name = "ecs-service-1"

ecs_sg_name = "ecs-sg-1"
alb_sg_name = "alb-sg-1"