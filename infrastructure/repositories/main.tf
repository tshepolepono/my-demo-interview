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
*  Add scan on push to see image vulnerabilities
*/

resource "aws_ecr_repository" "ceros_ski" {
  name = "ceros-ski"
  image_tag_mutability = "MUTABLE"

   image_scanning_configuration {
    scan_on_push = true
  }
}
