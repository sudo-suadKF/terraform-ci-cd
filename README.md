# Terraform CI/CD Pipeline on AWS (Learning Project)

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-CI%2FCD-2088FF?logo=githubactions)
![Status](https://img.shields.io/badge/Status-Learning%20Project-blue)

## Overview

This project is a **small, focused CI/CD learning setup** that demonstrates how to use **GitHub Actions to manage Terraform deployments on AWS**.

The goal was not to build a large production system, but to **understand how CI/CD pipelines work in practice**: validating infrastructure code, planning changes, applying them, and safely tearing everything down using automated workflows instead of running Terraform locally.

---

## What this project sets up

The Terraform configuration provisions a minimal but realistic AWS environment:

- A **custom VPC**
- A **public subnet** with internet access
- An **EC2 instance** running NGINX
- Security groups allowing HTTP, HTTPS, and SSH
- Terraform **remote state stored in S3**

The EC2 instance installs and starts NGINX automatically and serves a simple page showing the instance hostname.

---

## CI/CD pipeline design (key learning focus)

This is the most important part of the project.

### Separate GitHub Actions workflows

The pipeline is intentionally split into **three workflows**, each with a clear responsibility:

- **Validate & Plan**
  - Runs `terraform init`, `validate`, and `plan`
  - Used to review changes safely before applying
- **Apply**
  - Runs `terraform apply --auto-approve`
  - Manually triggered to deploy infrastructure
- **Destroy**
  - Runs `terraform destroy --auto-approve`
  - Makes cleanup fast and repeatable

This separation mirrors how real teams reduce risk and control changes.

---

### Secure AWS authentication

- GitHub Actions authenticates to AWS using **repository secrets**
- No credentials are stored in the codebase
- The AWS region is set via environment variables

This keeps the pipeline secure while remaining easy to understand.

---

### Terraform remote state

Terraform state is stored in an **S3 backend** with encryption enabled.

Why this matters:
- Prevents state loss
- Enables safe automation
- Matches real-world Terraform usage instead of local state files

---

## Architecture and design choices that matter

- **Infrastructure as Code**  
  Everything is defined declaratively in Terraform, making the setup repeatable and predictable.

- **Automated lifecycle**  
  Infrastructure can be created, validated, and destroyed entirely from GitHub Actions.

- **Manual triggers (`workflow_dispatch`)**  
  This avoids accidental deployments and keeps control explicit — a common pattern in early-stage or learning environments.

- **Minimal AWS footprint**  
  A single EC2 instance and VPC keeps costs low while still teaching core concepts.

---

## Screenshots

<img src="/images/terraform_apply.png"></img>
<img src="/images/ci-cd_nginx.png"></img>

---

## How to use (high level)

1. Store AWS credentials as GitHub repository secrets
2. Push the Terraform code to the repository
3. Manually trigger:
   - **Validate & Plan** to review changes
   - **Apply** to deploy infrastructure
   - **Destroy** to clean up resources

No local Terraform execution is required.

---

## Final notes

This project is intentionally small. Its value is in showing **clear understanding of CI/CD pipelines, Terraform workflows, and safe infrastructure automation**, rather than scale or complexity.

It reflects how these tools are actually used in practice.
