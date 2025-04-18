output "vpc_id" {
  value = aws_vpc.this.id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID of the public route table"
}

