# Terraform EKS Cluster Setup

This repository contains Terraform code to set up an Amazon Elastic Kubernetes Service (EKS) cluster with a managed node group. The setup includes creating networking resources such as VPC, subnets, route tables, security groups, and a NAT Gateway for private subnets. It also handles IAM roles and encryption keys needed for the EKS cluster and nodes.

## Table of Contents

- [Terraform EKS Cluster Setup](#terraform-eks-cluster-setup)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [Components](#components)
  - [Usage](#usage)
  - [Troubleshooting](#troubleshooting)
  - [Resources](#resources)
  - [Contributing](#contributing)

## Overview

This Terraform module provisions an Amazon EKS cluster along with the necessary networking components and IAM roles. It creates a managed node group and sets up the environment with:

- VPC and Subnets
- Internet Gateway and NAT Gateway
- Route Tables
- Security Groups
- EKS Cluster
- Managed Node Group
- KMS keys
- IAM Roles and Policies

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0 or later)
- AWS CLI configured with sufficient permissions
- An AWS account with access to create the necessary resources


## Components

- **VPC and Subnets**: Defines the networking layout of your cluster.
- **Route Tables and NAT Gateway**: Handles routing for public and private subnets.
- **Security Groups**: Controls inbound and outbound traffic to the cluster and nodes.
- **IAM Roles and Policies**: Manages permissions for EKS and EC2 instances.
- **EKS Cluster and Node Group**: Sets up the Kubernetes control plane and worker nodes.

## Usage

1. **Clone the Repository**
   ```bash
   git clone https://github.com/csye7125-su24-team17/infra-aws.git
   cd infra-aws

2. **Create a terraform.tfvars file to match your environment settings**

3. **Initialize Terraform**
   ```bash
   terraform init

4. **Check the plan before deployment**
   ```bash
   terraform plan

5. **Deploy the Infrastructure**
   ```bash
   terraform apply

6. **Cleanup**
   ```bash
   terraform destroy

## Troubleshooting

1. **Node Group Creation Failure:** Ensure the subnets used by the node group have internet access if they need to pull images from the internet. Private subnets need a NAT Gateway configured.
   
2. **Permissions Issues:** Verify the IAM roles and policies attached to your EKS cluster and nodes are correctly set up.

3. **Subnet Configuration:** Check that the subnets have the correct CIDR blocks and are correctly associated with the route tables.

## Resources

1. AWS EKS Terraform module
   
   ```bash
   https://github.com/terraform-aws-modules/terraform-aws-eks

2. Amazon EKS Documentation
   
   ```bash
   https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html

## Contributing
Contributions are welcome! Please fork the repository and create a pull request with your changes.

Add new context to kubeconfig
aws eks --region us-east-1 update-kubeconfig --name eks-cluster

Get nodes
kubectl get nodes

test