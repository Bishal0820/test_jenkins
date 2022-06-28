terraform {
  backend "s3" {
    bucket         = "bishal-is-a-joke"
    key            = "state/"
    region         = "us-east-1"
    profile        = "default"
  }


}
provider "aws" {
  region                  = "us-east-1"
  profile                 = "default"
  shared_credentials_file = "~/.aws"
}
