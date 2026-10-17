provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "Trend-Store-DevOps"
      ManagedBy   = "Terraform"
      Environment = "Learning"
    }
  }
}