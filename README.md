# Cloud-Native Application Deployment on AWS ECS Fargate

A production-style deployment of a **PHP–MySQL web application** on **Amazon ECS Fargate** using Docker, Amazon ECR, Terraform, GitHub Actions, Application Load Balancer, Amazon RDS MySQL, and Amazon CloudWatch.

This project demonstrates an end-to-end DevOps workflow covering **containerization, Infrastructure as Code, CI/CD automation, cloud networking, load balancing, database connectivity, monitoring, and troubleshooting**.

---

## 🏗️ Architecture

```text
                           Internet
                              |
                              v
                    +-------------------+
                    | Application Load  |
                    |    Balancer       |
                    |      (ALB)        |
                    +---------+---------+
                              |
                              | HTTP :80
                              |
                +-------------+-------------+
                |                           |
                v                           v
        +---------------+           +---------------+
        | ECS Fargate   |           | ECS Fargate   |
        |    Task 1     |           |    Task 2     |
        | Private       |           | Private       |
        | Subnet        |           | Subnet        |
        +-------+-------+           +-------+-------+
                |                           |
                +-------------+-------------+
                              |
                              | MySQL :3306
                              v
                    +-------------------+
                    |   Amazon RDS      |
                    |      MySQL        |
                    |  Private Subnet   |
                    +-------------------+


                    CI/CD PIPELINE

Developer
    |
    | git push
    v
+----------------+
| GitHub         |
+-------+--------+
        |
        v
+----------------------+
|   GitHub Actions     |
|----------------------|
| Checkout Code        |
| Docker Build         |
| Image Tagging        |
| Push Image to ECR    |
| Deploy to ECS        |
+----------+-----------+
           |
           v
+----------------------+
|     Amazon ECR       |
|   Docker Image       |
+----------+-----------+
           |
           v
+----------------------+
|    Amazon ECS        |
|      Fargate         |
+----------------------+
```

---

# 🚀 Project Overview

The application is a PHP-based web application backed by a MySQL database.

The application is containerized using **Docker** and deployed on **Amazon ECS Fargate**.

The complete AWS infrastructure is provisioned using **Terraform**.

Docker images are stored in **Amazon ECR**, while **GitHub Actions** automates the container image build and deployment workflow.

An **Application Load Balancer (ALB)** distributes incoming HTTP traffic across multiple ECS tasks and performs health checks to ensure traffic is routed only to healthy application containers.

The MySQL database is hosted on **Amazon RDS** inside private subnets and is accessible only from the ECS application layer through security group rules.

**Amazon CloudWatch** is used for centralized ECS container logging and troubleshooting.

---

# 🛠️ Technologies Used

### Cloud

* Amazon ECS Fargate
* Amazon ECR
* Amazon RDS MySQL
* Amazon VPC
* Application Load Balancer (ALB)
* AWS IAM
* Amazon CloudWatch
* Internet Gateway
* NAT Gateway
* Security Groups

### DevOps

* Terraform
* Docker
* GitHub Actions
* Git
* Linux
* AWS CLI

### Application

* PHP
* MySQL

---

# 📂 Project Structure

```text
.
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── terraform/
│   ├── versions.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── locals.tf
│   ├── vpc.tf
│   ├── security_groups.tf
│   ├── iam.tf
│   ├── ecr.tf
│   ├── alb.tf
│   ├── ecs.tf
│   ├── rds.tf
│   └── outputs.tf
│
├── Dockerfile
├── docker-compose.yml
├── src/
├── database/
├── .gitignore
└── README.md
```

---

# ☁️ AWS Infrastructure

Terraform provisions the complete AWS infrastructure required to run the application.

The infrastructure includes:

```text
AWS VPC
│
├── Public Subnets
│   └── Application Load Balancer
│
├── Private Application Subnets
│   └── ECS Fargate Tasks
│
├── Private Database Subnets
│   └── RDS MySQL
│
├── Internet Gateway
│
├── NAT Gateway
│
├── Route Tables
│
├── Security Groups
│
├── IAM Roles
│
├── Amazon ECR
│
├── ECS Cluster
│
├── ECS Service
│
└── CloudWatch Log Group
```

---

# 🌐 Network Architecture

The application follows a public/private subnet architecture.

### Public Subnets

The public subnets contain:

* Application Load Balancer
* NAT Gateway

