output "instance_id" {
  description = "ID of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.id
}

output "public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.public_ip
}

output "public_dns" {
  description = "Public DNS name of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.public_dns
}

output "private_ip" {
  description = "Private IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_server.private_ip
}
