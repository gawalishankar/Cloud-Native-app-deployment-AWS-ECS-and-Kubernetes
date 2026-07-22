# =========================================================
# ECS CLUSTER
# =========================================================

resource "aws_ecs_cluster" "main" {
  name = "${local.name_prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${local.name_prefix}-cluster"
  }
}


# =========================================================
# CLOUDWATCH LOG GROUP
# =========================================================

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = 7

  tags = {
    Name = "${local.name_prefix}-logs"
  }
}


# =========================================================
# ECS TASK DEFINITION
# =========================================================

resource "aws_ecs_task_definition" "app" {
  family = "${local.name_prefix}-task"

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"

  cpu    = var.container_cpu
  memory = var.container_memory

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "fusion"
      image     = var.docker_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.mysql.address
        },
        {
          name  = "DB_PORT"
          value = "3306"
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "DB_PASS"
          value = var.db_password
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "${local.name_prefix}-task"
  }
}


# =========================================================
# ECS SERVICE
# =========================================================

resource "aws_ecs_service" "app" {
  name = "${local.name_prefix}-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.app.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  platform_version = "LATEST"

  # -------------------------------------------------------
  # ECS NETWORK CONFIGURATION
  # -------------------------------------------------------

  network_configuration {
    subnets = aws_subnet.private_app[*].id

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  # -------------------------------------------------------
  # ALB CONFIGURATION
  # -------------------------------------------------------

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn

    container_name = "fusion"

    container_port = var.container_port
  }

  # -------------------------------------------------------
  # DEPLOYMENT CONFIGURATION
  # -------------------------------------------------------

  deployment_minimum_healthy_percent = 50

  deployment_maximum_percent = 200

  # -------------------------------------------------------
  # HEALTH CHECK GRACE PERIOD
  # -------------------------------------------------------

  health_check_grace_period_seconds = 60

  # -------------------------------------------------------
  # DEPLOYMENT CIRCUIT BREAKER
  # -------------------------------------------------------

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # -------------------------------------------------------
  # DEPENDS ON ALB LISTENER
  # -------------------------------------------------------

  depends_on = [
    aws_lb_listener.http
  ]

  tags = {
    Name = "${local.name_prefix}-service"
  }
}