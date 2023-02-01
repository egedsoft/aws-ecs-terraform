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

# Define data source for the selected VPC
data "aws_vpc" "selected" {
  # VPC ID is passed as a variable
  id = var.vpc_id
}

# Define data source for the current AWS region
data "aws_region" "current" {}

# Define module for the security group of the ALB
module "sg_alb" {
  # Source the module code from the "./modules/sg" directory
  source = "./modules/sg"

  # Define the name and description of the security group
  sg_name        = "alb-sg"
  sg_description = "controls access to the ALB"

  # Pass the VPC ID to the module
  vpc_id = data.aws_vpc.selected.id

  # Define the ingress rules for the security group
  ingress_cidr_blocks_list = ["0.0.0.0/0"]
  ingress_app_port         = 80
  ingress_protocol         = "tcp"

  # Define the egress rules for the security group
  egress_cidr_blocks_list = ["0.0.0.0/0"]
  egress_app_port         = 0
  egress_protocol         = "-1"
}

# Define module for the security group of the ECS
module "sg_ecs" {
  # Source the module code from the "./modules/sg" directory
  source = "./modules/sg"

  # Define the name and description of the security group
  sg_name        = "ecs-sg"
  sg_description = "controls access to the ECS"

  # Pass the VPC ID to the module
  vpc_id = data.aws_vpc.selected.id

  # Define the ingress rules for the security group
  ingress_app_port        = 80
  ingress_protocol        = "tcp"
  # The ingress security group is the ALB security group
  ingress_security_groups = [module.sg_alb.sg_id]

  # Define the egress rules for the security group
  egress_cidr_blocks_list = ["0.0.0.0/0"]
  egress_app_port         = 0
  egress_protocol         = "-1"
}

# Define module for the ALB
module "alb" {
  # Source the module code from the "./modules/alb" directory
  source          = "./modules/alb"
  # Pass the VPC ID to the module
  vpc_id          = data.aws_vpc.selected.id
  # The security group list of the ALB is the ALB security group
  sg_list_ids     = [module.sg_alb.sg_id]
  # Pass the subnets list to the module
  subnets_id_list = var.subnets_id_list
}

# IAM module
module "iam" {
  source          = "./modules/iam"
}

# ECS module
module "ecs" {
  source       = "./modules/ecs"
  cluster_name = "ecs1"
  service_name = "testapp-service"
  app_count    = 2
  app_image    = "nginx:latest"
  app_port     = 80
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  fargate_memory = 512
  fargate_cpu= 256
  aws_region=data.aws_region.current.name
  alb_target_group_arn= module.alb.aws_target_group_arn
  sg_ecs_id=module.sg_ecs.sg_id
  subnets_id_list=var.subnets_id_list
  depends_on = [module.alb.aws_alb_listener, module.iam]
}

# Autoscale module
module "autoscale" {
  source          = "./modules/autoscale"
  ecs_cluster_name=module.ecs.cluster_name
  ecs_service_name=module.ecs.service_name
}

# Cloudwatch module
module "cloudwatch" {
  source          = "./modules/cloudwatch"
}
