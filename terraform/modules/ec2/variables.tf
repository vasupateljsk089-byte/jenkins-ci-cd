variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu 22.04 LTS ap-south-1)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to the instance"
  type        = string
}

variable "key_name" {
  description = "Name for the EC2 key pair"
  type        = string
}

variable "public_key_path" {
  description = "Path to the local public SSH key file"
  type        = string
}

variable "user_data" {
  description = "Shell script to run on first boot"
  type        = string
  default     = ""
}
