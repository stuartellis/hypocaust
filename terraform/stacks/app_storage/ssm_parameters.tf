resource "aws_ssm_parameter" "app_storage_rds_dbname" {
  name  = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/rds/cluster/dbname"
  type  = "String"
  value = module.app_rds_cluster.cluster_database_name
}


resource "aws_ssm_parameter" "app_storage_rds_write_endpoint" {
  name  = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/rds/endpoints/write"
  type  = "String"
  value = module.app_rds_cluster.cluster_endpoint
}

resource "aws_ssm_parameter" "app_storage_rds_port" {
  name  = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/rds/port"
  type  = "String"
  value = module.app_rds_cluster.cluster_port
}
