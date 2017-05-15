resource "aws_rds_cluster" "granny_app_aurora" {
  cluster_identifier      = "grannyapp-aurora"
  database_name           = "grannydb"
  master_username         = "demo"
  master_password         = "demodemo"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  #final_snapshot_identifier = "some_snap"
}

resource "aws_rds_cluster_instance" "granny_app_aurora" {
    count = 1
    identifier = "grannyapp-${count.index}"
    cluster_identifier = "${aws_rds_cluster.granny_app_aurora.id}"
    instance_class = "db.t2.small"
    db_subnet_group_name = "default"
    publicly_accessible = false
}

resource "aws_db_subnet_group" "private_db_subnet" {
  name       = "granny_aurora_subnet"
  subnet_ids = ["${split(",", var.private_subnets)}"]

  tags {
    Name = "Granny App Subnet Group"
  }
}

#provider "mysql" {
#  endpoint = "${aws_rds_cluster.granny_app_aurora.endpoint}"
##  username = "${aws_rds_cluster.granny_app_aurora.username}"
##  password = "${aws_rds_cluster.granny_app_aurora.password}"
#}
#
#resource "mysql_database" "granny_app" {
#  name = "web_transfer"
#}