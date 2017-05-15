#!/bin/bash
echo ECS_CLUSTER=granny_app > /etc/ecs/ecs.config
echo ECS_LOGLEVEL=debug >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS='["awslogs","fluentd"]' >> /etc/ecs/ecs.config