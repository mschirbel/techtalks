resource "aws_iam_role" "ec2_workshop_role" {
  name = format("%s-role", var.name)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = var.name
  }
}

resource "aws_iam_policy" "ec2_policy" {
  name        = format("%s-policy", var.name)
  path        = "/"
  description = "My Workshop policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetEncryptionConfiguration",
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "kms:Decrypt"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.ec2_workshop_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role       = aws_iam_role.ec2_workshop_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "workshop_ec2" {
  name = format("%s-ec2-profile", var.name)
  role = aws_iam_role.ec2_workshop_role.name
}
