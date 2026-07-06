output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "rds_database_name" {
  value = aws_db_instance.postgres.db_name
}
