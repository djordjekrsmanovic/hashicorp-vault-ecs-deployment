locals {
  environment = [
    for k, v in var.environment_variables : {
      name  = k
      value = v
    }
  ]

  secrets = [
    for k, v in var.secrets : {
      name      = k
      valueFrom = v
    }
  ]
}


data "aws_region" "current" {}

resource "aws_ecs_task_definition" "this" {
  family = "${var.environment_name}-${var.service_name}"

  container_definitions = jsonencode([
    {
      name      = "file-writer"
      image     = "busybox"
      essential = false
      environment = [
        {
          name  = "MY_CONFIG"
          value = base64encode(templatefile("${path.module}/vault.hcl", {
            endpoint   = "my env endpoint"
            kms_key_id = "${var.kms_key_id}"
          }))
        }
      ]

      command = [
        "sh",
        "-c",
        "echo $MY_CONFIG | base64 -d - | tee /vault/config/vault.hcl"
      ],

      mountPoints = [
        {
          sourceVolume  = "vault-config"
          containerPath = "/vault/config"
          readOnly      = false
        }
      ]
    },
    {
      name  = "application"
      image = var.container_image

      portMappings = [
        {
          containerPort = var.container_port
          name          = "application"
          protocol      = "tcp"
        }
      ]

      command = ["server"]

      essential              = true
      networkMode            = "awsvpc"
      readonlyRootFilesystem = false
      environment            = local.environment
      secrets                = local.secrets
      cpu                    = 0
      mountPoints            = []
      volumesFrom            = []

      # Mount the volume inside the container
      mountPoints = [
        {
          sourceVolume  = "vault-config"
          containerPath = "/vault/config"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.cloudwatch_logs_group_id
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "${var.service_name}-service"
        }
      }
    }
  ])

  # Define the volume
  volume {
    name = "vault-config"

    efs_volume_configuration {
      file_system_id          = var.file_system_id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      authorization_config {
        access_point_id = var.access_point_id
        iam             = "ENABLED"
      }
    }
  }

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn
}




//"healthCheck": {
        //"command": [ "CMD-SHELL", "curl -f http://localhost:${var.container_port}${var.healthcheck_path} || exit 1" ],
        //"interval": 10,
        //"startPeriod": 60,
        //"retries": 3,
        //"timeout": 5
      //},



resource "aws_ecs_service" "this" {
  name                   = var.service_name
  cluster                = var.cluster_arn
  task_definition        = aws_ecs_task_definition.this.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = true
  wait_for_steady_state  = true

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = var.subnet_ids
    assign_public_ip = var.is_public ? true : false
  }

  # Conditionally include service_connect_configuration
  dynamic "service_connect_configuration" {
    for_each = var.service_connect_enabled ? [1] : []
    content {
      enabled   = true
      namespace = var.service_discovery_namespace_arn
      service {
        client_alias {
          dns_name = var.service_name
          port     = "80"
        }
        discovery_name = var.service_name
        port_name      = "application"
      }
    }
  }

  dynamic "load_balancer" {
    for_each = var.alb_target_group_arn == "" ? [] : [1]

    content {
      target_group_arn = var.alb_target_group_arn
      container_name   = "application"
      container_port   = var.container_port
    }
  }

  tags = var.tags
}