# Output for Cloud Build Service Account Roles
output "cloudbuild_sa" {
    description = "Email of the Cloud Build service account"
    value = google_service_account.cloudbuild_sa
}

output "airflow_sa" {
    description = "Email of the Cloud Build service account"
    value = google_service_account.airflow_sa
}

output "cloudbuild_roles" {
  description = "IAM roles for Cloud Build Service Account"
  value = {
    for role, member in google_project_iam_member.cloudbuild_roles :
    role => member.id
  }
}

# Output for Airflow Service Account Roles
output "airflow_roles" {
  description = "IAM roles for Airflow Service Account"
  value = {
    for role, member in google_project_iam_member.airflow_roles :
    role => member.id
  }
}
