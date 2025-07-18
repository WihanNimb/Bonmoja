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

resource "aws_cloudwatch_metric_alarm" "sqs_queue_depth_high" {
  alarm_name          = "${local.full_sqs_name}-queue-depth-high"
  alarm_description   = "Alarm when SQS queue depth exceeds 100 messages"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  statistic           = "Average"
  period              = 300                # 5 minutes
  evaluation_periods  = 2                  # 2 periods of 5 mins = 10 mins
  threshold           = 100
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    QueueName = module.sqs_queue.queue_name
  }

  alarm_actions = [module.sns_topic.topic_arn]
  ok_actions    = [module.sns_topic.topic_arn]
}
