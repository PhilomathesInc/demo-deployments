terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.76.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }

  required_version = "~> 0.13"
}
