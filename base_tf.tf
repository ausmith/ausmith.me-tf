data "terraform_remote_state" "base" {
  backend = "s3"

  config {
    bucket = "ausmith-tf-state"
    key    = "ausmith-base-state-prod"
    region = "us-east-1"
  }
}
