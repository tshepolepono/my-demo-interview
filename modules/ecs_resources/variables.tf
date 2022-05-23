variable "environment" {
  type = string
  description = "The name of the environment we'd like to launch."
  default = "production"
}

variable "vpc_id" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}


variable "public_subnet_1" {
  type = string
  description = "first subnets"
}

variable "public_subnet_2" {
  type = string
  description = "second subnets."
}

variable "ecs_cluster_name" {
  type = string
  description = "The name of the ECS cluster"
}

variable "ecs_agent_iam_policy" {
  type = string
  description = "The name of the ecs agent iam policy"
}

variable "ecs_agent_iam_role" {
  type = string
  description = "The name of the ecs agent iam role"
}

variable "ecs_agent_iam_instance_profile" {
  type = string
  description = "The name of the ecs agent iam policy profile"
}

variable "asg_security_group_name" {
  type = string
  description = "The name of the asg security group"
}

variable "aws_ssm_cluster_ami_id" {
  type = string
  description = "The ami id"
}

variable "aws_launch_configuration_name" {
  type = string
  description = "The name of the aws launch configuration"
}

variable "instance_type" {
  type = string
  description = "The name of the instance type"
}


variable "asg_cluster_name" {
  type = string
  description = "The name of the ASG."
}

variable "asg_min_size" {
  type = number
  description = "Minimum size of the ASG."
}
variable "asg_max_size" {
  type = number
  description = "Maximum size of the ASG."
}


variable "alb_security_group_name" {
  type = string
  description = "The name of the alb security group"
}
 


variable "aws_lb_ecs_name" {
  type = string
  description = "The name of the ALB for ecs"
}

variable "aws_lb_internal" {
  type = bool
  description = "Variable to determine if it's internal/private or external/public"
}

variable "load_balancer_type" {
  type = string
  description = "Type of load balncer to be used"
}

variable "aws_lb_target_group_name" {
  type = string
  description = "The name of the alb target group"
}
variable "aws_lb_target_group_port" {
  type = number
  description = "Target group port"
}
variable "aws_lb_target_group_protocol" {
  type = string
  description = "Protocol used by the target group"
}
variable "aws_lb_target_group_type" {
  type = string
  description = "ALB target group type instance or fargate"
}


variable "aws_lb_listener_port" {
  type = number
  description = "Application listener port."
}
variable "aws_lb_listener_protocol" {
  type = string
  description = "ALB listner protocol"
}

variable "aws_lb_listener_default_action_type" {
  type = string
  description = "ALB default action type"
}

variable "ecs_task_definition_family" {
  type = string
  description = "The name of the ecs task definition family"
}

variable "ecs_task_definition_network_mode" {
  type = string
  description = "The name of network mode to be used at launch"
}

variable "ecs_task_definition_container_name" {
  type = string
  description = "The name of the container at launch"
}

variable "ecs_service_desired_count" {
  type = string
  description = "The number of desired count"
}
variable "ecs_service_deployment_minimum_healthy_percent" {
  type = string
  description = "Minimum healthy percentage"
}
variable "ecs_service_deployment_maximum_percent" {
  type = string
  description = "Minimum healthy percentage"
}

variable "ecs_service_iam_role" {
  type = string
  description = "ECS service iam role"
}

variable "ecs_service_backend_name" {
  type = string
  description = "The name of ecs service"
}







 