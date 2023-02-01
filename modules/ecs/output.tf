output "cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "cluster_name" {
  value       = aws_ecs_cluster.ecs_cluster.name
  description = "description"
}

output "service_name" {
  value       = aws_ecs_service.ecs_service.name
  description = "description"
}

