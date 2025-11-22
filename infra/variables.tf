variable "prefix" {
  description = "Short prefix for resource names."
  type        = string
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}
