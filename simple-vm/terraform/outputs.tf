output "instance_public_ip" {
  value       = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  description = "Google Compute Engine instance Public IP"
}

output "ssh_connection_string" {
  value       = "ssh ${var.gce_ssh_user}@${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
  description = "SSH connection string for the instance."
}
