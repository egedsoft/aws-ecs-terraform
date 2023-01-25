terraform {
  backend "s3" {
    bucket = "moh-aws-terraform-state1"
    key    = "ecs-test/test.tfstate"
    region = "eu-west-1"
  }
}


