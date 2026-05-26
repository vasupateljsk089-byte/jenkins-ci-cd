variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

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
  default     = "C:\\Users\\vasub\\ec2.pub"
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
  default     = "devsecops-eks"
}
