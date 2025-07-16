# 📄 SOLUTION.md

This document outlines the architectural decisions, trade-offs, security measures, and cost optimization strategies used in this infrastructure-as-code project deployed via Terraform and LocalStack.

---

## 📐 Architecture Overview

This solution provisions a secure and scalable AWS infrastructure to host a containerized HTTP service using ECS Fargate, integrated with RDS, SQS, SNS, and DynamoDB. Infrastructure is defined as modular, reusable Terraform code, with each major component (VPC, ECS, RDS, etc.) managed independently and remotely via its own state file.

### 🧩 Core Components

- **VPC** with public and private subnets, NAT Gateway, and routing tables  
- **ECS Fargate Cluster** hosting a containerized `http-echo` service  
- **RDS PostgreSQL** instance in private subnets  
- **DynamoDB**, **SQS queue**, and **SNS topic** for extended messaging features  
- **GitHub Actions** CI/CD pipeline to build, push, validate, and deploy  
- **CloudWatch** for logging and alarms  

> 📌 *See architecture diagram in [`README.md`](./README.md#-architecture-overview)*

---

## ⚖️ ECS Networking Trade-Off: Public vs. Private

Initially, the ECS task was deployed to public subnets with `assign_public_ip = true`, allowing direct access for testing purposes. While this works for rapid iteration, it is **not production-appropriate** due to the public exposure of the service.

### ✅ Recommended Production Approach

- Place ECS tasks in private subnets  
- Deploy an **Application Load Balancer (ALB)**  
- Route incoming traffic from the internet through the ALB to ECS tasks  
- Configure ALB health checks and HTTPS termination  

This ensures internet access is strictly mediated through the ALB while keeping workloads isolated.

---

## 🔐 IAM & Security Controls

IAM roles are scoped using **least-privilege principles**. The ECS task execution role includes:

- `AmazonEC2ContainerRegistryReadOnly`  
- `CloudWatchLogsFullAccess` (for logging)  

Security groups are tightly configured:

- ECS tasks allow only necessary inbound traffic (e.g., port 5678)  
- RDS allows PostgreSQL traffic only from the ECS task's security group  

Future enhancements:

- 🔐 AWS Secrets Manager for credentials  
- 🔐 Fine-grained IAM policies  
---

## 📊 Monitoring & Observability

- **CloudWatch Logs** are enabled for ECS services  
- **CloudWatch Alarms** are configured for:
  - High RDS CPU utilization  
  - High SQS queue depth  

Suggested improvements:

- Dashboards for key metrics  
- Alarm-based Auto Scaling  
- Centralized log aggregation (e.g., ELK stack, Datadog)

---

## 💸 AWS Cost Optimization Strategies

### 1. Use Spot Instances / Spot Tasks

- **What it is**: Spare EC2 capacity offered at a major discount (~90%). ECS supports Spot tasks, which dramatically reduce compute costs.  
- **Trade-offs**: Spot tasks can be interrupted by AWS with a 2-minute warning. Best for stateless, fault-tolerant services.

---

### 2. Use Savings Plans or Reserved Instances

- **What it is**: Commit to consistent usage for 1–3 years to receive discounts up to ~72% on Fargate, EC2, or RDS usage.  
- **Trade-offs**: Requires forecasting. You’re locked into usage whether or not you scale down, limiting flexibility.

---

## 🧮 Cost Optimization Focus: RDS

**Chosen Service**: RDS PostgreSQL

### 💡 Cost-Optimization Techniques:

- **Reserved Instances**: Save 60–70% by pre-paying and committing usage  
- **Right-Sizing**: Monitor CPU and IOPS via CloudWatch and Performance Insights  
- **Storage Optimization**: Use gp2/gp3 unless Provisioned IOPS is needed  
- **Pause/Resume**: For dev environments, use Aurora Serverless or turn off instances during idle periods  

> ⚠️ *Trade-offs:* Committed usage limits flexibility. Downscaling may reduce performance. Aurora is not always available or instant-on.

---

## 📝 Final Notes

- Each Terraform module manages its own remote state, allowing for isolated deployments and better CI/CD control.
- The system dynamically injects backend configuration outputs from CloudFormation (e.g., KMS).
- Future enhancements could include:
  - Full ALB integration for ECS  
  - Secrets managed via AWS Secrets Manager  
  - Interconnected services (e.g., ECS consuming from SQS, storing in RDS/DynamoDB)

---

This solution demonstrates a production-minded infrastructure setup optimized for clarity, modularity, and cost efficiency — with strong local prototyping support via LocalStack.
