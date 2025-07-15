data "terraform_remote_state" "vpc" {
  backend = "s3"
  
  config = {
    access_key = "test"
    bucket = "terraform-state-000000000000"
    endpoints = {
      s3 = "http://s3.localhost.localstack.cloud:4566"
      iam = "http://localhost:4566"
      sso = "http://localhost:4566"
      sts = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
    }
    key = "dev/vpc/terraform.tfstate"
    region = "sa-east-1"
    secret_key = "test"
    skip_credentials_validation = true
    skip_metadata_api_check = true
  }
}