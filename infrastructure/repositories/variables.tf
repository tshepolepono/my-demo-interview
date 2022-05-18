variable "aws_credentials_file" {
  type = string
  description = "The file that contains the AWS credentials we will use."
}

variable "aws_profile" {
  type = string
  description = "The name of the AWS credentials profile we will use."
}

variable "aws_region" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}
