# Terraform Projects – Real-World Scenarios

This repository contains **real-world, production-style Terraform projects**
focused on AWS infrastructure, security, state management, and automation.

---

## Completed Projects

### Scenario 1: Environment-Based EC2 Configuration (dev / qa / prod)

- Automatically changes EC2 settings- instance type, tags, and EBS volume size based on the chosen environment.
- Uses Terraform variables, locals, and conditional expressions

📁 Folder: `Scenario-1/`

---

### Scenario 2: Multi-Environment Infrastructure (dev / qa / prod)

- Provisions isolated dev, qa, and prod environments
- Environment-specific AMIs, instance types, and tags
- All instances deployed in private subnets
- Multiple implementation approaches included:
  - locals
  - tfvars
  - modules (recommended)

📁 Folder: `scenario-2/`

---

### Scenario 3: Secure EC2 → S3 Access using IAM Roles (Import-Based)

- Imported existing EC2 and S3 resources into Terraform
- Implemented IAM Role + Instance Profile for EC2
- Enforced least-privilege S3 access
- Restricted bucket access to ONLY the EC2 IAM role
- Followed AWS-recommended IAM-based access model (no access keys)

📁 Folder: `scenario-3/`

---

### Scenario 4: Create AMI from Existing EC2 Instance

- Imported an existing EC2 instance into Terraform
- Created a reusable AMI (Golden AMI pattern)
- Launched a new EC2 instance using the custom AMI
- Ensured user_data execution by cleaning cloud-init state

📁 Folder: `scenario-4/`

---

### Scenario 5: Import Existing S3 Bucket into Terraform

- Imported manually created S3 bucket into Terraform state
- Extracted bucket ARN for documentation and reuse
- Managed brownfield infrastructure safely without recreation

📁 Folder: `scenario-5/`

---

### Scenario 6: IAM User Access Control Based on Environment (Dev / QA / Prod)

- Implemented environment-based IAM access using groups and policies
- Enforced least-privilege permissions at group level
- Created IAM users and automatically mapped them to environment-specific groups
- Dynamically generated IAM policies using conditional logic
- Ensured zero manual permission handling

**Access Model:**

- Dev → EC2 read-only + S3 read/write
- QA → EC2 + S3 read-only
- Prod → Restricted EC2 access (no delete permissions)

📁 Folder: `scenario-6/`

---

### 🔹 Scenario 7: Restrict IAM User Access to a Single S3 Bucket

- Restricted an IAM user to access ONLY one specific S3 bucket
- Prevented visibility and access to all other buckets
- Enforced resource-level IAM permissions using bucket and object ARNs

📁 Folder: `scenario-7/`

---

### 🔹 Scenario 8: Prevent Accidental Deletion of S3 Resources

- Protected critical S3 buckets from accidental deletion
- Enabled S3 versioning for object-level recovery
- Applied Terraform lifecycle protection (`prevent_destroy`)
- Configured lifecycle rules for non-current object versions
- Implemented IAM group-based access control:
  - Admin group → Full access
  - User group → Restricted access

**Key focus:** Data protection and production safety

📁 Folder: `scenario-8/`

---

### 🔹 Scenario 9: Automate Container Deployment on EC2

- Provisioned an EC2 instance using Terraform
- Automated application deployment using EC2 user data
- Installed Docker during instance boot
- Pulled a Docker image from Docker Hub automatically
- Ran the container on startup and exposed the application via port 80
- Configured security groups to allow HTTP traffic

**Key focus:** Combining infrastructure provisioning with application bootstrap using Terraform and cloud-init.

📁 Folder: `scenario-9/`

---

### 🔹 Scenario 10: Custom VPC Deployment (Public & Private Subnets)

- Designed and deployed a custom VPC using Terraform
- Created separate public and private subnets for workload isolation
- Attached an Internet Gateway (IGW) to the public subnet
- Deployed a NAT Gateway inside the public subnet
- Configured route tables:
  - Public subnet routes traffic via Internet Gateway
  - Private subnet routes outbound traffic via NAT Gateway
- Launched EC2 instances:
  - Public EC2 with public IP
  - Private EC2 without public IP
- Ensured private instances have outbound-only internet access

**Key focus:** Secure VPC design, network isolation, and controlled internet access following AWS best practices.

📁 Folder: `scenario-10/`

---

### 🔹 Scenario 11: Highly Available Web Application on AWS (ALB + ASG + HTTPS)

- Designed and deployed a highly available web application architecture using Terraform
- Created a secure multi-tier setup inside a custom VPC
- Used public subnets for Application Load Balancer (ALB)
- Used private subnets for EC2 instances (no public IPs)
- Implemented Auto Scaling Group (ASG) for high availability and self-healing
- Deployed Dockerized web application using EC2 user data
- Configured ALB target groups with health checks
- Enabled HTTPS using ACM (SSL certificate) with Route53 DNS validation
- Redirected HTTP (80) traffic to HTTPS (443)
- Used IAM role with SSM access for EC2 management
- Ensured outbound-only internet access for private instances using NAT Gateway

**Key focus:** High availability, scalability, security, and production-ready AWS architecture using Terraform.

📁 Folder: `scenario-11/`

---

### 🔹 Scenario 12: Secure EC2 Access with Local SSH Keys & Remote Terraform State

- Implemented secure EC2 access using locally generated SSH key pairs
- Generated SSH keys locally using Terraform TLS provider
- Uploaded only the public key to AWS (private key never leaves local machine)
- Launched EC2 instance in a private subnet with no public IP
- Disabled inbound SSH access completely
- Enabled secure access via AWS Systems Manager (SSM) Session Manager
- Configured remote Terraform backend using S3 for state storage
- Enabled state locking using DynamoDB to prevent concurrent state corruption
- Implemented Terraform workspaces for dev / qa / prod environment isolation
- Ensured separate state files per environment
- Followed Terraform collaboration and security best practices

**Key focus:** Secure access, state management, environment isolation, and team-safe Terraform workflows.

📁 Folder: `scenario-12/`

---


## 📫 Connect with Me

**Suchith S**
Cloud & DevOps Engineer

🔗 LinkedIn: [https://www.linkedin.com/in/suchith-s-a96208253](https://www.linkedin.com/in/suchith-s-a96208253)
📂 GitHub: (this repo)

---
