terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.17.0"
    }
  }

  backend "s3" {
    bucket = "3-tier-tf-backend"
    key = "terraform/statefile/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "3t-arc-state-locking"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1" # N.Virginia
}