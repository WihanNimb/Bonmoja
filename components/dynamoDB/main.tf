module "dynamodb_sessions" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "4.4.0" 

  name         = var.dynamo_DB_name
  billing_mode = var.billing_mode 

  hash_key = "sessionId"

  attributes = [
    {
      name = "sessionId"
      type = "S"
    }
  ]

}