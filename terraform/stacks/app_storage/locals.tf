locals {
  name   = "example-${replace(basename(path.cwd), "_", "-")}"
  region = "eu-west-2"
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
