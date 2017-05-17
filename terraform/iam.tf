/* ecs service scheduler policy & role */


resource "template_file" "ecs_service_role_policy" {
  template = "${file("policies/ecs-service-role-policy.json")}"

  vars {
    s3_bucket_name = "${var.s3_bucket_name}"
  }
}




/* ecs iam role and assume_role_policy */
resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = "${file("policies/ecs-assume-role-policy.json")}"
}

/* ec2 container instance role & policy */
resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name     = "ecs_instance_role_policy"
  policy   = "${file("policies/ecs-instance-role-policy.json")}"
  role     = "${aws_iam_role.ecs_role.id}"
}





/* ecs service scheduler role */
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name     = "ecs_service_role_policy"
  policy   = "${template_file.ecs_service_role_policy.rendered}"
  role     = "${aws_iam_role.ecs_role.id}"
}


/**
 * Instance Profile for EC2 Instance launch by ASG
 */
resource "aws_iam_instance_profile" "ecs" {
  name = "ecs-instance-profile"
  path = "/"
  roles = ["${aws_iam_role.ecs_role.name}"]
}




/**
 * IAM profile to be used in auto-scaling launch configuration.
 */

resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "ecs_autoscale_role"
  assume_role_policy = "${file("policies/ecs-autoscale-assume-role-policy.json")}"
}

resource "aws_iam_role_policy" "ecs_autoscale_role_policy" {
  name     = "ecs_service_role_policy"
  policy   = "${file("policies/ecs-autoscale-role-policy.json")}"
  role     = "${aws_iam_role.ecs_autoscale_role.id}"
}






