# Security Groups for Instances
resource "aws_security_group" "instance_security_group" {
  name   = format("%s-instance-sg", var.name)
  vpc_id = data.aws_vpc.selected.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-instance-sg", var.name)
  }
}

## ALB Security Group

resource "aws_security_group" "alb_security_group" {
  name   = format("%s-alb-sg", var.name)
  vpc_id = data.aws_vpc.selected.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = format("%s-alb-sg", var.name)
  }
}

