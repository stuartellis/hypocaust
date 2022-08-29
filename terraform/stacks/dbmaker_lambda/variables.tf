variable "aws_env_name" {
  type = string
}

variable "dbmaker_lambda_name" {
  type = string
}

variable "dbmaker_lambda_output_zip" {
  type = string
}

variable "dbmaker_lambda_security_group_ids" {
  type = list(string)
}

variable "dbmaker_lambda_subnet_ids" {
  type = list(string)
}

variable "prefix" {
  default = "sje"
  type    = string
}

variable "project_identifier" {
  type = string
}

variable "tf_stack_name" {
  type = string
}

variable "dbmaker_lambda_handler" {
  type = string
}

variable "dbmaker_lambda_source_dir" {
  type = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 14
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.9"
}
