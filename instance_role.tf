data "aws_iam_policy_document" "move_eip_policy" {
  statement {
    actions = [
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:DisassociateAddress",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "ausmith_me" {
  name   = "move_eip_policy"
  role   = "${aws_iam_role.ausmith_me.id}"
  policy = "${data.aws_iam_policy_document.move_eip_policy.json}"
}

resource "aws_iam_role" "ausmith_me" {
  name = "ausmith_me"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ausmith_me" {
  name = "ausmith_me"
  role = "${aws_iam_role.ausmith_me.name}"
}
