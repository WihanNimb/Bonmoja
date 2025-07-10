#vpc
variable "region" {
  
}

variable "vpc_name" {
  
}

variable "vpc_cidr" {
  
}

variable "subnet_newbits" {
  
}

variable "AZ_Total" {
  
}

variable "pub_sub_total" {
  
}

variable "pvt_sub_total" {
  
}

variable "enable_nat_gateway" {
  
}

variable "single_nat_gateway" {
  
}

variable "one_nat_gateway_per_az" {
  
}

variable "env" {
  
}


# sns_sqs
variable "sqs_queue_name" {
  type        = string
  description = "Name of the SQS queue"
}

variable "sqs_delay_seconds" {
  type        = number
  description = "Delay seconds for the SQS queue"
  default     = 0
}

variable "sqs_visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout for the SQS queue"
  default     = 30
}

variable "sqs_message_retention_seconds" {
  type        = number
  description = "Message retention period for the SQS queue"
  default     = 86400
}

variable "sns_topic_name" {
  type        = string
  description = "Name of the SNS topic"
}


# rds
variable "identifier" {
  type        = string
  description = "RDS instance identifier"
  default     = "messaging-db"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "messaging"
}

variable "engine" {
  type        = string
  description = "Database engine"
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  description = "Database engine version"
  default     = "15"
}

variable "family" {
  type        = string
  description = "DB parameter group family"
  default     = "postgres15"
}

variable "major_engine_version" {
  type        = string
  description = "Major engine version"
  default     = "15"
}

variable "instance_class" {
  type        = string
  description = "Instance class"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Allocated storage in GB"
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  description = "Maximum allocated storage in GB"
  default     = 100
}

variable "username" {
  type        = string
  description = "Master username"
  default     = "messaging_user"
}

variable "password" {
  type        = string
  description = "Master password"
  sensitive   = true
  default     = "messaging_password"  # For prod, override via tfvars or secret manager
}

variable "port" {
  type        = number
  description = "Database port"
  default     = 5432
}

variable "multi_az" {
  type        = bool
  description = "Multi-AZ deployment"
  default     = false
}


# ecs
variable "cluster_name" {
  
}


# dynamo DB
variable "dynamo_DB_name" {
  
}

variable "billing_mode" {
  
}

