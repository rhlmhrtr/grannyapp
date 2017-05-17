#!/bin/bash
yum update -y
yum install -y awslogs
chkconfig awslogs on

echo ECS_CLUSTER=granny_app > /etc/ecs/ecs.config
echo ECS_LOGLEVEL=debug >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS='["awslogs"]' >> /etc/ecs/ecs.config