The ALB receives HTTP traffic from the Internet and forwards requests to healthy ECS tasks.

### Private Application Subnets

ECS Fargate tasks run inside private subnets.

The ECS tasks do not require public IP addresses.

Outbound Internet access is provided through the NAT Gateway when required.

### Private Database Subnets

Amazon RDS MySQL runs inside private database subnets.

The database is not publicly accessible.

---

# 🔐 Security Group Flow

Traffic between application components is controlled using Security Groups.

```text
Internet
    |
    | TCP 80
    v
ALB Security Group
    |
    | TCP 80
    v
ECS Security Group
    |
    | TCP 3306
    v
RDS Security Group
```

### ALB Security Group

Allows:

```text
HTTP :80
Source: 0.0.0.0/0
```

### ECS Security Group

Allows:

```text
TCP :80
Source: ALB Security Group
```

### RDS Security Group

Allows:

```text
TCP :3306
Source: ECS Security Group
```

This ensures that the database is accessible only from the ECS application layer.

---

# 🐳 Docker

The application is containerized using Docker.

Build the Docker image:

```bash
docker build -t fusion .
```

Run the application locally:

```bash
docker run -d \
  -p 8080:80 \
  fusion
```

Access the application:

```text
http://localhost:8080
```

Check running containers:

```bash
docker ps
```

View container logs:

```bash
docker logs <container-id>
```

Stop the container:

```bash
docker stop <container-id>
```

---

# 📦 Amazon ECR

The Docker image is stored in Amazon Elastic Container Registry.

Example ECR repository:

```text
fusion
```

Example image URI:

```text
<ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/fusion:latest
```

Authenticate Docker with Amazon ECR:

```bash
aws ecr get-login-password \
  --region us-east-2 | \
  docker login \
  --username AWS \
  --password-stdin \
  <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com
```

Build the image:

```bash
docker build -t fusion .
```

Tag the image:

```bash
docker tag fusion:latest \
  <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/fusion:latest
```

Push the image:

```bash
docker push \
  <ACCOUNT_ID>.dkr.ecr.us-east-2.amazonaws.com/fusion:latest
```

---

# 🏗️ Terraform Infrastructure Deployment

## Prerequisites

Install the following:

* AWS CLI
* Terraform
* Docker
* Git

Configure AWS CLI:

```bash
aws configure
```

Verify AWS credentials:

```bash
aws sts get-caller-identity
```

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/gawalishankar/Cloud-Native-app-deployment-AWS-ECS-and-Kubernetes.git
```

Navigate to the project:

```bash
cd Cloud-Native-app-deployment-AWS-ECS-and-Kubernetes
```

Navigate to Terraform:

```bash
cd terraform
```

---

## Step 2: Configure Variables

Update the Terraform variables according to your AWS environment.

Example:

```hcl
aws_region   = "us-east-2"
project_name = "fusion"
environment  = "dev"

db_name     = "fusion"
db_username = "admin"

db_password = "YOUR_DATABASE_PASSWORD"

docker_image = "YOUR_AWS_ACCOUNT_ID.dkr.ecr.us-east-2.amazonaws.com/fusion:latest"
```

Do not commit real credentials or passwords to GitHub.

Add sensitive files to `.gitignore`:

```text
terraform.tfvars
.terraform/
terraform.tfstate
terraform.tfstate.*
```

---

## Step 3: Initialize Terraform

```bash
terraform init
```

---

## Step 4: Format Terraform Code

```bash
terraform fmt -recursive
```

---

## Step 5: Validate Terraform Configuration

```bash
terraform validate
```

---

## Step 6: Review Terraform Plan

```bash
terraform plan
```

Review all resources before deployment.

---

## Step 7: Deploy Infrastructure

```bash
terraform apply
```

Confirm the deployment by entering:

```text
yes
```

Terraform will provision the AWS infrastructure.

---

# 🔄 CI/CD Pipeline

GitHub Actions automates the application deployment workflow.

The CI/CD process follows:

```text
Developer
    |
    | Push Code
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +--> Checkout Source Code
    |
    +--> Configure AWS Credentials
    |
    +--> Authenticate with ECR
    |
    +--> Build Docker Image
    |
    +--> Tag Docker Image
    |
    +--> Push Image to ECR
    |
    +--> Deploy New Image to ECS
    |
    v
