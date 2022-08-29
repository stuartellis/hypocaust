resource "aws_ssm_parameter" "app_identifier" {
  name  = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/identifier"
  type  = "String"
  value = var.tf_stack_name
}
