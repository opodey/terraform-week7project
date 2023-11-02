terraform {
  backend "s3" {
    bucket         = "yaw-piesie"
    key            = "terraform-week7projcet/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}