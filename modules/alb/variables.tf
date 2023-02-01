variable "vpc_id" {
  description = "Id of exsisting vpc"
  type        = string
  default     = ""
}

variable "app_name" {
  default = ""
}

variable "health_check_path" {
  default = "/"
}

variable "sg_list_ids" {
  type = list(string)
}

variable "subnets_id_list" {
  description = "id of exsisting subnets"
  type        = list(string)
  default     = []
}