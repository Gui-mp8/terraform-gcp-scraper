# Roles for the Cloud Build Service Account
variable "cloudbuild_roles" {
  description = "Roles to assign to the Cloud Build service account"
  type        = list(string)
  default = [
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/artifactregistry.admin",
    "roles/run.admin",
    "roles/storage.objectAdmin",
    "roles/bigquery.admin"
  ]
}

# Roles for the Airflow Service Account
variable "airflow_roles" {
  description = "Roles to assign to the Airflow service account"
  type        = list(string)
  default = [
    "roles/bigquery.admin",
    "roles/storage.objectAdmin"
  ]
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

# variable "cloudbuild_service_account_email" {
#   description = "Email of the Cloud Build service account"
#   type        = string
# }

# variable "airflow_sa_email" {
#   description = "Email of the Airflow service account"
#   type        = string
# }
