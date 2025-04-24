output "certificate_arn" {
  value = aws_acm_certificate.primary.arn
}

output "domain_name" {
  value = data.aws_route53_zone.primary.name
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.primary.zone_id
}