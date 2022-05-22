/*******************************************************************************
* ECS Cluster
*
* Create ECS Cluster and its supporting services, in this case EC2 instances in
* and Autoscaling group.
*
* *****************************************************************************/

/**
* The ECS Cluster and its services and task groups. 
*
* The ECS Cluster has no dependencies, but will be referenced in the launch
* configuration, may as well define it first for clarity's sake.
*/

resource "aws_ecs_cluster" "cluster" {
  name = var.ecs_cluster_name

  tags = {
    Application = "ceros-ski"
    Environment = var.environment
    Resource = "modules.environment.aws_ecs_cluster.cluster"
  }
}

/*******************************************************************************
* AutoScaling Group
*
* The autoscaling group that will generate the instances used by the ECS
* cluster.
*
********************************************************************************/

/**
* The IAM policy needed by the ecs agent to allow it to manage the instances
* that back the cluster.  This is the terraform structure that defines the
* policy.
*/
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      //"s3:*"
    ]
    resources = [
      "*"
    ]
  }
}

/**
* The policy resource itself.  Uses the policy document defined above.
*/
resource "aws_iam_policy" "ecs_agent" {
  name = var.ecs_agent_iam_policy
  path = "/"
  description = "Access policy for the EC2 instances backing the ECS cluster."

  policy = data.aws_iam_policy_document.ecs_agent.json
}

/**
* A policy document defining the assume role policy for the IAM role below.
* This is required.
*/
data "aws_iam_policy_document" "ecs_agent_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

}

/**
* The IAM role that will be used by the instances that back the ECS Cluster.
*/
resource "aws_iam_role" "ecs_agent" {
  name = var.ecs_agent_iam_role
  path = "/"

  assume_role_policy = data.aws_iam_policy_document.ecs_agent_assume_role_policy.json
}

/**
* Attatch the ecs_agent policy to the role.  The assume_role policy is attached
* above in the role itself.
*/
resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role = aws_iam_role.ecs_agent.name 
  policy_arn = aws_iam_policy.ecs_agent.arn 
}

/**
* The Instance Profile that associates the IAM resources we just finished
* defining with the launch configuration.
*/
resource "aws_iam_instance_profile" "ecs_agent" {
  name = var.ecs_agent_iam_instance_profile
  role = aws_iam_role.ecs_agent.name 
}

/**
* A security group for the instances in the autoscaling group allowing HTTP
* ingress.  With out this the Target Group won't be able to reach the instances
* (and thus the containers) and the health checks will fail, causing the
* instances to be deregistered.
*
* Allowing all traffic between ALB and ASG caters for node dynamic ports
* This traffic is private and internal 
*/
resource "aws_security_group" "autoscaling_group" {
  name        = var.asg_security_group_name
  description = "Security Group for the Autoscaling group which provides the instances for the ECS Cluster."
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Application = "ceros-ski"
    Environment = var.environment
    Resource = "modules.environment.aws_security_group.autoscaling_group"
  }
}

/** 
* This parameter contains the AMI ID of the ECS Optimized version of Amazon
* Linux 2 maintained by AWS.  We'll use it to launch the instances that back
* our ECS cluster.
*/
data "aws_ssm_parameter" "cluster_ami_id" {
  name = var.aws_ssm_cluster_ami_id
}

/**
* The launch configuration for the autoscaling group that backs our cluster.  
*/
#tfsec:ignore:aws-autoscaling-enable-at-rest-encryption
resource "aws_launch_configuration" "cluster" {
  name = var.aws_launch_configuration_name
  image_id = data.aws_ssm_parameter.cluster_ami_id.value 
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups = [aws_security_group.autoscaling_group.id]

  // Register our EC2 instances with the correct ECS cluster.
  user_data = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=${aws_ecs_cluster.cluster.name}" >> /etc/ecs/ecs.config
EOF
}

/**
* The autoscaling group that backs our ECS cluster.
*/
resource "aws_autoscaling_group" "cluster" {
  name = var.asg_cluster_name
  min_size = var.asg_min_size
  max_size = var.asg_max_size
  
  vpc_zone_identifier = [ var.public_subnet_1, var.public_subnet_2 ] 
  launch_configuration = aws_launch_configuration.cluster.name 

  tags = [{
    "key" = "Application"
    "value" = "ceros-ski"
    "propagate_at_launch" = true
  },
  {
    "key" = "Environment"
    "value" = var.environment
    "propagate_at_launch" = true
  },
  {
    "key" = "Resource"
    "value" = "modules.environment.aws_autoscaling_group.cluster"
    "propagate_at_launch" = true
  }]
}

