resource "aws_launch_configuration" "granny_ecs" {
  name                 = "granny_ecs_lc"
  image_id             = "${lookup(var.amis, var.region)}"
  instance_type        = "t2.micro"
  key_name             = "${var.keypair}"
  iam_instance_profile = "${aws_iam_instance_profile.granny_ecs.id}"
  security_groups      = ["${aws_security_group.granny_ecs.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  user_data            = "${file("userdata/userdata.sh")}"
  associate_public_ip_address = false
}

/**
 * Autoscaling group.
 */
resource "aws_autoscaling_group" "granny_ecs" {
  name                 = "granny_ecs_asg"
  #availability_zones   = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier  = ["${split(",", var.private_subnets)}"]
  launch_configuration = "${aws_launch_configuration.granny_ecs.name}"
  /* @todo - variablize */
  min_size             = 2
  max_size             = 10
  desired_capacity     = 2
}


resource "aws_autoscaling_policy" "instance_scale_up" {
    name = "instance-scale-up"
    adjustment_type = "ChangeInCapacity"
    policy_type = "StepScaling"
    autoscaling_group_name = "${aws_autoscaling_group.granny_ecs.name}"
    step_adjustment {
      scaling_adjustment = 1
      metric_interval_lower_bound = 0
    }
}

resource "aws_autoscaling_policy" "instance_scale_down" {
    name = "instance-scale-down"
    adjustment_type = "ChangeInCapacity"
    policy_type = "StepScaling"
    autoscaling_group_name = "${aws_autoscaling_group.granny_ecs.name}"
    step_adjustment {
      scaling_adjustment = -1
      metric_interval_upper_bound = 0
    }
}