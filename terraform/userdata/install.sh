#!/bin/bash
set -e
exec > /var/log/userdata.log 2>&1

echo "===== Starting Installation ====="


apt-get update -y
apt-get upgrade -y

# ─── 2. Docker ──────────────────────────────────────────────────
echo "Installing Docker..."
apt-get install -y docker.io
systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# ─── 3. Java + Jenkins ──────────────────────────────────────────
echo "Installing Java and Jenkins..."
apt-get install -y fontconfig openjdk-17-jre

wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" \
  | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update -y
apt-get install -y jenkins

# Add jenkins user to docker group so Jenkins can run docker commands
usermod -aG docker jenkins

systemctl enable jenkins
systemctl start jenkins

# ─── 4. Docker Compose ──────────────────────────────────────────
echo "Installing Docker Compose..."
curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ─── 5. SonarQube (via Docker) ──────────────────────────────────
echo "Starting SonarQube container..."
docker run -itd \
  --name SonarQube-Server \
  --restart always \
  -p 9000:9000 \
  sonarqube:lts-community

# ─── 6. kubectl ─────────────────────────────────────────────────
echo "Installing kubectl..."
curl -o /tmp/kubectl \
  https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x /tmp/kubectl
mv /tmp/kubectl /usr/local/bin/kubectl

# ─── 7. AWS CLI ──────────────────────────────────────────────────
echo "Installing AWS CLI..."
apt-get install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o /tmp/awscliv2.zip
unzip /tmp/awscliv2.zip -d /tmp/
/tmp/aws/install
rm -rf /tmp/awscliv2.zip /tmp/aws/


# ─── 8. eksctl ───────────────────────────────────────────────────
echo "Installing eksctl..."
curl --silent --location \
  "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
  | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin/eksctl

# ─── 9. Trivy ────────────────────────────────────────────────────
echo "Installing Trivy..."
apt-get install -y wget apt-transport-https gnupg lsb-release

wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | apt-key add -

echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" \
  | tee -a /etc/apt/sources.list.d/trivy.list

apt-get update -y
apt-get install -y trivy

# ─── 10. OWASP Dependency Check ──────────────────────────────────
echo "Installing OWASP Dependency Check..."
# OWASP is installed as a Jenkins plugin, NOT on the OS.
# The jenkins plugin manager handles this after Jenkins boots.
# See: Manage Jenkins > Plugins > OWASP Dependency-Check
# Just pre-create the directory so Jenkins can write reports:
mkdir -p /var/lib/jenkins/dependency-check-data
chown -R jenkins:jenkins /var/lib/jenkins/dependency-check-data || true

# ─── Done ─────────────────────────────────────────────────────────
echo "===== All tools installed successfully! ====="
echo "Jenkins:   http://<PUBLIC_IP>:8080"
echo "SonarQube: http://<PUBLIC_IP>:9000"

# Print Jenkins initial admin password for easy access
echo "Jenkins initial password:"
cat /var/lib/jenkins/secrets/initialAdminPassword || echo "Jenkins not ready yet, check /var/lib/jenkins/secrets/initialAdminPassword"