terraform {
  backend "s3" {
    bucket         = "bishal-is-a-joke"
    key            = ""
    region         = "us-east-1"
  }


}
provider "aws" {
  region                  = "us-east-1"
  access_key = "AccessKeyId"
  secret_key = "SecretKeyId"
}
