variable "backend_bucket" {}
variable "backend_key" {}
variable "backend_region" {}



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





