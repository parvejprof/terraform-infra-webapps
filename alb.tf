resource "aws_alb" "alb" {
  name            = "terraform-demo-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id]
  tags = {
    Name = "terraform-demo-alb"
  }
}

resource "aws_alb_target_group" "group" {
  name     = "terraform-example-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo-vpc.id

  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_alb_target_group.group.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}