resource "random_bytes" "secrets-suffix" {
  length = 4
}
# Secrets Manager secret for RDS endpoint
resource "aws_secretsmanager_secret" "rds_endpoint" {
  name        = "RDSInstance-${random_bytes.secrets-suffix.hex}"
  description = "RDS instance endpoint"
}

resource "aws_secretsmanager_secret_version" "rds_endpoint_version" {
  secret_id = aws_secretsmanager_secret.rds_endpoint.id
  secret_string = jsonencode({
    RDSEndpoint = var.db_instance_endpoint,
    DBName      = var.db_name,
    DBUsername  = var.db_username,
    DBPassword  = var.db_password
  })
}