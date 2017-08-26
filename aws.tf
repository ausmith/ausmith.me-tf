provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"

  # If going to other region, parameterize here
  region = "us-east-1"

  version = "~> 0.1"
}

provider "template" {
  version = "~> 0.1"
}

provider "terraform" {
  version = "~> 0.1"
}
