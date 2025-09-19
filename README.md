# Vault on ECS

This repository contains Terraform scripts and Docker configurations to deploy **HashiCorp Vault** on **AWS ECS** with a secure setup.  

> **Note:** This is an example deployment. Security and performance settings should be adapted for your environment, e.g., placing Vault tasks in private subnets, enabling instance scaling, or configuring high availability.

The deployment follows AWS best practices and can serve as a starting point for both development and production environments.

## Architecture

- **VPC** with private subnets (example uses public subnets; adapt for security)
- **ECS Cluster** running Vault tasks
- **EFS** for storing Vault configuration (`vault.hcl`) and persistent data
- **DynamoDB** for Vault storage backend
- **Application Load Balancer** for access
- **Route 53** for DNS (optional)
- **AWS Certificate Manager** for TLS certificates
- **AWS KMS** for automatic seal/unseal process
