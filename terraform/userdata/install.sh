#!/bin/bash
exec > /var/log/userdata.log 2>&1
set -x

echo "===== Starting Installation ====="

apt-get update -y
apt-get upgrade -y

# ─── 1. Docker ──────────────────────────────────────────────────
echo "Installing Docker..."
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# Wait for Docker to be fully ready
sleep 10

# ─── 2. Java 21 + Jenkins ───────────────────────────────────────
echo "Installing Java 21..."
apt-get install -y fontconfig openjdk-21-jre

echo "Installing Jenkins..."
wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

usermod -aG docker jenkins

systemctl enable jenkins
systemctl start jenkins

# Wait for Jenkins to fully initialize
sleep 30

# ─── 3. Docker Compose ──────────────────────────────────────────
echo "Installing Docker Compose..."
curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ─── 4. SonarQube (via Docker) ──────────────────────────────────
echo "Starting SonarQube container..."
docker run -itd \
  --name SonarQube-Server \
  --restart always \
  -p 9000:9000 \
  sonarqube:lts-community

# ─── 5. kubectl ─────────────────────────────────────────────────
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -sL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

# ─── 6. AWS CLI ─────────────────────────────────────────────────
echo "Installing AWS CLI..."
apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o /tmp/awscliv2.zip
unzip /tmp/awscliv2.zip -d /tmp/
/tmp/aws/install
rm -rf /tmp/awscliv2.zip /tmp/aws/

# ─── 7. eksctl ──────────────────────────────────────────────────
echo "Installing eksctl..."
curl --silent --location \
  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin/eksctl

# ─── 8. Trivy ───────────────────────────────────────────────────
echo "Installing Trivy..."
apt-get install -y wget apt-transport-https gnupg lsb-release

wget -qO /usr/share/keyrings/trivy.gpg \
  https://aquasecurity.github.io/trivy-repo/deb/public.key

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
  https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
  | tee /etc/apt/sources.list.d/trivy.list

apt-get update -y
apt-get install -y trivy

# ─── 9. OWASP Dependency Check ──────────────────────────────────
echo "Setting up OWASP Dependency Check directory..."
mkdir -p /var/lib/jenkins/dependency-check-data
chown -R jenkins:jenkins /var/lib/jenkins/dependency-check-data || true

# ─── Done ───────────────────────────────────────────────────────
echo "===== All tools installed successfully! ====="

echo "Jenkins initial password:"
cat /var/lib/jenkins/secrets/initialAdminPassword || echo "Jenkins not ready yet"