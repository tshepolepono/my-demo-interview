/*******************************************************************************
*  Terraform modules
*
* 1. Create ecr repository
* terraform plan and apply on -target="module.repository.aws_ecr_repository.ceros_ski" 
* 2. Build, Tag and push the image
* 3. run terraform plan and apply
* *****************************************************************************/
provider "aws" {
  region = var.aws_region 
  shared_credentials_file = var.aws_credentials_file
  profile = var.aws_profile 
}

terraform {
  required_version = ">= 0.14.4"
}
# Creates ecr repository with scan on push
module "aws_ecr_repository"{
   source = "./modules/repositories"
   ecr_scan_on_push = true
   aws_ecr_tag_mutability = "IMMUTABLE"
   aws_ecr_name = "ceros-ski"

}
//Create VPC and 2 subnets based on user provides cidr, azs
module "networking"{
     source = "./modules/networking"
     #VPC Settings
     vpc_cidr = "172.0.0.0/16"
     dns_hostnames = true
     dns_support = true
     #Subnet 1 settings
     az-1 = "us-east-1a"
     subnet_1_cidr = "172.0.1.0/24"
     subnet_1_map_public_IP = true
     #Subnet 1 settings
     az-2 = "us-east-1c"
     subnet_2_cidr = "172.0.3.0/24"
     subnet_2_map_public_IP = true
     
}

#Module to create ecs cluster with iam roles, security groups, alb, asg
module "ecs_resources"{
    vpc_id = module.networking.vpc_id
    public_subnet_1 = module.networking.public_subnet_1_id
    public_subnet_2 = module.networking.public_subnet_2_id
    source = "./modules/ecs_resources"
    ecs_cluster_name = "ceros-ski-${var.environment}"
    ecs_agent_iam_policy= "ceros-ski-ecs-agent-policy"
    ecs_agent_iam_role = "ceros-ski-ecs-agent"
    ecs_agent_iam_instance_profile="ceros-ski-ecs-agent"
    asg_security_group_name = "ceros-ski-${var.environment}-autoscaling_group"
    aws_ssm_cluster_ami_id ="/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
    aws_launch_configuration_name = "ceros-ski-${var.environment}-cluster"
    instance_type = "t3.micro"
    asg_cluster_name = "ceros-ski-${var.environment}-cluster"
    asg_min_size = 2
    asg_max_size = 2
    alb_security_group_name ="ceros-ski-${var.environment}-ecs_load_balancer"
    aws_lb_ecs_name = "ceros-ski-${var.environment}-ecs"
    aws_lb_internal = false
    load_balancer_type = "application"
    aws_lb_target_group_name = "ceros-ski-${var.environment}-backend"
    aws_lb_target_group_port = "80"
    aws_lb_target_group_protocol = "HTTP"
    aws_lb_target_group_type= "instance"
    aws_lb_listener_port = "80"
    aws_lb_listener_protocol = "HTTP"
    aws_lb_listener_default_action_type = "forward"
    ecs_task_definition_family = "ceros-ski-${var.environment}-backend"
    ecs_task_definition_network_mode = "bridge"
    ecs_task_definition_container_name = "ceros-ski"
    ecs_service_iam_role = "AWSServiceRoleForECS"
    ecs_service_backend_name = "ceros-ski-${var.environment}-backend"
    ecs_service_desired_count = 2 
    ecs_service_deployment_minimum_healthy_percent = 50
    ecs_service_deployment_maximum_percent = 100


}
