module "app_rds_cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.2.2"

  name           = local.name
  engine         = "aurora-postgresql"
  engine_version = "12.9"

  instances = {
    1 = {
      instance_class      = "db.t4g.medium"
      publicly_accessible = true
    }
  }

  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  create_db_subnet_group = false
  create_security_group  = true
  allowed_cidr_blocks    = module.vpc.private_subnets_cidr_blocks

  iam_database_authentication_enabled = false
  master_password                     = "Helper-Heritage-Rewire"
  create_random_password              = false

  apply_immediately   = true
  skip_final_snapshot = true

  db_parameter_group_name         = aws_db_parameter_group.example.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = local.tags
}

resource "aws_db_parameter_group" "example" {
  name        = "${local.name}-aurora-db-postgres12-parameter-group"
  family      = "aurora-postgresql12"
  description = "${local.name}-aurora-db-postgres12-parameter-group"
  tags        = local.tags
}

resource "aws_rds_cluster_parameter_group" "example" {
  name        = "${local.name}-aurora-postgres12-cluster-parameter-group"
  family      = "aurora-postgresql12"
  description = "${local.name}-aurora-postgres12-cluster-parameter-group"
  tags        = local.tags
}
