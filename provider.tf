provider "aws" {
  region                  = "us-east-1"
  profile                 = "httpbin"
  shared_credentials_file = "$HOME/.aws/credentials"
}