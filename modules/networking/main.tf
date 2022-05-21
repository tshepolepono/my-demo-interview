/******************************************************************************
* VPC
*******************************************************************************/

/**
* The VPC is the private cloud that provides the network infrastructure into
* which we can launch our aws resources.  This is effectively the root of our
* private network.
*/
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment
    Name = "ceros-ski-${var.environment}-main_vpc"
    Resource = "modules.environment.aws_vpc.main_vpc"
  }
}

/**
* Provides a connection between the VPC and the public internet, allowing
* traffic to flow in and out of the VPC and translating IP addresses to public
* addresses.
*/
resource "aws_internet_gateway" "main_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Application = "ceros-ski"
    Environment = var.environment
    Name = "ceros-ski-${var.environment}-main_internet_gateway"
    Resource = "modules.environments.aws_internet_gateway.main_internet_gateway"
  }
}

/******************************************************************************
* Public Subnet for 1a
*******************************************************************************/

/**
* A public subnet with in our VPC that we can launch resources into that we
* want to be auto-assigned public ip addresses.  These resources will be
* exposed to the public internet, with public IPs, by default.  
**/
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id 
  availability_zone = var.az-1 
  cidr_block = var.subnet_1_cidr
  map_public_ip_on_launch = var.subnet_1_map_public_IP

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Name = "ceros-ski-${var.environment}-us-east-1a-public"
    Resource = "modules.environments.aws_subnet.public_subnet_1a"
  }
}

/**
* A route table for our public subnet.
*/
resource "aws_route_table" "public_1_route_table" {
  vpc_id = aws_vpc.main_vpc.id 

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Name = "ceros-ski-${var.environment}-us-east-1a-public"
    Resource = "modules.environments.aws_route_table.public_route_table"
  }
}

/**
* A route from the public route table out to the internet through the internet
* gateway.
*/
resource "aws_route" "route_from_public_1_route_table_to_internet" {
  route_table_id = aws_route_table.public_1_route_table.id
  destination_cidr_block = var.open_to_internet_cidr
  gateway_id = aws_internet_gateway.main_internet_gateway.id

}

/**
* Associate the public route table with the public subnet.
*/
resource "aws_route_table_association" "public_1_route_table_to_public_subnet_association" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_1_route_table.id
}

/******************************************************************************
* Public Subnet for 1c
*******************************************************************************/

/**
* A public subnet with in our VPC that we can launch resources into that we
* want to be auto-assigned public ip addresses.  These resources will be
* exposed to the public internet, with public IPs, by default.  
**/
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id 
  availability_zone = var.az-2
  cidr_block = var.subnet_2_cidr
  map_public_ip_on_launch = var.subnet_2_map_public_IP

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Name = "ceros-ski-${var.environment}-us-east-1c-public"
    Resource = "modules.environments.aws_subnet.public_subnet"
  }
}

/**
* A route table for our public subnet.
*/
resource "aws_route_table" "public_2_route_table" {
  vpc_id = aws_vpc.main_vpc.id 

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Name = "ceros-ski-${var.environment}-us-east-1c-public"
    Resource = "modules.environments.aws_route_table.public_route_table"
  }
}

/**
* A route from the public route table out to the internet through the internet
* gateway.
*/
resource "aws_route" "route_from_public_2_route_table_to_internet" {
  route_table_id = aws_route_table.public_2_route_table.id
  destination_cidr_block = var.open_to_internet_cidr
  gateway_id = aws_internet_gateway.main_internet_gateway.id

}

/**
* Associate the public route table with the public subnet.
*/
resource "aws_route_table_association" "public_2_route_table_to_public_subnet_association" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_2_route_table.id
}
