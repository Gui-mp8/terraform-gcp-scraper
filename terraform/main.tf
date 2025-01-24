provider "google" {
  credentials = file("./credentials/suzano-challenge.json")
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = file("./credentials/suzano-challenge.json")
  project     = var.project_id
  region      = var.region
}

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "17.0.0"
  disable_services_on_destroy = false

  project_id  = var.project_id
  enable_apis = true

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "servicemanagement.googleapis.com",
    "compute.googleapis.com",
    "bigquery.googleapis.com"
  ]
}

# Random ID for the bucket name
resource "random_id" "bucket_id" {
  byte_length = 4
}

# Create the buckets
# module "cloudstorage" {
#   source = "./cloud_storage"
#   bucket_name = var.bucket_name_suzano
#   location = var.bucket_location
# }

module "iam" {
  source = "./iam"

  project_id = var.project_id
}

# module "artifact_registry" {
#   source = "./artifact_registry"
#   region = var.region
#   repository_id = var.artifact_registry_repository
# }

# module "cloud_build" {
#   source = "./cloud_build"
#   github_owner = var.github_owner
#   app_name = var.app_name
#   github_repo = var.github_repo
#   project_id = var.project_id
#   region = var.region
#   service_account = google_service_account.cloudbuild_service_account.id
#   artifact_registry_repository = var.artifact_registry_repository
#   depends_on = [
#     module.iam,
#     module.artifact_registry
#   ]
# }

# module "bigquery" {
#   source = "./bigquery"
#   service_account = google_service_account.cloudbuild_sa.email
#   region = var.region
#   depends_on = [ google_service_account.cloudbuild_sa ]
# }
module "compute_engine" {
  source = "./compute_engine"
  github_full_repo = var.github_full_repo
  project = var.project_id
  # account = google_service_account.airflow_sa.email
  account = module.iam.airflow_sa.email
  depends_on = [ module.project-services, module.iam ]
  #depends_on = [ module.cloud_build, module.artifact_registry, module.cloudstorage ]
}
