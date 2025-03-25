output "vm_public_ips" {
  description = "Public IP addresses of web server VMs"
  value = google_compute_instance.web[*].network_interface[0].access_config[0].nat_ip
}
output "eno1_ip" {
  description = "The IP addresses assigned to the first network interface (eno1)."
  value = google_compute_instance.web[*].network_interface[0].network_ip
}

output "eno2_ip" {
  description = "The IP addresses assigned to the second network interface (eno2)."
  value = google_compute_instance.web[*].network_interface[1].network_ip
}

output "load_balancer_ip" {
  description = "The static external IP address reserved for the load balancer."
  value       = google_compute_global_address.lb_static_ip.address
}