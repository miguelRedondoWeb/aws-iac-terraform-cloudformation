# Infrastructure as Code on AWS — Terraform vs CloudFormation

## Overview

This project demonstrates how to deploy, validate, inspect, and destroy AWS infrastructure using two Infrastructure as Code (IaC) tools: HashiCorp Terraform and AWS CloudFormation.

Both implementations provision equivalent resources in the AWS Spain Region (`eu-south-2`).

## Architecture

Each deployment creates:
- One Amazon S3 bucket with public access blocked.
- One Amazon EC2 `t3.micro` instance running Amazon Linux 2023.
- Networking through an existing VPC subnet and security group.
- An EC2 instance without a public IPv4 address.

The two deployments are performed separately to prevent resource conflicts and unnecessary costs.

## Technologies

- Terraform 1.16.6
- AWS Provider 5.100.0
- AWS CloudFormation
- AWS CLI 2.38.4
- Amazon EC2 and Amazon S3
- Visual Studio Code and AWS Toolkit

## Repository Structure

```text
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars.example
│   └── .terraform.lock.hcl
├── cloudformation/
│   ├── plantilla.yaml
│   └── parameters.example.json
├── docs/
│   └── evidencias.pdf
├── .gitignore
└── README.md
```

## Requirements

- AWS account with appropriate IAM permissions.
- AWS CLI configured with valid credentials.
- Terraform installed.
- An existing subnet and security group in `eu-south-2`.
- An Amazon Linux 2023 AMI compatible with the selected EC2 instance.

Update the example parameters before deployment. Never commit AWS credentials or Terraform state files.

## Deploy with Terraform

Navigate to the `terraform` directory and run:

```bash
terraform init
terraform fmt
terraform validate
terraform plan -var-file="terraform.tfvars.example"
terraform apply -var-file="terraform.tfvars.example"
```

Review the plan before approving the deployment.

After deployment, verify the S3 bucket, public access block configuration, EC2 instance and Terraform outputs.

Run the plan again without changing the configuration. No changes should be reported.

### Terraform Cleanup

```bash
terraform destroy -var-file="terraform.tfvars.example"
```

Confirm the deletion in AWS. Keep the Terraform state until cleanup has completed.

## Deploy with AWS CloudFormation

Navigate to the `cloudformation` directory.

Validate the template:

```bash
aws cloudformation validate-template --template-body file://plantilla.yaml --region eu-south-2
```

Create a change set for review:

```bash
aws cloudformation deploy --template-file plantilla.yaml --stack-name practica-iac-cfn --region eu-south-2 --no-execute-changeset
```

Review the generated change set in AWS CloudFormation and execute it after confirming the expected resources.

Wait for `CREATE_COMPLETE`, then verify the stack outputs, EC2 instance and S3 bucket.

The template includes example parameter defaults that must be adapted for other AWS accounts.

### CloudFormation Cleanup

```bash
aws cloudformation delete-stack --stack-name practica-iac-cfn --region eu-south-2
aws cloudformation wait stack-delete-complete --stack-name practica-iac-cfn --region eu-south-2
```

Verify that no practice-related resources remain.

## Terraform vs CloudFormation

| Feature | Terraform | CloudFormation |
|---|---|---|
| Configuration language | HCL | YAML / JSON |
| Cloud support | Multi-cloud | AWS only |
| Resource tracking | Terraform state | CloudFormation stack |
| Change preview | terraform plan | Change sets |
| Deployment | terraform apply | Execute change set |
| Cleanup | terraform destroy | Delete stack |

Terraform provides a consistent infrastructure workflow across multiple cloud providers. CloudFormation offers native AWS integration and manages infrastructure through AWS stacks.

## Exercise Results

Both tools successfully deployed and removed the required infrastructure.

- Terraform: 3 resources created and destroyed.
- Terraform repeat plan: no changes detected.
- CloudFormation: stack reached `CREATE_COMPLETE`.
- CloudFormation stack deletion: completed successfully.
- EC2 instances: verified as terminated.
- S3 buckets: deletion verified.
- EBS volumes: no remaining volumes in the AWS Spain Region.
- Elastic IPs: none remaining.

## Security and Cost Awareness

Both deployments used private S3 buckets with all four public access block settings enabled.

EC2 instances were configured without public IP addresses.

AWS resources may incur charges. All practice resources were removed after successful verification.

## Evidence

A detailed execution report, supporting evidence and technical comparison will be available in `docs/evidencias.pdf`.

## Academic Context

Practical exercise completed as part of the IFCD0078 Cloud & Data Engineering training program, October 2026.
