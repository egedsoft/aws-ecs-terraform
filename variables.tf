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
