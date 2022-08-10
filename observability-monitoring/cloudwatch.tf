
# AWS Services that publish Cloudwatch Metrics
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html
resource "aws_cloudwatch_metric_alarm" "name" {
  alarm_name          = "GreaterThanOrEqualToThreshold-CPUUtilization"
  period              = "60" # Period
  metric_name         = "CPUUtilization" # Type of data to samble
  statistic           = "Average" # Group samples by
  namespace           = "AWS/EC2"
  comparison_operator = "GreaterThanThreshold" # Alarm when
  threshold           = 60
  unit                = "Percent"
  evaluation_periods = 1 # Consecutive period
  dimensions         = {
    InstanceId = aws_instance.name.id
  }
  actions_enabled    = "true"
  alarm_actions      = [ aws_sns_topic.name.arn ]
}