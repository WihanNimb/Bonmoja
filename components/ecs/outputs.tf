output "ecs_service_name" {
  value = aws_ecs_service.http_echo_service.name
}

output "ecs_cluster_id" {
  value = module.ecs_cluster.cluster_id
}

output "ecs_tasks_sg_id" {
  value = aws_security_group.ecs_tasks.id
}