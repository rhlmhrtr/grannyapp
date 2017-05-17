
resource "aws_appautoscaling_target" "main" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.granny_app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${aws_iam_role.ecs_autoscale_role.arn}"
  min_capacity       = "${var.min_count}"
  max_capacity       = "${var.max_count}"

  depends_on = [
    "aws_ecs_service.granny_app",
  ]
}

resource "aws_appautoscaling_policy" "service_scale_up" {
  name               = "${aws_ecs_service.granny_app.name}ScalingUpPolicy"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.granny_app.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  metric_aggregation_type = "Average"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment          = 1
  }

  depends_on = [
    "aws_appautoscaling_target.main",
  ]
}

resource "aws_appautoscaling_policy" "service_scale_down" {
  name               = "${aws_ecs_service.granny_app.name}ScalingDownPolicy"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.granny_app.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  metric_aggregation_type = "Average"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }

  depends_on = [
    "aws_appautoscaling_target.main",
  ]
}

resource "aws_cloudwatch_metric_alarm" "cpuutilization_high" {
  alarm_name = "${aws_ecs_service.granny_app.name}_cpuutilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "60"
  statistic = "Average"
  threshold = "60"

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.instance_scale_up.arn}","${aws_appautoscaling_policy.service_scale_up.arn}"]
  depends_on = [
    "aws_appautoscaling_policy.service_scale_up",
    "aws_autoscaling_policy.instance_scale_up"
  ]
}

resource "aws_cloudwatch_metric_alarm" "cpuutilization_low" {
  alarm_name = "${aws_ecs_service.granny_app.name}_cpuutilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "60"
  statistic = "Average"
  threshold = "10"

  dimensions {
    ClusterName = "${var.ecs_cluster_name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.instance_scale_down.arn}","${aws_appautoscaling_policy.service_scale_down.arn}"]

    depends_on = [
    "aws_appautoscaling_policy.service_scale_down",
    "aws_autoscaling_policy.instance_scale_down"
  ]
}


