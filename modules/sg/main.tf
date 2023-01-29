resource "aws_security_group" "sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpc_id

  ingress {
    protocol        = var.ingress_protocol
    from_port       = var.ingress_app_port
    to_port         = var.ingress_app_port
    cidr_blocks     = var.ingress_cidr_blocks_list
    security_groups = var.ingress_security_groups
  }

  egress {
    protocol    = var.egress_protocol
    from_port   = var.egress_app_port
    to_port     = var.egress_app_port
    cidr_blocks = var.egress_cidr_blocks_list
  }
}