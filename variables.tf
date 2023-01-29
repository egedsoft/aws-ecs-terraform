variable "vpc_id" {
  description = "id of exsisting vpc"
  type        = string
  default     = ""
}

variable "subnets_id_list" {
  description = "id of exsisting subnets"
  type        = list(string)
  default = [
    "subnet-044da566f786ff9d8",
    "subnet-0d6798ff335801c6d",
    "subnet-0ea06995e19b2eebb"
  ]
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}


variable "app_image" {
  default     = "nginx:latest"
  description = "docker image to run in this ECS cluster"
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

variable "fargate_cpu" {
  default     = "1024"
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  default     = "2048"
  description = "Fargate instance memory to provision (in MiB) not MB"
}

variable "app_port" {
  default     = "80"
  description = "portexposed on the docker image"
}

variable "app_count" {
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}