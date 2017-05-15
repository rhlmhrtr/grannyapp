terraform {
  backend "s3" {
   bucket = "terraform-remote-state-app"
   key = "grannyapp/terraform.tfstate"
   region = "us-west-1"
 }
}