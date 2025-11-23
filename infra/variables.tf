variable "prefix" {
  description = "Short prefix for resource names (lowercase alphanumeric, 3-10 chars)."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,9}$", var.prefix))
    error_message = "prefix must be 3-10 lowercase alphanumeric characters starting with a letter."
  }
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name used in tags (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name for tagging."
  type        = string
  default     = "devops-aws-lab"
}

variable "additional_tags" {
  description = "Extra tags merged into all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet."
  type        = string
  default     = "10.20.2.0/24"
}

variable "availability_zone" {
  description = "AZ for subnets (e.g. us-east-1a)."
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host."
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to the bastion."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
