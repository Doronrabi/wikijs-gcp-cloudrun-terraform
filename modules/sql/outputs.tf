output "instance_connection_name" {
  value = google_sql_database_instance.postgres.connection_name
}

output "private_ip_address" {
  value = google_sql_database_instance.postgres.private_ip_address
}

output "db_name" {
  value = var.db_name
}

output "db_user" {
  value = var.db_user
}

output "db_password_secret_name" {
  value = google_secret_manager_secret.db_password.secret_id
}

output "db_password_secret_id" {
  value = google_secret_manager_secret.db_password.id
}
