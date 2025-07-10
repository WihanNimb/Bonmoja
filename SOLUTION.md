# SOLUTION.md

## Architecture Overview

This solution provisions a secure and scalable AWS infrastructure to host a containerized HTTP service using ECS Fargate, integrated with RDS, SQS, SNS, and DynamoDB. Infrastructure is defined as modular, reusable Terraform code, with each major component (VPC, ECS, RDS, etc.) managed independently and remotely via its own state file.

### Core Components
- **VPC** with public and private subnets, NAT Gateway, and routing tables
- **ECS Fargate Cluster** hosting a containerized `http-echo` service
- **RDS PostgreSQL** instance in private subnets
- **DynamoDB**, **SQS queue**, and **SNS topic** for extended messaging features
- **GitHub Actions** CI/CD pipeline to build, push, validate, and deploy
- **CloudWatch** for logging and alarms

---

## ECS Networking Trade-Off: Public vs. Private

Initially, the ECS task was deployed to public subnets with `assign_public_ip = true`, allowing direct access for testing purposes. While this works for rapid iteration, it is **not production-appropriate** due to the public exposure of the service.

### ✅ Recommended Production Approach:
- Place ECS tasks in private subnets
- Deploy an **Application Load Balancer (ALB)** in public subnets
- Route incoming traffic from the internet through the ALB to ECS tasks
- Configure ALB health checks and HTTPS termination


This ensures internet access is strictly mediated through the ALB while keeping workloads isolated.

---

## IAM and Security

IAM roles are scoped using least-privilege principles. The ECS task execution role includes:
- `AmazonEC2ContainerRegistryReadOnly`
- `CloudWatchLogsFullAccess` (for logging)

Security groups are tightly configured:
- ECS tasks allow only necessary inbound traffic (e.g., port 5678)
- RDS allows PostgreSQL traffic only from ECS task SG

---

## Cost Optimization

### Recommended Actions:
- **Use AWS Savings Plans** for consistent ECS/RDS usage
- **Enable storage autoscaling** for RDS (already configured)

### Example: RDS Cost Optimization
- Use `db.t3.micro` with auto-scaling storage and reserved capacity
- Disable multi-AZ for dev/testing (enabled in production)
- Use deletion protection cautiously (disabled here for CI/CD speed)

---

## Notes

- Each Terraform component has its own backend/state file to support better isolation, scalability, and parallelization.
- Further enhancements would include full ALB integration, secrets management via AWS Secrets Manager, and additional CI steps (e.g., integration tests post-deploy).
