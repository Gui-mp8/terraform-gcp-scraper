variable "project_id" {
  default = "suzano-challenge-teste1"
  type = string
}
variable "region" {
  default = "us-central1"
  type = string
}

# Bucket variables
variable "bucket_name_suzano" {
  default = "tf-suzano-challenge"
  type = string
}
variable "bucket_location" {
  default = "US"
  type = string
}

# Artifact Registry variables
variable "artifact_registry_repository" {
  default = "gcr-repository"
  type = string
}

# Cloud Build variables
variable "github_owner" {
  default = "Gui-mp8"
  type = string
}
variable "github_repo" {
  default = "economic_data_extraction"
  type = string
}

variable "app_name" {
  default = "economicdataextraction"
  type = string
}

variable "github_full_repo" {
  default = "https://github.com/Gui-mp8/economic_data_extraction"
  type = string
}