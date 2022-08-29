provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Environment = var.aws_env_name
      Project     = var.project_identifier
      Stack       = var.tf_stack_name
    }
  }
}
