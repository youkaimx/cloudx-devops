variable "domain" {
  type = string
  description = "The DNS Domain we're setting up"
  default = "youkai.mx"
}

resource "aws_route53_zone" "zone" {
  name = "${var.domain}"
}

resource "aws_route53_record" "domain" {
  zone_id = aws_route53_zone.zone.id
  name = "${var.domain}"
  type = "A"
  alias {
    name = aws_s3_bucket.domain.website_domain
    zone_id = aws_s3_bucket.domain.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.id
  name = "www.${var.domain}"
  type = "A"
  alias {
    name = aws_s3_bucket.www.website_domain
    zone_id = aws_s3_bucket.www.hosted_zone_id
    evaluate_target_health = false
  }
}

output "name-servers" {
  value = aws_route53_zone.zone.name_servers
}