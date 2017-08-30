data "aws_route53_zone" "ausmith_me" {
  name = "ausmith.me."
}

resource "aws_eip" "ausmith_me" {
  vpc = true
}

resource "aws_route53_record" "domain" {
  zone_id = "${data.aws_route53_zone.ausmith_me.zone_id}"
  name    = "${var.env_name == "test" ? "test." : ""}${data.aws_route53_zone.ausmith_me.name}"
  type    = "A"
  ttl     = "300"

  records = [
    "${aws_eip.ausmith_me.public_ip}",
  ]
}
