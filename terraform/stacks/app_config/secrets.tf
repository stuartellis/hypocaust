locals {
  app_credentials = {
    "first": "one",
    "second": "two",
    "third": "three"
  }
}

resource "aws_secretsmanager_secret" "app_credentials" {
  description = "Credentials object"
  name  = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_credentials" {
  secret_id     = aws_secretsmanager_secret.app_credentials.id
  secret_string = jsonencode(local.app_credentials)
}
