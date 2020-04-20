terraform {
  required_version = ">= 0.12.0"

  backend "s3" {
    bucket         = "com.httpbin.terraform.state"
    dynamodb_table = "terraform-lock-httpbin"
    key            = "httpbin/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    profile        = "httpbin"
  }
}
