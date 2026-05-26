output "jenkins_public_ip" {
  description = "Public IP of the Jenkins EC2 instance"
  value       = module.ec2.public_ip
}

output "jenkins_public_dns" {
  description = "Public DNS of the Jenkins EC2 instance"
  value       = module.ec2.public_dns
}

output "jenkins_url" {
  description = "Jenkins web UI URL"
  value       = "http://${module.ec2.public_ip}:8080"
}

output "sonarqube_url" {
  description = "SonarQube web UI URL"
  value       = "http://${module.ec2.public_ip}:9000"
}

output "grafana_url" {
  description = "Grafana web UI URL"
  value       = "http://${module.ec2.public_ip}:3000"
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  value       = module.eks.cluster_version
}

output "vpc_id" {
  description = "Default VPC ID used for all resources"
  value       = data.aws_vpc.default.id
}
