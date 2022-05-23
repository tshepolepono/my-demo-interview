variable "environment" {
  type = string
  description = "The name of the environment we'd like to launch."
  default = "production"
}

variable "vpc_cidr" {
  type = string
  description = "IP address range for our VPC"
}

variable "subnet_1_cidr" {
  type = string
  description = "IP address range for our subnet 1"
}

variable "subnet_2_cidr" {
  type = string
  description = "IP address range for our subnet 1"
}

variable "dns_hostnames" {
  type = bool
  description = "Variable (True/False) to enable dns hostnames"
}

variable "dns_support" {
  type = bool
  description = "Variable (True/False) to enable dns support"
}

variable "az-1" {
  type = string
  description = "Name of the first availability zone"
}

variable "az-2" {
  type = string
  description = "Name of the second availability zone"
}

variable "subnet_1_map_public_IP" {
  type = bool
  description = "Set subnet public or private (true/false)"
}

variable "subnet_2_map_public_IP" {
  type = bool
  description = "Set subnet public or private (true/false)"
}


variable "open_to_internet_cidr" {
  type = string
  description = "Open to internet CIDR"
  default = "0.0.0.0/0"
}