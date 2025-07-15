# Bonmoja Take Home Assessment
## Getting Started

### 📂 Project Structure
This repository is structured into components— each maintaining its own Terraform state.

To make any changes, navigate to the appropriate directory and update the configuration as needed.

## Notes

- The Makefile automatically manages the backend configuration for each environment
- Each component uses a shared `variables.tf` file that is copied during initialization
- Environment-specific variables are stored in the `vars/` directory

```
.
├── components/               # Terraform modules per service
│   ├── vpc/
│   ├── ecs/
│   ├── rds/
│   ├── sns_sqs/
│   └── dynamoDB/
├── vars/                    # tfvars files per environment (dev/qa/prod)
├── scripts/                 # Health check script
├── aws_dependancies/        # CloudFormation template for state backend (S3 & KMS)
├── Makefile                 # Automated deployment script
├── README.md                 
└── SOLUTION.md

```

## 🛠️ Setup Instructions

### Prerequisites

Ensure you have the following installed:

- [Docker](https://www.docker.com/)
- [LocalStack CLI](https://docs.localstack.cloud/get-started/)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- `make` (for running Makefile)
- `awslocal` (alias for running AWS commands against LocalStack)

---

### 1. Clone the Repository

```bash
git clone https://github.com/WihanNimb/Bonmoja
```

---

### 2. Start LocalStack in Detached Mode

```bash
localstack start -d
```

Wait a few seconds for LocalStack to fully start. You can verify it's running by checking the health endpoint:

```bash
curl http://localhost:4566/_localstack/health
```

---

### 3. Deploy Base Infrastructure

This step creates the S3 bucket and KMS key used for Terraform remote state.

```bash
awslocal cloudformation create-stack \
  --stack-name state-stack \
  --template-body file://aws_dependancies/state-stack.yml
```

The system automatically polls and extracts the `KmsKeyId` ARN to inject into each module’s backend config.

---

### 4. Apply Terraform Modules

Run the following to deploy all Terraform components in order:

```bash
make apply_all env=dev
```

Modules are applied in this order:

1. VPC  
2. SNS + SQS  
3. ECS  
4. RDS  
5. DynamoDB

The backend configuration is copied to the root of the module, and the `kms_key_id` is injected at runtime using the value from CloudFormation outputs. This ensures secure state locking.

---

### 5. Run Health Check

After deployment, verify the ECS service is up:

```bash
bash scripts/health_check.sh
```

This script sends a request to:

```
http://localhost:5678/
```

and logs a warning if the service is unresponsive.

---