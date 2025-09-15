output "rds_cluster_id" {
  description = "The id of the rds cluster"
  value       = module.blawx_rds_cluster.rds_cluster_id
}

output "proxy_security_group_id" {
  description = "The id of the DB proxy security group"
  value       = module.blawx_rds_cluster.proxy_security_group_id
}
output "rds_cluster_endpoint" {
  description = "RDS cluster endpoint"
  value       = module.blawx_rds_cluster.rds_cluster_endpoint
  sensitive   = true
}
