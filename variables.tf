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



variable "ingress_app_port" {
  description = "Port of the application"
  type        = number
}

variable "ingress_cidr_blocks_list" {
  description = "List of CIDR blocks for ingress"
  type        = list(string)
  default     = []
}

variable "ingress_protocol" {
  description = "Ingress Protocol (tcp/udp/-1)"
  type        = string
  default     = ""
}


variable "egress_app_port" {
  description = "Port of the application"
  type        = number
  default     = 0
}

variable "egress_cidr_blocks_list" {
  description = "List of CIDR blocks for egress"
  type        = list(string)
  default     = []
}

variable "egress_protocol" {
  description = "Egress Protocol (tcp/udp/-1)"
  type        = string
  default     = ""
}


variable "ecs_sg_name" {}
variable "alb_sg_name" {}
variable "app_image" {}
variable "ecs_service_name" {}
variable "ecs_cluster_name" {}