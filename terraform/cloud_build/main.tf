resource "google_cloudbuild_trigger" "build-trigger" {
    name = "cloud-run-terraform-deploy"
    location = "global"
    service_account = var.service_account
    github {
        owner = var.github_owner
        name = var.github_repo
        push {
          branch = "main"
        }
    }

    included_files = ["api/**"]

    build {

        options {
          logging = "CLOUD_LOGGING_ONLY"
        }

        step {
            name = "gcr.io/cloud-builders/docker"
            args = ["build", "-f", "api.Dockerfile", "-t", "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository}/${var.app_name}:$COMMIT_SHA", "."]
        }

        step {
            name   = "gcr.io/cloud-builders/docker"
            args = ["push", "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository}/${var.app_name}:$COMMIT_SHA"]
        }

        step {
            name = "gcr.io/google.com/cloudsdktool/cloud-sdk"
            entrypoint = "gcloud"
            args = [
                "run",
                "deploy",
                var.app_name,
                "--image", "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository}/${var.app_name}:$COMMIT_SHA",
                "--region", var.region,
                "--platform", "managed",
                "--allow-unauthenticated",
                "--memory", "1Gi",
                "--service-account", "cloudbuild-sa@suzano-challenge-teste1.iam.gserviceaccount.com"
            ]
        }
        images = ["${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_registry_repository}/${var.app_name}:$COMMIT_SHA"]

    }
}