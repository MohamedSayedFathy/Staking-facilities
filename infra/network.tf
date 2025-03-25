resource "google_compute_firewall" "allow-http-ssh" {
  name = "allow-http-ssh"
  network = google_compute_network.vpc_public.id

  allow {
    protocol = "tcp"
    ports = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web-server"]
}

resource "google_compute_network" "vpc_private" {
  name = "private-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_public" {
  name = "public-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name = "public-subnet"
  ip_cidr_range = "80.190.10.0/28"
  region = "europe-north1"
  network = google_compute_network.vpc_public.id
}

resource "google_compute_subnetwork" "private_subnet" {
  name = "private-subnet"
  ip_cidr_range = "10.10.10.0/24"
  region = "europe-north1"
  network = google_compute_network.vpc_private.id
}


