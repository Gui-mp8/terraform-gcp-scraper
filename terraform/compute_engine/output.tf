output "ip_externo" {
  value = google_compute_instance.airflow.network_interface.0.access_config.0.nat_ip
}