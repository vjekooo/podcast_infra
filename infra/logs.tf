# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "web_task_log_group" {
  name              = "/ecs/web_app"
  retention_in_days = 30

  tags = local.common_tags
}

resource "aws_cloudwatch_log_stream" "web_log_stream" {
  name           = "web_stream"
  log_group_name = aws_cloudwatch_log_group.web_task_log_group.name
}

resource "aws_cloudwatch_log_group" "server_task_log_group" {
  name              = "/ecs/server"
  retention_in_days = 30

  tags = local.common_tags
}

resource "aws_cloudwatch_log_stream" "server_log_stream" {
  name           = "server_stream"
  log_group_name = aws_cloudwatch_log_group.server_task_log_group.name
}