/******************************************************************************
 * Load Balancer
 *
 * The load balancer that will direct traffic to our backend services.
 ******************************************************************************/

/**
* The Security Group used by the Elastic Load Balancer that will sit in front
* of our ECS services.  It needs to allow HTTP ingress or else we won't be able
* to reach our service from the outside world.
*
* Set port to 80 and protocol to tcp to allow only http inbound
*/
resource "aws_security_group" "ecs_load_balancer" {
  name        = var.alb_security_group_name
  description = "Security Group for the ECS Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP Ingress"
    from_port   = 80 
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment
    Resource = "modules.environment.aws_security_group.ecs_load_balancer"
  }
}


/**
* The load balancer that is used by the ECS Services. 
*/
#tfsec:ignore:aws-elb-drop-invalid-headers
resource "aws_lb" "ecs" {
  name = var.aws_lb_ecs_name
  internal = var.aws_lb_internal 
  load_balancer_type = var.load_balancer_type 
  security_groups = [aws_security_group.ecs_load_balancer.id]
  subnets = [ var.public_subnet_1, var.public_subnet_2]

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment
    Resource = "modules.environment.aws_lb.ecs"
  }
}

/**
* A target group to use with ceros-ski's backend ECS service.
*/
resource "aws_lb_target_group" "backend" {
  name = var.aws_lb_target_group_name 
  port = var.aws_lb_target_group_port 
  protocol = var.aws_lb_target_group_protocol 
  target_type = var.aws_lb_target_group_type 
  vpc_id = var.vpc_id

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Resource = "modules.environment.aws_lb_target_group.backend"
  }
}

/**
* Wire the backend service up to the load balancer in the ecs_cluster.
*/
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.ecs.arn 
  port = var.aws_lb_listener_port
  protocol = var.aws_lb_listener_protocol
 
  default_action {
    type = var.aws_lb_listener_default_action_type
    target_group_arn = aws_lb_target_group.backend.arn
  }
}


/******************************************************************************
 *  ECS Service
 *
 *  The task and service definitions for our backend ECS Service.
 ******************************************************************************/

/**
* Create the task definition for the ceros-ski backend, in this case a thin
* wrapper around the container definition.
*/
resource "aws_ecs_task_definition" "backend" {
  family = var.ecs_task_definition_family
  network_mode = var.ecs_task_definition_network_mode

    container_definitions = <<EOF
[
  {
    "name": "ceros-ski",
    "image": "760195539997.dkr.ecr.us-east-1.amazonaws.com/ceros-ski:latest",
    "environment": [
      {
        "name": "PORT",
        "value": "80"
      }
    ],
    "cpu": 512,
    "memoryReservation": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
EOF

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Name = "ceros-ski-${var.environment}-backend"
    Resource = "modules.environment.aws_ecs_task_definition.backend"
  }
}

/**
* This role is automatically created by ECS the first time we try to use an ECS
* Cluster.  By the time we attempt to use it, it should exist.  However, there
* is a possible TECHDEBT race condition here.  I'm hoping terraform is smart
* enough to handle this - but I don't know that for a fact. By the time I tried
* to use it, it already existed.
*/
data "aws_iam_role" "ecs_service" {
  name = var.ecs_service_iam_role
}

/**
* Create the ECS Service that will wrap the task definition.  Used primarily to
* define the connections to the load balancer and the placement strategies and
* constraints on the tasks.
*/
resource "aws_ecs_service" "backend" {
  name = var.ecs_service_backend_name
  cluster = aws_ecs_cluster.cluster.id 
  task_definition = aws_ecs_task_definition.backend.arn

  iam_role        = data.aws_iam_role.ecs_service.arn
  
  desired_count = var.ecs_service_desired_count
  deployment_minimum_healthy_percent = var.ecs_service_deployment_minimum_healthy_percent
  deployment_maximum_percent = var.ecs_service_deployment_maximum_percent

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name = var.ecs_task_definition_container_name 
    container_port = "80"
  } 

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Resource = "modules.environment.aws_ecs_service.backend"
  }
}

