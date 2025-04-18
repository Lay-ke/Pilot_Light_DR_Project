output "launch_template_id" {
  description = "The ID of the EC2 Launch Template"
  value       = aws_launch_template.this.id
}
