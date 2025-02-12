resource "google_storage_bucket" "sebraesc-datalake-terraform" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "dataproc_env" {
  name    = "dataproc/projects/"
  bucket  = google_storage_bucket.sebraesc-datalake-terraform.name
  content = ""  # Empty content to act as a placeholder
}