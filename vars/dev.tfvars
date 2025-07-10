region       = "sa-east-1"
env          = "dev"


# vpc
vpc_name = "wihan-test-vpc"
vpc_cidr = "192.168.0.0/24"
subnet_newbits = [2, 3, 3]
AZ_Total = 2
pub_sub_total = 1
pvt_sub_total = 2
enable_nat_gateway = true
single_nat_gateway = true
one_nat_gateway_per_az = false


# sns_sqs
sqs_queue_name = "sqs_queue"
sns_topic_name = "sns_topic"
sqs_delay_seconds = 0
sqs_visibility_timeout_seconds = 30
sqs_message_retention_seconds = 86400


# rds
identifier = "messaging-db"
db_name = "messaging"
engine = "postgres"
engine_version = "15"
family = "postgres15"
major_engine_version = "15" 
instance_class = "db.t3.micro"
allocated_storage = 20
max_allocated_storage = 100
username = "messaging_user"
password = "test123%"
port = 5432
multi_az = false


# ecs
cluster_name = "test"


# dynamo DB
dynamo_DB_name = "test_DynamoDB"
billing_mode = "PAY_PER_REQUEST"
