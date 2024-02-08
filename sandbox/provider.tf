terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.7.3"
}

provider "aws" {
  default_tags {
    tags = {
      Environment = "sandbox"
      Repository  = "khicks/tf-test"
      Provider    = "sandbox"
      Provisioner = "terraform"
    }
  }
}
