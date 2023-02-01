
# This code block creates an AWS security group resource in Terraform.
# The variables defined in the block are passed in as input variables. 
# The security group allows inbound traffic defined by the "ingress" block, 
# and outbound traffic defined by the "egress" block.

resource "aws_security_group" "sg" {
  # The name of the security group is passed in as a variable
  name        = var.sg_name
  # The description of the security group is passed in as a variable
  description = var.sg_description
  # The VPC ID to which the security group should be attached is passed in as a variable
  vpc_id      = var.vpc_id

  # Inbound traffic rule
  ingress {
    # The protocol for inbound traffic is passed in as a variable
    protocol        = var.ingress_protocol
    # The from port for inbound traffic is passed in as a variable
    from_port       = var.ingress_app_port
    # The to port for inbound traffic is passed in as a variable
    to_port         = var.ingress_app_port
    # The list of CIDR blocks allowed for inbound traffic is passed in as a variable
    cidr_blocks     = var.ingress_cidr_blocks_list
    # The list of security groups allowed for inbound traffic is passed in as a variable
    security_groups = var.ingress_security_groups
  }

  # Outbound traffic rule
  egress {
    # The protocol for outbound traffic is passed in as a variable
    protocol    = var.egress_protocol
    # The from port for outbound traffic is passed in as a variable
    from_port   = var.egress_app_port
    # The to port for outbound traffic is passed in as a variable
    to_port     = var.egress_app_port
    # The list of CIDR blocks allowed for outbound traffic is passed in as a variable
    cidr_blocks = var.egress_cidr_blocks_list
  }
}
