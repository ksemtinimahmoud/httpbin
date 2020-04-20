provider "aws" {
  region                  = "us-east-1"
  profile                 = "httpbin"
  shared_credentials_file = "$HOME/.aws/credentials"
}

# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "com.httpbin.terraform.state"
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-lock-httpbin"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}