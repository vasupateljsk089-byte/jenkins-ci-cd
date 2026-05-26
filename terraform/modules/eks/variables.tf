variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster and node groups"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be created"
  type        = string
}

variable "key_name" {
  description = "Name for the EC2 key pair"
  type        = string
}