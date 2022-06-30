terraform {
  backend "s3" {
    bucket         = "bishal-is-a-joke"
    key            = "state/"
    profile = "default"
    region         = "us-east-1"
  }

}
provider "aws" {
  region     = "us-east-1"
  profile = "default"
  access_key = "AccessKeyId"
  secret_key = "SecretKeyId"
}
