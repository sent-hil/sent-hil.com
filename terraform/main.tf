provider "aws" {
  profile = var.aws_profile_name
  region  = var.aws_region
  version = "~> 2.69"
}
