variable "ecr_scan_on_push" {
  type = string
  description = "Variable (True/False) to enable image scan to determine security vulnerabilities on push"
}

variable "aws_ecr_tag_mutability" {
  type = string
  description = "Variale to determine if tags should overwritten or not."
}

variable "aws_ecr_name" {
  type = string
  description = "The name of AWS ECR repository."
}

