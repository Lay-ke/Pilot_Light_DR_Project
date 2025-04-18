variable "vpc_id" {}

variable "public_subnets" {
  type = list(object({
    cidr = string
    az   = string
    name = string
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    az   = string
    name = string
  }))
}
