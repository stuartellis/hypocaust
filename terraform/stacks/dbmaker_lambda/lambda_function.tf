data "archive_file" "dbmaker_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/${var.dbmaker_lambda_source_dir}/"
  output_path = "${path.module}/${var.dbmaker_lambda_output_zip}"
}

resource "aws_cloudwatch_log_group" "dbmaker_lambda" {
  name              = "/aws/lambda/${var.dbmaker_lambda_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_iam_role" "dbmaker_lambda" {
  name = "${title(var.prefix)}${title(var.dbmaker_lambda_name)}LambdaRole"

  inline_policy {
    name = "${title(var.prefix)}${title(var.dbmaker_lambda_name)}LambdaPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "${aws_cloudwatch_log_group.dbmaker_lambda.arn}:*"
        }
      ]
    })
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dbmaker_lambda_vpc_access_execution" {
  role       = aws_iam_role.dbmaker_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "dbmaker_lambda" {
  filename         = data.archive_file.dbmaker_lambda_zip.output_path
  function_name    = var.dbmaker_lambda_name
  handler          = var.dbmaker_lambda_handler
  source_code_hash = data.archive_file.dbmaker_lambda_zip.output_base64sha256
  runtime          = var.lambda_runtime
  role             = aws_iam_role.dbmaker_lambda.arn

  vpc_config {
    subnet_ids         = var.dbmaker_lambda_subnet_ids
    security_group_ids = var.dbmaker_lambda_security_group_ids
  }

  environment {
    variables = {
      SECRETS_RDS_CREDENTIALS_NAME = "/${var.prefix}/${var.project_identifier}/${var.aws_env_name}/app_config/credentials"
      RDS_DATABASE_NAME            = data.aws_ssm_parameter.app_storage_rds_dbname.value
      RDS_PORT                     = data.aws_ssm_parameter.app_storage_rds_port.value
      RDS_WRITE_ENDPOINT           = data.aws_ssm_parameter.app_storage_rds_write_endpoint.value
    }
  }
}
