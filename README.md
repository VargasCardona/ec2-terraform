# Terraform AWS EC2 Nginx Deployment

![Repo Size](https://img.shields.io/github/repo-size/VargasCardona/ec2-terraform?style=for-the-badge)
![License](https://img.shields.io/github/license/VargasCardona/ec2-terraform?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/VargasCardona/ec2-terraform?style=for-the-badge)

This repository contains a Terraform configuration for deploying eight EC2 instances on AWS using a Debian 12 AMI. Each instance is configured with Nginx as a web server, accessible via HTTP on port 80 and SSH on port 22. The setup includes a shared security group, automated instance initialization via user data, and output of public IP addresses for verification.

## Features
- Deploys 8 t2.micro EC2 instances with 8 GB root volumes.
- Installs and starts Nginx on each instance, displaying a custom greeting on the default web page.
- Configures a security group allowing inbound traffic on ports 80 (HTTP) and 22 (SSH) from anywhere, with full outbound access.
- Uses the latest matching Debian 12 AMI from the official owner.
- Outputs the public IP addresses of all instances.

## Prerequisites
- An active AWS account with permissions to create EC2 instances, security groups, and AMIs.
- Terraform installed (version 1.0 or later).
- AWS CLI configured with access credentials (or equivalent IAM roles).
- An existing EC2 key pair for SSH access (specified via `ec2_key_name` variable).

## Configuration
Review and customize the following files:
- `main.tf`: Core infrastructure definitions (providers, data sources, resources, outputs).
- `variables.tf`: Input variable declarations (e.g., AWS region, credentials, key name).
- `terraform.tfvars.example`: Template for variable values (copy to `terraform.tfvars` and populate with your details).

Sensitive values such as `aws_access_key` and `aws_secret_key` should be provided via `terraform.tfvars` (excluded from version control) or AWS environment variables/CLI profiles for security.

## Usage
1. **Clone the Repository**:
  ```bash
  terraform init
  ```
  This downloads the AWS provider and creates a lock file.

2. **Plan the Deployment**:
  ```bash
  terraform plan
  ```
Review the proposed changes.

4. **Apply the Configuration**:
 ```bash
  terraform apply
  ```

5. Confirm with `yes` to provision the resources. This will create 8 EC2 instances.

6. **Access the Instances**:
- View public IPs via the output (displayed after apply or run `terraform output instance_public_ips`).
- Visit `http://<public-ip>` in a browser to see the Nginx greeting.
- SSH into an instance: `ssh -i <your-key.pem> debian@<public-ip>`.

## Outputs
- `instance_public_ips`: List of public IP addresses for the 8 EC2 instances.

Example:
 ```bash
instance_public_ips = [
"3.123.45.67",
"3.123.45.68",
...
]
  ```
## Cleanup
To avoid incurring costs, destroy all resources:
 ```bash
  terraform destroy
  ```

Confirm with `yes`.

## Security Notes
- The security group allows inbound traffic from `0.0.0.0/0` (anywhere). Restrict CIDR blocks in production (e.g., to your IP).
- Avoid committing sensitive data; use IAM roles or encrypted variables where possible.
- Monitor and rotate AWS credentials regularly.

---

*Project maintained with Terraform ~> 1.5. Last updated: October 04, 2025.*
