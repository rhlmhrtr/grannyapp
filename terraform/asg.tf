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
  availability_zones   = ["${split(",", var.availability_zones)}"]
  launch_configuration = "${aws_launch_configuration.granny_ecs.name}"
  /* @todo - variablize */
  min_size             = 1
  max_size             = 10
  desired_capacity     = 1
}
