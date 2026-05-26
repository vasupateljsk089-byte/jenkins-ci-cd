resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-master-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# 2. Attach AdministratorAccess (fine for learning; scope down for real prod)
# This is needed for Jenkins to manage AWS resources (awscli) (EKS, S3, etc.) without manual creds
resource "aws_iam_role_policy_attachment" "jenkins_admin" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 3. Create instance profile (EC2 uses profiles, not roles directly)
resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-master-profile"
  role = aws_iam_role.jenkins_role.name
}


# Upload your local public key to AWS as a key pair
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name = var.key_name
  }
}

# Jenkins EC2 instance
resource "aws_instance" "jenkins_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  # Runs install.sh on first boot to set up Jenkins, Docker, SonarQube, Grafana
  user_data = var.user_data

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Jenkins-Server"
  }
}
