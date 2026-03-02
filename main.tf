# Enables required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "secretmanager.googleapis.com",
    "run.googleapis.com",
  ])

  project = var.project_id
  service = each.key

  disable_on_destroy = false
}


# Sets up network (vpc + subnet) for the selected project
module "network" {
  source = "./modules/network"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
}

# Creates a PostgreSQL database to support wiki.js
module "sql" {
  source = "./modules/sql"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment
  vpc_id      = module.network.vpc_id
  db_kind     = var.db_kind
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password

  depends_on = [module.network]
}

# creates service account that has access to the sql password
module "iam" {
  source = "./modules/iam"

  project_id  = var.project_id
  environment = var.environment
  secret_id   = module.sql.db_password_secret_id
}
# Deploys wiki.js to cloud run and configures it
module "wikijs" {
  source = "./modules/wikijs"

  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  service_account_email = module.iam.service_account_email
  vpc_connector_id      = module.network.vpc_connector_id

  db_host                 = module.sql.private_ip_address
  db_name                 = module.sql.db_name
  db_user                 = module.sql.db_user
  db_password_secret_name = module.sql.db_password_secret_name
  image                   = var.image
  allow_public_access     = var.allow_public_access_cloud_run

  depends_on = [
    module.network,
    module.sql,
    module.iam
  ]
}

module "monitoring" {
  source      = "./modules/monitoring"
  project_id  = var.project_id
  service_url = module.wikijs.service_url
}
