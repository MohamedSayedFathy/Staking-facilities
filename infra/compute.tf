resource "google_compute_instance" "web" {
  count = 2
  name  = "web-server-${count.index + 1}"
  machine_type = "e2-micro"
  zone = "europe-north1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.public_subnet.id
    network_ip = "80.190.10.${count.index + 5}"
    access_config {}
  }
  network_interface { 
    subnetwork = google_compute_subnetwork.private_subnet.id
    network_ip = "10.10.10.${count.index + 10}"   
  }

  metadata = {
    ssh-keys = "mohamed:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["web-server"]

  metadata_startup_script = "#!/bin/bash\napt update\napt install -y python3 python3-pip python3-venv python3-apt"
}