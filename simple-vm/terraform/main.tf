variable "project_id" {
  description = "GCP project ID"
}

variable "region" {
  description = "GCP region"
}

variable "zone" {
  description = "GCP zone"
}

variable "gce_ssh_user" {
  default     = "demo"
  description = "User to create on the GCE instance"
}

variable "ssh_pub_key_file" {
  default     = "id_ed25519.pub"
  description = "Path to SSH public key"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "default" {
  name         = "demo"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    // Google will create the user specified in the ssh-keys.
    ssh-keys = "${var.gce_ssh_user}:${file(var.ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      network_tier = "STANDARD"
    }
  }
}
