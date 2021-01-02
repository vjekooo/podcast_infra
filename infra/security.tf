# security.tf

# ALB Security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "${local.prefix}-alb"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = var.web_app_port
    to_port     = var.web_app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_service_web" {
  name        = "${local.prefix}-ecs-web"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = var.web_app_port
    to_port         = var.web_app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# resource "aws_security_group" "ecs_service_server" {
#   name        = "${local.prefix}-ecs-server"
#   description = "allow inbound access from the web service only"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     protocol        = "tcp"
#     from_port       = var.app_port
#     to_port         = var.app_port
#     security_groups = [aws_security_group.ecs_service_web.id]
#   }

#   egress {
#     protocol    = "-1"
#     from_port   = 0
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = local.common_tags
# }