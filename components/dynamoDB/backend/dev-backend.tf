terraform {
  backend "s3" {
    bucket = "terraform-state-000000000000"
    key    = "dev/dynamoDB/terraform.tfstate"

    region       = "sa-east-1"
    encrypt      = true
    use_lockfile = true
    kms_key_id   = "arn:aws:kms:sa-east-1:000000000000:key/26fede4e-b220-42d3-ac87-645a4928a3ba"
  }
}