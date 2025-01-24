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
module "cloudstorage" {
  source = "./cloud_storage"
  bucket_name = var.bucket_name_suzano
  location = var.bucket_location
}

# Cloud Build Service Account
resource "google_service_account" "cloudbuild_service_account" {
  account_id   = "cloudbuild-sa"
  display_name = "cloudbuild-sa"
  description  = "Cloud build service account"
}

resource "google_project_iam_member" "act_as" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "artifactregistry_admin" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "cloudrun_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

resource "google_project_iam_member" "bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"
}

module "artifact_registry" {
  source = "./artifact_registry"
  region = var.region
  repository_id = var.artifact_registry_repository
}

module "cloud_build" {
  source = "./cloud_build"
  github_owner = var.github_owner
  app_name = var.app_name
  github_repo = var.github_repo
  project_id = var.project_id
  region = var.region
  service_account = google_service_account.cloudbuild_service_account.id
  artifact_registry_repository = var.artifact_registry_repository
  depends_on = [ google_project_iam_member.act_as,
    google_project_iam_member.logs_writer,
    google_project_iam_member.artifactregistry_admin,
    google_project_iam_member.cloudrun_admin,
    google_service_account.cloudbuild_service_account,
    google_project_iam_member.bigquery_admin,
    module.artifact_registry
  ]
}

resource "google_service_account" "airflow_sa" {
  account_id   = "airflow"
  display_name = "Airflow Service Account"
}

resource "google_project_iam_member" "airflow_sa_bigquery" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"
}

resource "google_project_iam_member" "airflow_sa_storage" {
  project =  var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"
}

module "bigquery" {
  source = "./bigquery"
  service_account = google_service_account.cloudbuild_service_account.email
  region = var.region
  depends_on = [ google_service_account.cloudbuild_service_account ]
}
module "compute_engine" {
  source = "./compute_engine"
  github_full_repo = var.github_full_repo
  project = var.project_id
  account = google_service_account.airflow_sa.email
  depends_on = [ module.project-services, google_service_account.airflow_sa ]
  #depends_on = [ module.cloud_build, module.artifact_registry, module.cloudstorage ]
}
