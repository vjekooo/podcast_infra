
resource "aws_ecs_cluster" "main" {
  name = "${local.prefix}-cluster"

  tags = local.common_tags
}

data "template_file" "web_app" {
  template = file("./templates/ecs/web_app.json.tpl")

  vars = {
    web_image      = var.ecr_web_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "${local.prefix}-web-task-definition"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.web_app.rendered

  tags = local.common_tags
}

resource "aws_ecs_service" "main" {
  name            = "${local.prefix}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_service.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.web.id
    container_name   = "web_app"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.web, aws_iam_role_policy_attachment.ecs_task_execution_role]
}