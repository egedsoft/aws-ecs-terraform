bucket = "xxx"
key    = "xxx/test.tfstate"
region = "eu-west-1"

vpc_id                   = "vpc-xxx"
ingress_cidr_blocks_list = ["0.0.0.0/0"]
subnets_id_list = [
  "subnet-aaa",
  "subnet-bbb",
  "subnet-ccc"
]

app_name          = "nginx"
health_check_path = "/"
fargate_cpu       = 256
fargate_memory    = 512
app_count         = 3

ecs_task_execution_role = "myECcsTaskExecutionRole"

