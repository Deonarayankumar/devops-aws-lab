# IAM Least Privilege Guide

This lab applies least-privilege patterns for EC2 and operator access.

## EC2 Instance Role

The bastion EC2 instance uses an IAM role with a single AWS managed policy:

| Policy | Purpose |
|--------|---------|
| `AmazonSSMManagedInstanceCore` | Session Manager access without SSH keys |

No S3 or broad `*` permissions are attached to the instance role.

## Operator Permissions

Terraform operators need scoped permissions for:

- `ec2:*` on tagged resources (or use a sandbox account)
- `s3:*` on the artifacts bucket prefix
- `iam:CreateRole`, `iam:AttachRolePolicy`, `iam:PassRole` for the instance profile

Prefer permission sets with resource-tag conditions:

```json
{
  "Effect": "Allow",
  "Action": ["ec2:RunInstances"],
  "Resource": "*",
  "Condition": {
    "StringEquals": {
      "aws:RequestTag/project": "devops-aws-lab"
    }
  }
}
```

## SSH Access

Restrict `allowed_ssh_cidrs` to your office or VPN CIDR. Prefer AWS Systems Manager Session Manager over open SSH.

## Auditing

```bash
aws iam list-attached-role-policies --role-name devopslab-ec2-role
bash scripts/aws-inventory.sh
```

## Anti-patterns

- Attaching `AdministratorAccess` to EC2 instance roles
- Storing access keys on instances
- Committing `.pem` files or `terraform.tfvars` with secrets
