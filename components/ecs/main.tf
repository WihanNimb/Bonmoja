module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.0.2"

  cluster_name = var.cluster_name

  create_task_exec_iam_role = true
  create_task_exec_policy   = true

  task_exec_iam_role_policies = {
    ecr_read_access  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    logs_full_access = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  }

  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 50
      base   = 20
    }
    FARGATE_SPOT = {
      weight = 50
    }
  }
}

resource "aws_security_group" "ecs_tasks" {
  description = "Allow HTTP 5678 inbound from internet"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_task_definition" "http_echo" {
  family                   = "http-echo-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.ecs_cluster.task_exec_iam_role_arn

  container_definitions = jsonencode([
    {
      name      = "http-echo"
      image     = "hashicorp/http-echo"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5678
          hostPort      = 5678
        }
      ]
      command = ["-text=hello world"]
    }
  ])
}

resource "aws_ecs_service" "http_echo_service" {
  name            = "http-echo-service"
  cluster         = module.ecs_cluster.cluster_id
  task_definition = aws_ecs_task_definition.http_echo.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.terraform_remote_state.vpc.outputs.pub_subnet_ids
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_tasks.id]
  }
}