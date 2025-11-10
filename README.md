# DevOps AWS Lab

Terraform lab for AWS: VPC with public/private subnets, EC2 bastion, S3 artifact bucket, and IAM instance profile using the `aws` provider.

## Architecture

```
VPC (10.20.0.0/16)
├── Public subnet  (10.20.1.0/24)  — Internet Gateway, bastion EC2
├── Private subnet (10.20.2.0/24)  — future app tier
├── S3 bucket (versioned, encrypted)
└── IAM role + instance profile (SSM read-only)
```

## Prerequisites

- AWS CLI (`aws configure` or SSO)
- Terraform 1.5+
- IAM permissions for VPC, EC2, S3, and IAM role creation

## Quick Start

```bash
cd infra
terraform init
terraform plan -var="prefix=devopslab" -var="aws_region=us-east-1"
```

Do not commit `terraform.tfstate` or secrets. Use `terraform.tfvars` locally (not tracked).

## Scripts

- `scripts/aws-inventory.sh` — Summarize VPCs, EC2 instances, and S3 buckets in the account

## CI

GitHub Actions workflow `.github/workflows/terraform-validate.yml` runs `terraform fmt`, `validate`, and `plan` (no apply).

## IAM

See `docs/iam-least-privilege.md` for least-privilege patterns used by this stack.
