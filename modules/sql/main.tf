# Creating database instance for DB
resource "google_sql_database_instance" "postgres" {
  name             = "wiki-${var.environment}-sql"
  database_version = var.db_kind
  region           = var.region
  project          = var.project_id
  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
  project  = var.project_id
}
# creating user for database
resource "google_sql_user" "user" {
  name     = var.db_user
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
  project  = var.project_id
}

# creating a secret entry in secret manager
resource "google_secret_manager_secret" "db_password" {
  secret_id = "wiki-${var.environment}-db-password"
  project   = var.project_id

  replication {
    auto {}
  }
}

# applying given password to the secret entry
resource "google_secret_manager_secret_version" "db_password_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}
