####################################
# CloudWatch Logs
####################################

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/devops-assessment"
  retention_in_days = 7
}

####################################
# ECS Cluster
####################################

resource "aws_ecs_cluster" "cluster" {
  name = "assessment-cluster"
}

####################################
# Task Definition
####################################

resource "aws_ecs_task_definition" "task" {
  family                   = "assessment-task"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = "nginx:latest"

      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

####################################
# ECS Service
####################################

resource "aws_ecs_service" "service" {
  name            = "assessment-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {

    assign_public_ip = false

    security_groups = [
      aws_security_group.ecs_sg.id
    ]

    subnets = [
      aws_subnet.private_1.id,
      aws_subnet.private_2.id
    ]
  }

  load_balancer {

    target_group_arn = aws_lb_target_group.ecs_tg.arn

    container_name = "nginx"

    container_port = 80
  }

  depends_on = [
    aws_lb_listener.http
  ]
}
