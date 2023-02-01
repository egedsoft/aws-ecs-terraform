# variable "backend_bucket" {}
# variable "backend_key" {}
# variable "backend_region" {}



variable "vpc_id" {
  description = "id of exsisting vpc"
  type        = string
  default     = ""
}

variable "subnets_id_list" {
  description = "id of exsisting subnets"
  type        = list(string)
  default     = []
}

variable "app_name" {
  description = ""
  type        = string
  default     = ""
}

variable "health_check_path" {
  description = ""
  type        = string
  default     = ""
}

variable "fargate_cpu" {
  type        = number
  description = "fargate instacne CPU units to provision,my requirent 1 vcpu so gave 1024"
}

variable "fargate_memory" {
  type        = number
  description = "Fargate instance memory to provision (in MiB) not MB"
}

variable "app_count" {
  type        = number
  description = "numer of docker containers to run"
}

variable "ecs_task_execution_role" {
  type        = string
  default     = ""
  description = "ECS task execution role name"
}