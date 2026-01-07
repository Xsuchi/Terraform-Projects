# Scenario 13: Migrate Existing Local State to Terraform Cloud

## Overview

In real-world production environments, **Terraform state must never live on a single engineer’s laptop**.
This scenario demonstrates how to **safely migrate an existing Terraform project** from a **local backend** to **Terraform Cloud (TFC)** **without destroying or recreating any infrastructure**.

- Zero downtime
- No resource recreation
- Production-safe state migration

---

##  Base Project Used

This scenario reuses **Scenario-1**:

### **Automate EC2 Configuration Based on Environment (dev / qa / prod)**

Terraform dynamically adjusts EC2 configuration based on the selected environment:

| Environment | Instance Type | EBS Volume Size |
| ----------- | ------------- | --------------- |
| dev         | t2.micro      | 8 GB            |
| qa          | t2.small      | 16 GB           |
| prod        | t3.large      | 32 GB           |

### Terraform concepts used

* `variables`
* `locals`
* `conditional expressions`

---

## Initial Execution (Local Backend)

### Run using local state

```bash
terraform init
terraform plan
terraform apply -var="environment=dev"
```

At this stage:

* `terraform.tfstate` is stored **locally**
* Infrastructure is successfully created
* State is **NOT shared** (unsafe for teams)

![alt text](img/image.png)
---

## Problem

Local state is:

* Not shared
* Not locked
* Not recoverable
* Unsafe for production

**Solution**: Migrate state to **Terraform Cloud**

---

## Migration Goal

> Move existing **local Terraform state** to **Terraform Cloud**
> **Without destroying or recreating resources**

---

## Backend Reference

> Backend setup details are documented separately
> 📄 Refer: **backend-setup/README.md** [Backend-Setup](backend-setup/README.md)

This keeps the main project **clean and code-focused**.

---

## Steps to Migrate Local State → Terraform Cloud

---

### **Step 1: Update Backend Configuration**

Add this block to `main.tf`:

```hcl
terraform {
  cloud {
    organization = "test_org_such"

    workspaces {
      name = "my-test-migrate"
    }
  }
}
```

This tells Terraform:

* “State now lives in Terraform Cloud”
* “Use workspace `my-test-migrate`”

---

### **Step 2: Authenticate with Terraform Cloud**

```bash
terraform login
```
![terraform login](img/image-1.png)

Terraform will:

* Open browser
* Ask for API token
* Store it locally at:
![alt text](img/image-2.png)

**Windows**

```
C:\Users\<username>\AppData\Roaming\terraform.d\credentials.tfrc.json
```

Token is reused automatically in future runs

---

### **Step 3: Initialize & Migrate State**

```bash
terraform init
```

Terraform will detect:

* Existing **local state**
* New **Terraform Cloud backend**

You will be prompted:

```
Do you want to migrate your existing state to Terraform Cloud?
```

Type **yes**

State is uploaded to Terraform Cloud
Resources are NOT recreated

![alt text](img/image-4.png)

![remote-state-file](img/image-3.png)
---

## What Happens After Migration?

### 🔹 Local files

* `terraform.tfstate`
* `terraform.tfstate.backup`

These files may still exist **but are no longer authoritative**.

They usually contain **empty or minimal metadata**.

ref -![alt text](img/image-6.png)

**Safe to delete**:

```text
terraform.tfstate
terraform.tfstate.backup
```

---

### 🔹 `.terraform/` directory

Now points to:

* Terraform Cloud workspace
* Remote execution metadata

---

## Verifying Remote State

You can fetch state info locally:

```bash
terraform show
or 
terraform state list
```

![alt text](img/image-7.png)

Terraform will:

* Pull state from **Terraform Cloud**
* Display real infrastructure details

---

##  AWS Credentials with Terraform Cloud

Since execution happens in Terraform Cloud, AWS credentials must live there.

### Add credentials in Terraform Cloud UI:

1. Terraform Cloud → Organization → Workspace
2. Go to **Variables**
![variables](img/image-8.png)
3. Add **Environment Variables**

access keys - ![alt text](img/image-9.png)
sceret keys - ![alt text](img/image-10.png)

| Name                  | Value     | Type          |
| --------------------- | --------- | ------------- |
| AWS_ACCESS_KEY_ID     | ********  | Sensitive     |
| AWS_SECRET_ACCESS_KEY | ********  | Sensitive     |
| AWS_DEFAULT_REGION    | us-east-1 | Non-sensitive |

---

## Cleanup

```bash
terraform destroy
```

Destroy can be triggered:

* From CLI
* From Terraform Cloud UI

State is updated automatically.

##  Validation

✔ Terraform destroy executed locally
✔ Execution happened in Terraform Cloud
✔ State updated remotely
✔ Resources destroyed correctly

![terraform destory](img/image-11.png)

![terraform cloud output](img/image-12.png)

![aws](img/image-13.png)

---

## Key Learnings 

### 1️ Terraform Cloud is the **source of truth**

Local files no longer matter after migration.

### 2️ `terraform apply` still runs locally

But execution happens **remotely**.

### 3️ State locking & history are automatic

* No corruption
* Full audit trail
* Team-safe

---

## Final Summary

This scenario demonstrates:

* Safe state migration
* Zero-downtime backend switch
* Enterprise-grade Terraform workflow

