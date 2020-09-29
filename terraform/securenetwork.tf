# Create the securenetwork network
resource "google_compute_network" "securenetwork" {
  name                    = "securenetwork"
  auto_create_subnetworks = "false"
}

# Add a subnet to securenetwork
# Add subnet to the VPC network.

# Create subnet subnetwork
resource "google_compute_subnetwork" "securenetwork" {
  name          = "securenetwork"
  region        = "us-central1"
  network       = "${google_compute_network.securenetwork.self_link}"
  ip_cidr_range = "10.130.0.0/20"
}

# Configure the firewall rule
# Define a firewall rule to allow HTTP, SSH, and RDP traffic on securenetwork.

resource "google_compute_firewall" "bastionbost-allow-rdp" {
  name        = "bastionbost-allow-rdp"
  network     = "${google_compute_network.securenetwork.self_link}"
  target_tags = ["bastion"]
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

resource "google_compute_firewall" "securenetwork-allow-rdp" {
  name          = "securenetwork-allow-rdp"
  network       = "${google_compute_network.securenetwork.self_link}"
  source_ranges = ["10.130.0.0/20"]
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

# Create the vm-securehost instance
module "vm-securehost" {
  source              = "./securehost"
  instance_name       = "vm-securehost"
  instance_zone       = "us-central1-a"
  instance_tags       = "secure"
  instance_subnetwork = "${google_compute_subnetwork.securenetwork.self_link}"
}

# Create the vm-bastionhost instance
module "vm-bastionhost" {
  source              = "./bastionhost"
  instance_name       = "vm-bastionhost"
  instance_zone       = "us-central1-a"
  instance_tags       = "bastion"
  instance_subnetwork = "${google_compute_subnetwork.securenetwork.self_link}"
}
