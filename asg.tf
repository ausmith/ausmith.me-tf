data "aws_ami" "simplenodejs" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "simplenodejs_ami_1503366206",
    ]
  }
}

data "template_file" "simplenodejs_user_data" {
  template = "${file("templates/simplenodejs_user_data.tpl")}"

  vars {
    eip = "${aws_eip.ausmith_me.public_ip}"
  }
}

resource "aws_launch_configuration" "ausmith_me_config" {
  name_prefix                 = "simplenodejs_"
  image_id                    = "${data.aws_ami.simplenodejs.id}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.simplenodejs_user_data.rendered}"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.ausmith_me.id}"

  security_groups = [
    "${data.terraform_remote_state.base.sg_basic_server_needs}",
    "${data.terraform_remote_state.base.sg_simple_web_server}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ausmith_me_asg" {
  name                 = "ausmith_me_asg"
  max_size             = 1
  min_size             = 1
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.ausmith_me_config.name}"

  termination_policies = [
    "OldestInstance",
  ]

  vpc_zone_identifier = [
    "${data.terraform_remote_state.base.subnet_public_list}",
  ]

  tag {
    key                 = "asg"
    value               = "ausmith_me_asg"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Name"
    value               = "ausmith.me"
    propagate_at_launch = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}
