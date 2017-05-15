/**
 * Provides internal access to container ports
 */
resource "aws_security_group" "granny_ecs" {
  name = "granny_ecs_sg"
  description = "Allows all traffic"

  ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags {
    Name = "ecs_granny_sg"
  }
}


resource "aws_security_group" "granny_ecs_elb" {
  name = "granny_ecs_elb"
  description = "Container Instance Allowed Ports"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "granny_ecs_elb"
  }
}