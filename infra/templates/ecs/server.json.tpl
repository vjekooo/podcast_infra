[
 	{
		"name": "server",
		"image": "${server_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/server_app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs_server"
        }
    },
    "portMappings": [
      {
        "containerPort": 4000,
        "hostPort": 4000
      }
    ]
  }
]
