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

# AWS Cost Optimization

## AWS Cost-Saving Strategies

1. **Use Spot Instances / Spot Tasks**
   - **What it is:** Spot instances are spare EC2 capacity offered at up to 90% discount compared to On-Demand pricing. Similarly, ECS supports running tasks on Spot capacity.
   - **Trade-offs:** Spot instances can be interrupted by AWS with a 2-minute warning, so they are best suited for fault-tolerant, stateless, or batch workloads. Critical or stateful workloads may face disruption and require fallback strategies.

2. **Leverage Savings Plans or Reserved Instances**
   - **What it is:** Savings Plans offer significant discounts (up to 72%) in exchange for a commitment to use a consistent amount of compute (e.g., EC2 or Fargate) for 1 or 3 years. Reserved Instances are similar commitments specific to EC2 instance types.
   - **Trade-offs:** Savings Plans require upfront commitment and less flexibility if your usage patterns change. Early termination or scaling down doesn’t refund the commitment, so it requires good forecasting.

---

## Cost Optimization for RDS

**Strategy: Use Reserved Instances and Right-Size Your Database**

- **Reserved Instances:** Purchase RDS Reserved Instances (or Savings Plans for RDS) to reduce hourly costs by up to 60-70% compared to On-Demand.
- **Right-sizing:** Regularly monitor your RDS instance CPU, memory, and IOPS usage, and downscale to a smaller instance size if your workload allows. Use Amazon RDS Performance Insights and CloudWatch metrics for this.
- **Storage Optimization:** Use General Purpose (SSD) storage instead of Provisioned IOPS if your workload is not I/O-intensive.
- **Pause/Resume:** For development or test databases, use Aurora Serverless or pause the instance during idle times to avoid charges.
- **Trade-offs:** Committing to Reserved Instances requires accurate usage forecasting. Downscaling may reduce performance during peak loads, so monitoring and testing are important.


---

## Notes

- Each Terraform component has its own backend/state file to support better isolation, scalability, and parallelization.
- Further enhancements would include full ALB integration, secrets management via AWS Secrets Manager, and additional CI steps (e.g., integration tests post-deploy).
