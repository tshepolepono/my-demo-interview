

## Architecture

The infrastructure for the Ceros-ski game is constructed in 3, interdependent
pieces that must be deployed separately.  The first is the ECR repository that
will store the built docker images for the ceros-ski container, the second  the networking to be used ad third ECS Cluster that will run those docker images.

The ECS Cluster is currently built to use an EC2 Autoscaling group that sits in
a VPC across two availability zones.  It has a single service and a single task
definition.

The ECR Repository is defined in `modules/repositories`.

The networking is defined in `modules/networking`.

The ECS Cluster is defined in `modules/ecs_resources`.



All are currently configured to use local state.

## Usage

There are 3 separate infrastructures defined here.  The first defines the ECR
Repository, , second  networking and the third  actual ECS Environment.  The ECR Repository must
be created first, then networking and the `repository_url` output taken and used as an input
variable for the ECS Environment.

### Creating the ECR Repository

To create the ECR Repository, you'll need to first initialize it with a .tfvars
file on root directory defining the credentials you want to use to access AWS and the region
you'd like to deploy to.

 An example is shown below.

Example `infrastructure/repositories/terraform.tfvars`:
```
// Path to your .aws/credentials file.
aws_credentials_file = "C:/Users/tshepol/.aws/credentials" 

// The name of the profile from your aws credentials file you'd like to use.
aws_profile = "default"

// The region we'll create the repository in
aws_region = "us-east-1"

Once you've created your tfvars file, you can run `terraform init` to
initialize terraform for this infrastructure.  You'll need to ensure you have
Terraform version 0.14+ installed.  Then you can run below command to target ecr repo module;

terraform apply -target="module.repository.aws_ecr_repository.ceros_ski" 

After terraform has run it will output the repository URL, which you will need
to push an initial docker image and to give to the ECS stack to pull the image.

### Pushing an Initial Docker Image

Before you can build the ECS infrastructure, you'll need to push an initial
docker image to the ECR repository.  The ECS infrastructure will pull the
`latest` tag, so you'll want to push that tag to the repository.

From the root project directory.
```
# If you are on Intel/AMD hardware, you can build the docker image using the
# build command.
$ docker build -t ceros-ski app 

# If you are on Apple silicon (M1, etc), you'll need to use the experimental
# buildx command.
$ docker buildx build --platform linux/amd64 -t ceros-ski app

# Tag the docker image.
$ docker tag ceros-ski <repository_url>/ceros-ski:latest

# Login to ECR.  
$ aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <repository_url> 

# Push the docker image to ECR.
$ docker push <repository_url>/ceros-ski:latest
```

### Building the ECS Stack

Once you've built the repo and push the initial docker image, then you need to
build the ECS Stack.  Run terraform plan and apply on root directory, this will ignore ecr created and it will go ahead and create networking and ecs cluster.


