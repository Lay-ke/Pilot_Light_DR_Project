variable "hosted_zone_id" {
  description = "hosted zone id"
  type = string
}

variable "domain_name" {
  description = "domain name"
  type = string
}

variable "alb_dns_name" {
  description = "alb dns name"
  type = string
}

variable "alb_zone_id" {
  description = "alb zone id"
  type = string
  default = "Z3DZXE0Q79N41H"
}

variable "environment" {
  description = "environment"
  type = string
}