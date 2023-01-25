resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
  vpc = var.vpc_id
  subnets = subnets_id_list
}