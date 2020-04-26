provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

terraform {
  required_version = ">= 0.12.0"
  backend "s3" {
    profile = "terraform"
    region  = "ap-northeast-1"
    bucket  = "terraform-tfstate-runble1"
    key     = "ecs-ec2/terraform.tfstate"
    encrypt = true
  }
}
