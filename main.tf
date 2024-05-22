terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.29.1"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_image" "this" {
  name = "nested-ubuntu-jammy"

  source_image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20240515"
  licenses = [
    "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/licenses/ubuntu-2204-lts",
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
  ]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "9.1.0"

  project_id   = var.project
  network_name = "${var.name}-vpc"

  subnets = [
    {
      subnet_name   = "${var.name}-${var.region}-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    }
  ]

}

resource "google_compute_firewall" "allow-in" {
  name    = "${var.name}-all-in"
  network = module.vpc.network_id

  allow {
    protocol = "all"
  }

  priority  = 1000
  direction = "INGRESS"

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-out" {
  name    = "${var.name}-all-out"
  network = module.vpc.network_id

  allow {
    protocol = "all"
  }

  priority  = 1000
  direction = "EGRESS"

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "this" {
  name         = "${var.name}-instance"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      size  = var.disk_size
      type  = "pd-balanced"
      image = google_compute_image.this.self_link
    }
  }

  network_interface {
    subnetwork         = module.vpc.subnets_names[0]
    subnetwork_project = var.project

    access_config {

    }
  }

  depends_on = [google_compute_image.this]
}

output "ip" {
  value = google_compute_instance.this.network_interface[0].access_config[0].nat_ip
}

output "instance_name" {
  value = google_compute_instance.this.name
}