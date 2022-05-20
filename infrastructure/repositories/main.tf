/******************************************************************************
* ECR
*
* Create the repo and initialize it with our docker image first.  Just push the
* image to "latest" to start with.
*
********************************************************************************/

/**
* The ECR repository we'll push our images to.
*/
/**
*  scan_on_push to see image security vulnerabilities
*/
resource "aws_ecr_repository" "ceros_ski" {
  
  name  = var.aws_ecr_name
  image_tag_mutability = var.aws_ecr_tag_mutability

  image_scanning_configuration {
    
	   scan_on_push = var.ecr_scan_on_push
  }

}
