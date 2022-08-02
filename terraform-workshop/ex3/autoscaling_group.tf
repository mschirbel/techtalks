# Configuration for AutoScaling Group
resource "random_integer" "number" {
  min = 1
  max = 500
}

resource "aws_launch_configuration" "launch-configuration" {
  image_id             = data.aws_ami.amazon_linux_2.id
  instance_type        = var.instance_size
  security_groups      = [aws_security_group.instance_security_group.id]
  user_data            = data.template_file.user_data.rendered
  iam_instance_profile = aws_iam_instance_profile.workshop_ec2.arn
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group_config" {
  depends_on = [
    aws_lb.autoscaling_group_alb,
  ]
  name                      = format("%s-asg", var.name)
  max_size                  = 3
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 3
  force_delete              = true
  vpc_zone_identifier       = [for s in data.aws_subnet_ids.private.ids : s]
  launch_configuration      = aws_launch_configuration.launch-configuration.name
  target_group_arns         = [aws_lb_target_group.tg_group.arn]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = format("%s-asg", var.name)
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group_config.id
  alb_target_group_arn   = aws_lb_target_group.tg_group.arn
}
