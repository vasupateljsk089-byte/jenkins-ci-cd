# AWS Provider Variables
aws_region      = "ap-south-1"

# EC2 Variables
instance_type   = "t3.small"
ami_id          = "ami-07a00cf47dbbc844c"
key_name        = "terra-automate-key"
public_key_path = "C:/Users/vasub/.ssh/jenkins_key.pub"

# EKS Variables
cluster_name    = "devsecops-eks"

# VPC Variables
vpc_name        = "devsecops-vpc"
vpc_cidr        = "10.0.0.0/16" # 10.0.0.0 - 10.0.255.255
azs             = ["ap-south-1a", "ap-south-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"] # 10.0.1.0 - 10.0.1.255, 10.0.2.0 - 10.0.2.255
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"] # 10.0.3.0 - 10.0.3.255, 10.0.4.0 - 10.0.4.255
