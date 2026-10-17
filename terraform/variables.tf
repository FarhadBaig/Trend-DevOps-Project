variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "trend-project"
}

variable "project_name" {
  description = "Project resource name prefix"
  type        = string
  default     = "trend-store"
}

variable "allowed_admin_cidr" {
  description = "Public IPv4 address allowed to access Jenkins and SSH"
  type        = string
  default     = "103.177.202.249/32"

  validation {
    condition     = can(cidrhost(var.allowed_admin_cidr, 0))
    error_message = "Provide a valid IPv4 CIDR, such as 203.0.113.10/32."
  }
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name"
  type        = string
  default     = "trend-jenkins-key"
}