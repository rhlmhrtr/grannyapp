resource "aws_elb" "granny_ecs" {
    name = "granny-ecs-elb"
    security_groups = ["${aws_security_group.granny_ecs_elb.id}"]
    availability_zones   = ["${split(",", var.availability_zones)}"]

    listener {
        lb_protocol = "http"
        lb_port = 80

        instance_protocol = "http"
        instance_port = 8080
    }

    health_check {
        healthy_threshold = 3
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:8080/"
        interval = 5
    }

    cross_zone_load_balancing = true
}


resource "template_file" "task_definition" {
  template = "${file("${path.module}/task-definitions/granny_app.json")}"

  vars {
    registry_url = "${aws_ecr_repository.granny_app.repository_url}"
  }
}

resource "aws_ecs_cluster" "granny_ecs" {
  name = "granny_app"
}


resource "aws_ecs_task_definition" "granny_app" {
    family = "granny_app"
    container_definitions = "${template_file.task_definition.rendered}"
}

resource "aws_ecs_service" "granny_app" {
    name = "granny_app"
    cluster = "${aws_ecs_cluster.granny_ecs.id}"
    task_definition = "${aws_ecs_task_definition.granny_app.arn}"
    iam_role = "${aws_iam_role.ecs_role.arn}"
    desired_count = 2
    depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

    load_balancer {
        elb_name = "${aws_elb.granny_ecs.id}"
        container_name = "granny_app"
        container_port = 8080
    }
}