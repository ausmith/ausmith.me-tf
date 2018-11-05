data "aws_route53_zone" "ausmith_me" {
  name = "ausmith.me."
}

resource "aws_route53_record" "domain" {
  zone_id = "${data.aws_route53_zone.ausmith_me.zone_id}"
  name    = "${data.aws_route53_zone.ausmith_me.name}"
  type    = "A"
  ttl     = "300"

  records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]
}
