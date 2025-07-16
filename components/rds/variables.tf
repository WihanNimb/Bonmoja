#vpc
variable "region" {
  description = "region to use"
  default     = "sa-east-1"   
}

variable "vpc_name" {
  description = "name of the vpc"
  default     = "wihan-test-vpc" 
}

variable "vpc_cidr" {
  description = "vpc cidr rang to use"
  default     = "192.168.0.0/24"
}

variable "subnet_newbits" {
  description = "subnet newbits to use"
  default     = [2, 3, 3]
}

variable "AZ_Total" {
  type        = number
  description = "No AZ to usey"
  default     = 2  
}

variable "pub_sub_total" {
  type        = number
  description = "No public subnets to deply"
  default     = 1
}

variable "pvt_sub_total" {
  type        = number
  description = "No private subnets to deply"
  default     = 2
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Deploy nat"
  default     = true  
}

variable "single_nat_gateway" {
  type        = bool
  description = "Single nat"
  default     = true  
}

variable "one_nat_gateway_per_az" {
  type        = bool
  description = "Multi-AZ nat"
  default     = false  
}

variable "env" {
  type        = string
  description = "environment deploying to"  
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
  type        = string
  description = "ecs cluster name"
  default     = "test"  
}


# dynamo DB
variable "dynamo_DB_name" {
  type        = string
  description = "dynamoDB name"
  default     = "test-DynamoDB"  
}

variable "billing_mode" {
  type        = string
  description = "Billing mode used"
  default     = "PAY_PER_REQUEST"  
}

