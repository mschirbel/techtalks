variable "region" {
  description = "Region in AWS"
  type        = string
}

variable "name" {
  description = "Name of Ec2"
  type        = string
}

variable "owner" {
  description = "Owner of stack"
  type        = string
}

variable "env" {
  description = "Environment for deployment"
  type        = string
}

variable "vpc_id" {
  description = "VPC in AWS"
  type        = string
}

variable "instance_size" {
  description = "EC2 Size"
  type        = string
}
