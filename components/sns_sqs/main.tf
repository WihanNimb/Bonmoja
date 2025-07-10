module "sqs_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "5.0.0"

  name                       = local.full_sqs_name
  delay_seconds              = var.sqs_delay_seconds
  visibility_timeout_seconds = var.sqs_visibility_timeout_seconds
  message_retention_seconds  = var.sqs_message_retention_seconds

  create_queue_policy = true

  queue_policy_statements = {
    sns_publish = {
      sid     = "SNSPublish"
      actions = ["sqs:SendMessage"]

      principals = [
        {
          type        = "Service"
          identifiers = ["sns.amazonaws.com"]
        }
      ]

      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values   = [module.sns_topic.topic_arn]
      }]
    }
  }
}

module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "6.2.0"

  name = local.full_sns_name

  topic_policy_statements = {
    sqs_subscriber = {
      sid = "SQSSubscribe"
      actions = [
        "sns:Subscribe",
        "sns:Receive",
      ]
      principals = [{
        type        = "AWS"
        identifiers = ["*"]
      }]
      conditions = [{
        test     = "StringLike"
        variable = "sns:Endpoint"
        values   = [module.sqs_queue.queue_arn]
      }]
    }
  }

  subscriptions = {
    sqs = {
      protocol = "sqs"
      endpoint = module.sqs_queue.queue_arn
    }
  }
}
