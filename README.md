# Staking Facilities Infrastructure

This repository contains the configuration for deploying the **Staking Facilities** project on Google Cloud Platform (GCP). It uses **Terraform** to provision infrastructure and **Ansible** to configure and deploy a web service, ensuring high availability through a managed HTTP load balancer.

---

## Project Overview

The project automates:

### Infrastructure Provisioning with Terraform
- **Custom Networking:** Creates custom VPCs and subnets separating public and private traffic.
- **Dual-NIC VM Instances:**
  - **Public Interface (eno1):** 80.190.10.0/28 subnet, external IP.
  - **Private Interface (eno2):** 10.10.10.0/24 subnet, internal communication.
- **Load Balancing:** Managed HTTP load balancer distributing traffic.

### Configuration Management with Ansible
- **Web Server Installation:** Installs/configures Nginx.
- **Website Deployment:** Simple website displaying VM hostname.

Access working website: **http://34.54.22.138/**

Verify load balancing with:
```bash
curl -v http://34.54.22.138/
```

---

## Design Choices

- **Cloud Provider:** GCP, due to user-friendly interface and Terraform compatibility.
- **Network Design:**
  - Two separate VPCs (public and private).
  - Each VM supports two network interfaces.
- **Interfaces:**
  - **Private subnet:** Internal VM communication.
  - **Public subnet:** External access and SSH.
- **Python & Ansible:**
  - Use Python 3.x and virtual environment for Ansible.
  - Update `hosts.ini` with VM IP addresses after Terraform provisioning.
- **Load Balancer:**
  - Round-robin load balancing.
  - HTTP health checks every 10 seconds.

---

## Directory Structure
```
.
├── compute.tf           # Terraform config for VMs
├── network.tf           # Terraform config for VPC/subnets/firewall
├── load_balancer.tf     # Terraform config for load balancer
├── outputs.tf           # Terraform outputs
├── playbook.yml         # Ansible playbook
├── .gitignore           # Git ignore rules
└── README.md            # Documentation
```

---

## Commands

### Step 1: Initialize Terraform
```bash
terraform init
```

### Step 2: Preview Terraform changes
```bash
terraform plan
```

### Step 3: Apply Terraform configuration
```bash
terraform apply
```

### Setup Python Virtual Environment
```bash
python3 -m venv ~/ansible-venv
source ~/ansible-venv/bin/activate
pip install ansible
```

### Run Ansible Playbook
Replace `<your-username>` with your SSH username:
```bash
ansible-playbook -i hosts.ini playbook.yml -u <your-username>
```

