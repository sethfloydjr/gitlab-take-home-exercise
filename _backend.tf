#For this project the statefile is kept locally.

/*
terraform {
  backend "s3" {
    #dynamodb_table = "YOUR_BUCKET-lock" If there were more than one person using this terraform stack, state locking would be implemented here.
    bucket = "YOUR_BUCKET"
    key    = "gitlab-take-home.tfstate"
    region = "us-east-1"
  }
}
*/

