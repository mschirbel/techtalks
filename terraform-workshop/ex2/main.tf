# Instance
resource "random_integer" "number" {
  min = 1
  max = 500
}

resource "aws_instance" "web" {
  depends_on = [
    aws_iam_instance_profile.workshop_ec2
  ]
  ami                         = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_size
  user_data                   = data.template_file.user_data.rendered
  iam_instance_profile        = aws_iam_instance_profile.workshop_ec2.name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = element(tolist(data.aws_subnet_ids.private.ids), 0)

  tags = {
    Name = var.name
  }
}

# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = format("%s-sg", var.name)
  description = "Allow traffic"
  vpc_id      = data.aws_vpc.selected.id

  tags = {
    Name = format("%s-sg", var.name)
  }
}

resource "aws_security_group_rule" "allow-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

# allow SSM connection to the instance
resource "aws_iam_instance_profile" "workshop_ec2" {
  name = format("%s-ec2-profile", var.name)
  role = aws_iam_role.ec2_workshop_role.name
}

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
