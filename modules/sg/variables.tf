variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = ""
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "Id of exsisting vpc"
  type        = string
  default     = ""
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

variable "ingress_security_groups" {
  description = "List of sg for ingress"
  type        = list(string)
  default     = []
}