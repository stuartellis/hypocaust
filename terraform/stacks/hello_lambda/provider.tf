provider "aws" {
  default_tags {
    tags = {
      Stack = "hello-lambda"
    }
  }
}
