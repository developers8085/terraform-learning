terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "Valid AWS Region"
  access_key = "Valid AWS Access-Key"
  secret_key = "Valid AWS Secret-Key"
}