ECS Fargate
    |
    v
ALB Health Check
    |
    v
Application Available
```

---

# 🔑 GitHub Actions Configuration

Configure the required GitHub Actions secrets under:

```text
GitHub Repository
    ↓
Settings
    ↓
Secrets and variables
    ↓
Actions
```

Example secrets:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
ECR_REPOSITORY
ECS_CLUSTER
ECS_SERVICE
```

For production environments, AWS authentication should preferably use **GitHub Actions OIDC with an IAM role** instead of long-lived AWS access keys.

---

# 🗄️ Database Configuration

The PHP application connects to Amazon RDS MySQL using environment variables.

```text
DB_HOST
DB_NAME
DB_USER
DB_PASS
```

Example:

```text
DB_HOST=<RDS-ENDPOINT>
DB_NAME=fusion
DB_USER=admin
DB_PASS=<DATABASE-PASSWORD>
```

The database connection flow is:

```text
ECS Fargate
     |
     | TCP 3306
     v
RDS MySQL
```

The RDS database is deployed in private subnets and is not publicly accessible.

> For a production deployment, database credentials should be stored in AWS Secrets Manager and injected into ECS tasks using ECS secrets integration.

---

# ⚖️ Application Load Balancer

The Application Load Balancer provides a single entry point for users.

Traffic flow:

```text
User
  |
  v
Application Load Balancer
  |
  +----> ECS Task 1
  |
  +----> ECS Task 2
```

The ALB uses health checks to verify ECS task availability.

Example:

```text
Protocol: HTTP
Port: 80
Path: /
```

Only healthy ECS tasks receive application traffic.

---

# 📊 Monitoring and Logging

Amazon CloudWatch is used for ECS container logs.

The application logs can be viewed in:

```text
CloudWatch
    ↓
Log Groups
    ↓
/ecs/fusion-dev
```

CloudWatch logs help troubleshoot:

* Application startup failures
* PHP application errors
* Database connectivity issues
* ECS task failures
* Container crashes
* Deployment problems

View logs using AWS CLI:

```bash
aws logs tail \
  /ecs/fusion-dev \
  --follow \
  --region us-east-2
```

---

# 🩺 Troubleshooting

## ECS Task Fails to Start

Check:

* ECS task definition
* Docker image URI
* ECR image availability
* ECS task execution role
* Container port
* Environment variables
* CloudWatch logs

Check ECS tasks:

```bash
aws ecs list-tasks \
  --cluster <CLUSTER_NAME> \
  --region us-east-2
```

---

## ALB Health Check Failure

Check:

* Application is listening on port 80
* ECS container port is 80
* Target group port is 80
* ALB security group
* ECS security group
* Health check path
* Application startup logs

---

## RDS Database Connectivity Failure

Verify:

* RDS instance status
* RDS endpoint
* ECS and RDS are in the same VPC
* RDS security group allows ECS security group
* MySQL port 3306 is allowed
* `DB_HOST` is correct
* `DB_NAME` is correct
* `DB_USER` is correct
* `DB_PASS` is correct

---

# 🧹 Destroy Infrastructure

To remove all Terraform-managed infrastructure:

```bash
terraform destroy
```

Confirm:

```text
yes
```

> **Warning:** Destroying infrastructure may delete the RDS database depending on the configured Terraform settings. Always back up production databases before destroying infrastructure.


---

# 🎯 DevOps Skills Demonstrated

This project demonstrates practical knowledge of:

### AWS

* Amazon ECS Fargate
* Amazon ECR
* Amazon RDS MySQL
* Amazon VPC
* Application Load Balancer
* AWS IAM
* Amazon CloudWatch
* Internet Gateway
* NAT Gateway
* Security Groups

### DevOps

* Docker containerization
* Infrastructure as Code
* Terraform
* CI/CD
* GitHub Actions
* Git
* Linux
* AWS CLI

### Infrastructure

* Public and private subnet architecture
* Secure network segmentation
* Containerized application deployment
* Load balancing
* Database connectivity
* Health checks
* Centralized logging
* Infrastructure automation

---

# 👨‍💻 Author

**Shivshankar Gawali**

DevOps Engineer | AWS | Docker | Kubernetes | Terraform | CI/CD

GitHub:
https://github.com/gawalishankar

---

# 📄 License

This project is created for educational, learning, and portfolio purposes.
