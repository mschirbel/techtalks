resource "aws_lb" "autoscaling_group_alb" {
  name                       = format("%s-alb", var.name)
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_security_group.id]
  subnets                    = data.aws_subnet_ids.public.ids
  enable_deletion_protection = false

  tags = {
    Name = format("%s-alb", var.name)
  }

}

resource "aws_lb_target_group" "tg_group" {
  name        = format("%s-tg", var.name)
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = data.aws_vpc.selected.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.autoscaling_group_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_group.arn
  }
}
