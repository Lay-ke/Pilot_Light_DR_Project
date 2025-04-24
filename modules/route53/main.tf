locals {
  env = var.environment == "prod" ? true : false
}

resource "aws_route53_health_check" "primary_region_health_check" {
  count = local.env ? 1 : 0
  fqdn              = var.domain_name
  port              = 443
  type              = "HTTPS"
  resource_path     = "/crud_app/health.php"
  failure_threshold = "10"
  request_interval  = "30"

  tags = {
    Name = "Active_Region_health_check"
  }
}


resource "aws_route53_record" "www_active" {
  count = local.env ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "PRIMARY"
  }
  health_check_id = aws_route53_health_check.primary_region_health_check[0].id
  set_identifier = "pilot_active"
  allow_overwrite = true

}


resource "aws_route53_record" "failover_active" {
  count = local.env ? 0 : 1
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "pilot_failover"
  allow_overwrite = true
}