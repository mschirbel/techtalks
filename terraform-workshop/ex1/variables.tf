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

variable "acl" {
  default     = "private"
  description = "Status for bucket policy"
  type        = string
}

variable "versioning" {
  default     = true
  description = "Status for bucket policy"
  type        = bool
}
