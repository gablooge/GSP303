# Code inside bastionhost/main.tf
variable "instance_name" {
  }
variable "instance_zone" {
  default = "us-central1-a"
  }
variable "instance_type" {
  default = "n1-standard-1"
  }
variable "instance_subnetwork" {
}
variable "instance_tags" {
  }

resource "google_compute_instance" "vm_instance" {
  name         = "${var.instance_name}"
  zone         = "${var.instance_zone}"
  machine_type = "${var.instance_type}"
  tags = ["${var.instance_tags}"]
  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2016"
    }
  }
  network_interface {
    subnetwork = "${var.instance_subnetwork}"
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
  network_interface {
    subnetwork = "default"
  }
}
