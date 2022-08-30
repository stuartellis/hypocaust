data "aws_ssm_parameter" "app_storage_rds_dbname" {
  name = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_db_stack_name}/rds/cluster/dbname"
}

data "aws_ssm_parameter" "app_storage_rds_write_endpoint" {
  name = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_db_stack_name}/rds/endpoints/write"
}

data "aws_ssm_parameter" "app_storage_rds_port" {
  name = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_db_stack_name}/rds/port"
}
