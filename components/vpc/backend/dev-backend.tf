terraform {
  backend "s3" {
    access_key = "test"
    bucket = "terraform-state-000000000000"
    encrypt = true
    endpoints = {
      s3 = "http://s3.localhost.localstack.cloud:4566"
      iam = "http://localhost:4566"
      sso = "http://localhost:4566"
      sts = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
    }
    key = "dev/vpc/terraform.tfstate"
    kms_key_id = "arn:aws:kms:sa-east-1:000000000000:key/94e957dd-7607-493b-a6e0-a7d477891020"
    region = "sa-east-1"
    secret_key = "test"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    use_lockfile = true
  }
}