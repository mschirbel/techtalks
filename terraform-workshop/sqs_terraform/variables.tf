variable "sqs_name" {
  default     = "workshop-sqs"
  description = "SQS Name"
  type        = string
}

variable "region" {
  default = "eu-west-1"
}

variable "env" {
  default = "dev"
}
