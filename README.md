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
