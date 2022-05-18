# Ceros DevSecOps Code Challenge

Please start by reading `the-challenge.md`.  You can find the description of
the challenge, the acceptance criteria, and the grading criteria there.

## Architecture

The infrastructure for the Ceros-ski game is constructed in two, interdependent
pieces that must be deployed separately.  The first is the ECR repository that
will store the built docker images for the ceros-ski container.  The second is
the ECS Cluster that will run those docker images.

The ECS Cluster is currently built to use an EC2 Autoscaling group that sits in
a VPC across two availability zones.  It has a single service and a single task
definition.

The ECR Repository is defined in `infrastructure/repositories`.

The ECS Cluster is defined in `infrastructure/environments`.

All are currently configured to use local state.

## Usage

There are two separate infrastructures defined here.  The first defines the ECR
Repository and the second the actual ECS Environment.  The ECR Repository must
be created first, and the `repository_url` output taken and used as an input
variable for the ECS Environment.

### Creating the ECR Repository

To create the ECR Repository, you'll need to first initialize it with a .tfvars
file defining the credentials you want to use to access AWS and the region
you'd like to deploy to.

You can inspect `infrastructure/repositories/variables.tf` for a list of
required variables and attendant descriptions.  An example is shown below.

Example `infrastructure/repositories/terraform.tfvars`:
```
// Path to your .aws/credentials file.
aws_credentials_file = "/Users/malcolmreynolds/.aws/credentials"

// The name of the profile from your aws credentials file you'd like to use.
aws_profile = "serenity"

// The region we'll create the repository in
aws_region = "us-east-1"
```

Once you've created your tfvars file, you can run `terraform init` to
initialize terraform for this infrastructure.  You'll need to ensure you have
Terraform version 0.14+ installed.  Then you can run `terraform apply` to
create it.

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
build the ECS Stack.  Go to `infrastructure/environments`.  Run `terraform init` and
then populate the `terraform.tfvars` file.

Example `infrastructure/environments/terraform.tfvars`:
```
aws_credentials_file = "/Users/malcolmreynolds/.aws/credentials"
aws_profile = "serenity"
aws_region = "us-east-1"
repository_url = "<account #>.dkr.ecr.us-east-1.amazonaws.com/ceros-ski"
public_key_path = "/Users/malcolmreynolds/.ssh/id_rsa.pub"
```

Then you'll need to create the service linked role for ECS.  You can find the
full documentation for doing so
[here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using-service-linked-roles.html).
The TL;DR version is to run this command:

```
$ aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com
```

Once you've initialized the infrastructure, created the service linked role,
and created your .tfvars file, you can use `terraform apply` to create the ECS
infrastructure.
