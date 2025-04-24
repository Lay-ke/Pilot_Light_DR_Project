variable "name" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "sg_id" {}
variable "certificate_arn" {
  description = "The ARN of the ACM certificate to use for HTTPS listener"
  type        = string
  
}