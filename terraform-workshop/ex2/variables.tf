variable "region" {
  default     = "eu-west-1"
  description = "Region in AWS"
  type        = string
}

variable "name" {
  default     = "workshop-answer"
  description = "Name of Ec2"
  type        = string
}

variable "owner" {
  default     = "marcelo"
  description = "Owner of stack"
  type        = string
}

variable "env" {
  default     = "dev"
  description = "Environment for deployment"
  type        = string
}

variable "vpc_id" {
  default     = "vpc-0c11e348540172ee4"
  description = "VPC in AWS"
  type        = string
}

variable "instance_size" {
  default     = "t3.medium"
  description = "EC2 Size"
  type        = string
}
