resource "aws_sns_topic" "name" {
  name         = "lab-topic"
  display_name = "Lab Topic"
  fifo_topic   = false
}

resource "aws_sns_topic_subscription" "name" {
  topic_arn    = aws_sns_topic.name.arn
  protocol     = "email"
  endpoint     = "rvaldez@gmail.com"

}