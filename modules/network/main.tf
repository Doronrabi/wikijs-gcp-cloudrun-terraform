# creates a vpc
resource "google_compute_network" "vpc" {
  name                    = "wiki-${var.environment}-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id

}

# creates a subnet under vpc
resource "google_compute_subnetwork" "private_subnet" {
  name          = "wiki-${var.environment}-subnet"
  ip_cidr_range = var.vpc_range
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

# reserve ip range for private service access
resource "google_compute_global_address" "private_ip_range" {
  name          = "wiki-${var.environment}-private-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.private_service_prefix_length
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

# create private service networking connection - for cloud SQL
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  deletion_policy         = "ABANDON"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]

}

# Create Serverless VPC Connector - for cloud run to access VPC
resource "google_vpc_access_connector" "connector" {
  name          = "wiki-${var.environment}-connector"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.connector_range
  machine_type  = "e2-micro"
  min_instances = 2
  max_instances = 3
}
