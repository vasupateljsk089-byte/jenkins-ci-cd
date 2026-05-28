# AWS Provider Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# EC2 Variables
variable "instance_type" {
  description = "EC2 instance type for the Jenkins server"
  type        = string
  default     = "t3.small"
}

variable "ami_id" {
  description = "AMI ID for the Jenkins EC2 instance (Ubuntu 22.04 LTS)"
  type        = string
  default     = "ami-0f5ee92e2d63afc18"
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
  default     = "terra-automate-key"
}

variable "public_key_path" {
  description = "Local path to your public SSH key file"
  type        = string
  default     = "C:/Users/vasub/.ssh/jenkins_key.pub"
}
# ── EKS ─────────────────────────────────────────────────────────
variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
  default     = "devsecops-eks"
}

# ── VPC ──────────────────────────────────────────────────────────
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "devsecops-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}