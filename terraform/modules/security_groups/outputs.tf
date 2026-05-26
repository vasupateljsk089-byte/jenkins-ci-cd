output "jenkins_sg_id" {
  description = "ID of the Jenkins security group"
  value       = aws_security_group.jenkins_sg.id
}

output "jenkins_sg_name" {
  description = "Name of the Jenkins security group"
  value       = aws_security_group.jenkins_sg.name
}
