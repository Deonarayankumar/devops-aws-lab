#!/usr/bin/env bash
# aws-inventory.sh — Summarize key AWS resources in the current account/region.
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
PROFILE="${AWS_PROFILE:-}"

echo "=== AWS Inventory ==="
echo "Region: ${REGION}"
[[ -n "$PROFILE" ]] && echo "Profile: ${PROFILE}"

if ! command -v aws >/dev/null 2>&1; then
  echo "AWS CLI is required."
  exit 1
fi

AWS_ARGS=(--region "$REGION")
[[ -n "$PROFILE" ]] && AWS_ARGS+=(--profile "$PROFILE")

ACCOUNT_ID=$(aws "${AWS_ARGS[@]}" sts get-caller-identity --query Account --output text 2>/dev/null || true)
if [[ -z "$ACCOUNT_ID" ]]; then
  echo "Not authenticated. Run: aws configure or aws sso login"
  exit 1
fi
echo "Account: ${ACCOUNT_ID}"
echo

echo "--- VPCs ---"
aws "${AWS_ARGS[@]}" ec2 describe-vpcs \
  --query 'Vpcs[].{VpcId:VpcId,Cidr:CidrBlock,Tags:Tags[?Key==`Name`].Value|[0]}' \
  --output table

echo
echo "--- EC2 Instances ---"
aws "${AWS_ARGS[@]}" ec2 describe-instances \
  --query 'Reservations[].Instances[].{Id:InstanceId,Type:InstanceType,State:State.Name,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`].Value|[0]}' \
  --output table

echo
echo "--- S3 Buckets ---"
aws "${AWS_ARGS[@]}" s3api list-buckets \
  --query 'Buckets[].{Name:Name,Created:CreationDate}' \
  --output table

echo
echo "Done."
