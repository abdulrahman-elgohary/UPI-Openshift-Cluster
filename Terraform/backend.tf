terraform {
  backend "s3" {
    bucket = "statefull-terraform-bucket-12-20-2024"
    key    = "terraform-file-state.tfstate"
    region = "us-east-1"
    dynamodb_table = "Lock_users"
  }
}