locals {
  full_sqs_name = "${var.env}-${var.sqs_queue_name}"
  full_sns_name = "${var.env}-${var.sns_topic_name}"
}
