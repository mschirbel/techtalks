resource "aws_sqs_queue" "terraform_queue" {
  name = var.sqs_name
  tags = {
    Name        = var.sqs_name
    Environment = var.env
  }
}
