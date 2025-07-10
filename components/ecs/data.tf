data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-000000000000"
    key    = "dev/vpc/terraform.tfstate"
    region = "sa-east-1"
  }
}