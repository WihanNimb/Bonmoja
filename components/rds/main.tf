module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  identifier            = var.identifier
  engine                = var.engine
  engine_version        = var.engine_version
  family                = var.family
  major_engine_version  = var.major_engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage

  username = var.username
  password = var.password
  port     = var.port
  db_name  = var.db_name

  # Networking
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name

  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 7
  multi_az                = var.multi_az
}

resource "aws_db_subnet_group" "rds_subnets" {
  name       = local.db_subnet_group_name
  subnet_ids = data.terraform_remote_state.vpc.outputs.pvt_subnet_ids

}

resource "aws_security_group" "rds_sg" {
  name        = local.rds_security_group_name
  description = "Allow PostgreSQL traffic from ECS tasks"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description     = "Postgres from ECS tasks"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.ecs.outputs.ecs_tasks_sg_id] # You’ll output this from ECS component
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
