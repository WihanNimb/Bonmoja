output "sns_topic_arn" {
  value = module.sns_topic.topic_arn
  description = "ARN of the SNS topic"
}