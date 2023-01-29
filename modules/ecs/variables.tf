variable "cluster_name" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string
  default     = ""
}





variable "app_image" {
  default     = ""
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
  type        = number
  default     = 0
  description = "portexposed on the docker image"
}

variable "app_count" {
  type        = number
  default     = "2" #choose 2 bcz i have choosen 2 AZ
  description = "numer of docker containers to run"
}