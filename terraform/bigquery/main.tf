resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "economic_data"
  friendly_name               = "suzano"
  description                 = "Dataset for Suzano challenge"
  location                    = var.region
  default_table_expiration_ms = 3600000
  delete_contents_on_destroy  = true

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = var.service_account
  }

  access {
    role   = "READER"
    domain = "hashicorp.com"
  }
}