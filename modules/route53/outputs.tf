output "health_check_id" {
  description = "The ID of the Route53 Health Check"
  value       = length(aws_route53_health_check.primary_region_health_check) > 0 ? aws_route53_health_check.primary_region_health_check[0].id : null
}