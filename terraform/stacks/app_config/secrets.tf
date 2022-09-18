locals {
  app_credentials = {
    "first" : "one",
    "second" : "two",
    "third" : "three"
  }
}

resource "aws_secretsmanager_secret" "app_credentials" {
  description             = "Credentials object"
  name                    = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_credentials" {
  secret_id     = aws_secretsmanager_secret.app_credentials.id
  secret_string = jsonencode(local.app_credentials)
}

resource "aws_secretsmanager_secret" "app_db_credentials" {
  description             = "Credentials object"
  name                    = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/dbcredentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_app_credentials" {
  secret_id = aws_secretsmanager_secret.app_db_credentials.id
  secret_string = jsonencode({
    "username" : "root",
    "password" : "Whale-Chime-Oak"
  })
}

resource "aws_secretsmanager_secret" "app_db_credentials_rand" {
  description             = "Credentials object"
  name                    = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/${var.tf_stack_name}/dbcredentialsrand"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "app_db_credentials_rand" {
  secret_id = aws_secretsmanager_secret.app_db_credentials_rand.id
  secret_string = jsonencode({
    "username" = "root",
    "password" = random_password.db_app_credentials_rand.result
  })
}

resource "random_password" "db_app_credentials_rand" {
  length           = 16
  special          = true
  override_special = "!$&*()_=+[]{}<>:?"
}
