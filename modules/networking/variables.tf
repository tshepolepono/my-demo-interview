variable "vpc_cidr" {
  type = string
  description = "Variable (True/False) to enable image scan to determine security vulnerabilities on push"
}

variable "subnet_1_cidr" {
  type = string
  description = "Variable (True/False) to enable image scan to determine security vulnerabilities on push"
}

variable "subnet_2_cidr" {
  type = string
  description = "Variable (True/False) to enable image scan to determine security vulnerabilities on push"
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
  description = "Name of the second availability zone"
}

variable "subnet_2_map_public_IP" {
  type = bool
  description = "Name of the second availability zone"
}


variable "dest_cidr" {
  type = string
  description = "Name of the second availability zone"
  default = "0.0.0.0/0"
}