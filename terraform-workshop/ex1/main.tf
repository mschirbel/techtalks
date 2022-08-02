resource "aws_s3_bucket" "b" {
  bucket = var.name
  acl    = var.acl

  versioning {
    enabled = var.versioning
  }

  tags = {
    Name = var.name
  }
}
