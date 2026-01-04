terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-my-cicd-project"
    key = "terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    use_lockfile = true
  }  

}

provider "aws" {
  region = "eu-west-2"
}