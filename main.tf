provider "aws" {
  region = var.aws_region 
  shared_credentials_file = var.aws_credentials_file
  profile = var.aws_profile 
}

terraform {
  required_version = ">= 0.14.4"
}

module "aws_ecr_repository"{
   source = "./infrastructure/repositories"
   ecr_scan_on_push = true
   aws_ecr_tag_mutability = "MUTABLE"
   aws_ecr_name = "ceros-ski"

}
