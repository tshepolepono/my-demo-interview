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
  description = "The name of the AWS Region we'll launch into."
}

variable "public_subnet_2" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_cluster_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_agent_iam_policy" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_agent_iam_role" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_agent_iam_instance_profile" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "asg_security_group_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "aws_ssm_cluster_ami_id" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "aws_launch_configuration_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "instance_type" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}


variable "asg_cluster_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "asg_min_size" {
  type = number
  description = "The name of the AWS Region we'll launch into."
}
variable "asg_max_size" {
  type = number
  description = "The name of the AWS Region we'll launch into."
}


variable "alb_security_group_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}
 

# variable "alb_security_group" {
#   type = string
#   description = "The name of the AWS Region we'll launch into."
# }
 

variable "aws_lb_ecs_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "aws_lb_internal" {
  type = bool
  description = "The name of the AWS Region we'll launch into."
}

variable "load_balancer_type" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "aws_lb_target_group_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}
variable "aws_lb_target_group_port" {
  type = number
  description = "The name of the AWS Region we'll launch into."
}
variable "aws_lb_target_group_protocol" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}
variable "aws_lb_target_group_type" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}


variable "aws_lb_listener_port" {
  type = number
  description = "The name of the AWS Region we'll launch into."
}
variable "aws_lb_listener_protocol" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "aws_lb_listener_default_action_type" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_task_definition_family" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_task_definition_network_mode" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_task_definition_container_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

variable "ecs_service_desired_count" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}
variable "ecs_service_deployment_minimum_healthy_percent" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}
variable "ecs_service_deployment_maximum_percent" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

# variable "ecs_task_definition_container_image" {
#   type = string
#   description = "The name of the AWS Region we'll launch into."
# }

# variable "ecs_task_definition_container_cpu_reservation" {
#   type = number
#   description = "The name of the AWS Region we'll launch into."
# }
# variable "ecs_task_definition_container_memory_reservation" {
#   type = number
#   description = "The name of the AWS Region we'll launch into."
# }

# variable "ecs_task_definition_container_env_name" {
#   type = string
#   description = "The name of the AWS Region we'll launch into."
# }
# variable "ecs_task_definition_container_env_value" {
#   type = string
#   description = "The name of the AWS Region we'll launch into."
# }
 

variable "ecs_service_iam_role" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

# variable "ecs_task_definition_container_port" {
#   type = number
#   description = "The name of the AWS Region we'll launch into."
# }

# variable "ecs_task_definition_container_hostport" {
#   type = number
#   description = "The name of the AWS Region we'll launch into."
# }
# variable "ecs_task_definition_container_protocol" {
#   type = string
#   description = "The name of the AWS Region we'll launch into."
# }



variable "ecs_service_backend_name" {
  type = string
  description = "The name of the AWS Region we'll launch into."
}

# variable "ecs_service_backend_name" {
#   type = string
#   description = "The name of the AWS Region we'll launch into."
# }






 