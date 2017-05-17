#variable "aws_access_key" {
#  description = "The AWS access key."
#}
#
#variable "aws_secret_key" {
#  description = "The AWS secret key."
#}

variable "keypair" {
  description = "The aws ssh key name."
  default = "rahul_key"
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-west-1"
}

variable "availability_zones" {
  description = "The availability zones"
  default = "us-west-1a,us-west-1c"
}

variable "registry_url"{
  description = "ECR url"
  default=""
}

variable "private_subnets"{
  default=""
}

variable "rds_username" {
  description = "RDS username."
  default = "default"
}

variable "rds_password" {
  description = "RDS password"
  default = "default"
}

variable "rds_database_name" {
  description = "RDS database name"
  default = "default"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "default"
}

variable "s3_bucket_name"{
  default = "default"
}

variable "subnets"{
}


/* ECS optimized AMIs per region */
variable "amis" {
  default = {
    ap-northeast-1 = "ami-f63f6f91"
    ap-southeast-2 = "ami-fbe9eb98"
    eu-west-1      = "ami-95f8d2f3"
    us-east-1      = "ami-275ffe31"
    us-west-1      = "ami-689bc208"
    us-west-2      = "ami-62d35c02"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "min_count" {
}

variable "max_count" {
}

