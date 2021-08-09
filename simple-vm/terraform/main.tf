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
  description = "User to create on the GCE instance"
}

variable "ssh_private_key_file" {
  description = "Path to SSH private key"
}

variable "ssh_public_key_file" {
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

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    // Google will create the user specified in the ssh-keys.
    ssh-keys = "${var.gce_ssh_user}:${file(var.ssh_public_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      network_tier = "STANDARD"
    }
  }
}

// Unable to use Cloudflare resource for .cf, .ga, .gq, .ml, or .tk TLD
data "cloudflare_zones" "mriyam" {
  filter {
    name = "mriyam.com"
  }
}

resource "cloudflare_record" "demo" {
  zone_id = lookup(data.cloudflare_zones.mriyam.zones[0], "id")

  name  = "demo"
  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
  type  = "A"
  ttl   = 300
}

resource "null_resource" "provision_with_ansible" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = google_compute_instance.default.id
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --user '${var.gce_ssh_user}' --inventory '${google_compute_instance.default.network_interface.0.access_config.0.nat_ip},' --private-key ${var.ssh_private_key_file} ../ansible/web-app-playbook.yml --extra-vars \"domain=demo.mriyam.com\""
  }
}
