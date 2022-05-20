/******************************************************************************
* VPC
*******************************************************************************/

/**
* The VPC is the private cloud that provides the network infrastructure into
* which we can launch our aws resources.  This is effectively the root of our
* private network.
*/
resource "aws_vpc" "main_vpc" {
  cidr_block = "172.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

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
resource "aws_subnet" "public_subnet_1a" {
  vpc_id = aws_vpc.main_vpc.id 
  availability_zone = "us-east-1a" 
  cidr_block = "172.0.1.0/24"
  map_public_ip_on_launch = true

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
resource "aws_route_table" "public_1a_route_table" {
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
resource "aws_route" "route_from_public_1a_route_table_to_internet" {
  route_table_id = aws_route_table.public_1a_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_internet_gateway.id

}

/**
* Associate the public route table with the public subnet.
*/
resource "aws_route_table_association" "public_1a_route_table_to_public_subnet_association" {
  subnet_id = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_1a_route_table.id
}

/******************************************************************************
* Public Subnet for 1c
*******************************************************************************/

/**
* A public subnet with in our VPC that we can launch resources into that we
* want to be auto-assigned public ip addresses.  These resources will be
* exposed to the public internet, with public IPs, by default.  
**/
resource "aws_subnet" "public_subnet_1c" {
  vpc_id = aws_vpc.main_vpc.id 
  availability_zone = "us-east-1c" 
  cidr_block = "172.0.3.0/24"
  map_public_ip_on_launch = true

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
resource "aws_route_table" "public_1c_route_table" {
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
resource "aws_route" "route_from_public_1c_route_table_to_internet" {
  route_table_id = aws_route_table.public_1c_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_internet_gateway.id

}

/**
* Associate the public route table with the public subnet.
*/
resource "aws_route_table_association" "public_1c_route_table_to_public_subnet_association" {
  subnet_id = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_1c_route_table.id
}


/******************************************************************************
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
  name = "ceros-ski-${var.environment}"

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
      "s3:*"
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
  name = "ceros-ski-ecs-agent-policy"
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
  name = "ceros-ski-ecs-agent"
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
  name = "ceros-ski-ecs-agent"
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
  name        = "ceros-ski-${var.environment}-autoscaling_group"
  description = "Security Group for the Autoscaling group which provides the instances for the ECS Cluster."
  vpc_id      = aws_vpc.main_vpc.id 

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
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

/**
* The launch configuration for the autoscaling group that backs our cluster.  
*/
resource "aws_launch_configuration" "cluster" {
  name = "ceros-ski-${var.environment}-cluster"
  image_id = data.aws_ssm_parameter.cluster_ami_id.value 
  instance_type = "t3.micro"
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
  name = "ceros-ski-${var.environment}-cluster"
  min_size = 2
  max_size = 2 
  
  vpc_zone_identifier = [ aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1c.id ] 
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
  name        = "ceros-ski-${var.environment}-ecs_load_balancer"
  description = "Security Group for the ECS Load Balancer"
  vpc_id      = aws_vpc.main_vpc.id 

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
resource "aws_lb" "ecs" {
  name = "ceros-ski-${var.environment}-ecs"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.ecs_load_balancer.id]
  subnets = [ aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1c.id]

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
  name = "ceros-ski-${var.environment}-backend"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.main_vpc.id 

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
  port = "80"
  protocol = "HTTP"
 
  default_action {
    type = "forward"
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
  family = "ceros-ski-${var.environment}-backend"
  network_mode = "bridge"

  container_definitions = <<EOF
[
  {
    "name": "ceros-ski",
    "image": "${var.repository_url}:latest",
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
  name = "AWSServiceRoleForECS"
}

/**
* Create the ECS Service that will wrap the task definition.  Used primarily to
* define the connections to the load balancer and the placement strategies and
* constraints on the tasks.
*/
resource "aws_ecs_service" "backend" {
  name = "ceros-ski-${var.environment}-backend"
  cluster = aws_ecs_cluster.cluster.id 
  task_definition = aws_ecs_task_definition.backend.arn

  iam_role        = data.aws_iam_role.ecs_service.arn
  
  desired_count = 2 
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 100

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name = "ceros-ski"
    container_port = "80"
  } 

  tags = {
    Application = "ceros-ski" 
    Environment = var.environment 
    Resource = "modules.environment.aws_ecs_service.backend"
  }
}

