# Request ACM Certificate
resource "aws_acm_certificate" "primary" {
  domain_name              = "active.mintah.site"
  # subject_alternative_names = ["www.hola.site"]
  validation_method        = "DNS"

  tags = {
    Name = "active-dr-cert-${var.environment}"
  }
}

# Get Route 53 Hosted Zone
data "aws_route53_zone" "primary" {
  name         = "mintah.site"
  private_zone = false
}

# Create DNS Validation Records
resource "aws_route53_record" "primary" {
  for_each = {
    for dvo in aws_acm_certificate.primary.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

# Validate ACM Certificate
resource "aws_acm_certificate_validation" "primary" {
  certificate_arn         = aws_acm_certificate.primary.arn
  validation_record_fqdns = [for record in aws_route53_record.primary : record.fqdn]
}