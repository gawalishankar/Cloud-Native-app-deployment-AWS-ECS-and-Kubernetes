variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "fusion"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type = list(string)

  default = [
    "us-east-2a",
    "us-east-2b"
  ]
}

variable "public_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_app_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "private_db_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]
}

variable "container_port" {
  description = "Application container port"
  type        = number
  default     = 80
}

variable "container_cpu" {
  type    = number
  default = 256
}

variable "container_memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "db_name" {
  description = "Fusion MySQL database name"
  type        = string
  default     = "fusion"
}

variable "db_username" {
  description = "Fusion MySQL username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Fusion MySQL password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "docker_image" {
  description = "Docker image URI"
  type        = string
}