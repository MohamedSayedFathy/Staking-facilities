# Staking Facilities Infrastructure

This repository contains the configuration for deploying the **Staking Facilities** project on Google Cloud Platform (GCP). The project leverages **Terraform** to provision the infrastructure and **Ansible** to configure and deploy a web service, ensuring high availability through a managed HTTP load balancer.

---

## Project Overview

The project automates the following tasks:

- **Infrastructure Provisioning with Terraform:**
  - **Custom Networking:** Creates custom VPCs and subnets to separate public and private traffic.
  - **Dual-NIC VM Instances:** Provisions virtual machines with two network interfaces:
    - **Public Interface (`eno1`)** in the `80.190.10.0/28` subnet with an external IP for public access.
    - **Private Interface (`eno2`)** in the `10.10.10.0/24` subnet for internal communication.
  - **Load Balancing:** Configures a managed HTTP load balancer to evenly distribute traffic across the VMs.

- **Configuration Management with Ansible:**
  - **Web Server Installation:** Installs and configures Nginx on each VM.
  - **Website Deployment:** Deploys a simple website that displays the hostname of the VM serving the request, useful for verifying load balancing.

---

## Design Choices

- **Cloud Provider:**  
  GCP was chosen due to its user-friendly interface, powerful ecosystem, and excellent Terraform compatibility. However, users must have a solid understanding of cloud networking concepts to utilize the resources properly.

- **Network Design:**  
  Two separate VPCs were used because each VPC in this setup only supports one subnet. One VPC handles **public traffic** (load balancer + SSH via public IP), and the other handles **private traffic** (internal communication between VMs).  
  ⚠️ Each VM supports a maximum of two network interfaces — be mindful of this limitation when designing your network.

- **Private & Public Interfaces:**  
  - The **private subnet** enables secure, internal communication between the VM instances.
  - The **public subnet** allows external access via the load balancer and SSH access through a public IP.

- **Python & Ansible:**  
  Ubuntu comes preinstalled with Python 2.7, which is outdated and incompatible with modern Ansible (requires Python 3.2+).  
  ✅ Make sure to install Python 3 and set up a virtual environment to install a compatible version of Ansible on the controller and controlled machine.

- **Load Balancer Settings:**
  - Uses **round-robin** to balance traffic across VMs.
  - Performs **HTTP health checks every 10 seconds** to verify that each instance is responsive and healthy.

---

## Directory Structure

```text
.
├── compute.tf           # Terraform configuration for VM instances
├── network.tf           # Terraform configuration for VPC, subnets, and firewall rules
├── load_balancer.tf     # Terraform configuration for the HTTP load balancer
├── outputs.tf           # Terraform outputs
├── playbook.yml         # Ansible playbook for VM configuration and website deployment
├── .gitignore           # Git ignore rules
└── README.md            # Project documentation (this file)
