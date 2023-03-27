resource "aws_cloudwatch_dashboard" "app-asg-performance" {
  dashboard_name = "${var.project-name}-app-asg-dashboard"

  dashboard_body = jsonencode({
    "widgets" = [
      {
        "height" : 7,
        "width" : 10,
        "y" : 0,
        "x" : 0,
        "type" : "metric",
        "properties" : {
          "view" : "timeSeries",
          "stacked" : false,
          "metrics" : [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "app-ASG"],
            [".", "NetworkIn", ".", "."],
            [".", "NetworkOut", ".", "."],
            [".", "StatusCheckFailed", ".", "."],
            [".", "StatusCheckFailed_Instance", ".", "."]
          ],
          "region" : "us-east-1"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "web-asg-performance" {
  dashboard_name = "${var.project-name}-web-asg-dashboard"

  dashboard_body = jsonencode({
    "widgets" = [
      {
        "height" : 3,
        "width" : 24,
        "y" : 0,
        "x" : 0,
        "type" : "metric",
        "properties" : {
          "sparkline" : true,
          "view" : "singleValue",
          "metrics" : [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "web-ASG"],
            [".", "NetworkIn", ".", "."],
            [".", "NetworkOut", ".", "."],
            [".", "StatusCheckFailed", ".", "."],
            [".", "StatusCheckFailed_Instance", ".", "."]
          ],
          "region" : "us-east-1"
        }
      }
    ]
  })
}

