#!/bin/bash

# Automated SonarQube Setup Script
# This script installs SonarQube and its dependencies on a Linux system.

# Exit on error
set -e

# Variables
SONARQUBE_VERSION="9.9.1.69595" # Update this to the latest version if needed
SONARQUBE_URL="https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONARQUBE_VERSION}.zip"
SONARQUBE_DIR="/opt/sonarqube"
SONARQUBE_USER="sonarqube"
SONARQUBE_SERVICE="sonarqube"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Update and install dependencies
echo "Updating system and installing dependencies..."
apt-get update
apt-get install -y unzip curl openjdk-17-jdk

# Create SonarQube user
if ! id -u $SONARQUBE_USER >/dev/null 2>&1; then
  echo "Creating SonarQube user..."
  useradd -m -d $SONARQUBE_DIR -s /bin/bash $SONARQUBE_USER
fi

# Download and install SonarQube
echo "Downloading SonarQube..."
cd /tmp
curl -O $SONARQUBE_URL
unzip sonarqube-${SONARQUBE_VERSION}.zip -d $SONARQUBE_DIR
mv $SONARQUBE_DIR/sonarqube-${SONARQUBE_VERSION}/* $SONARQUBE_DIR/
rm -rf $SONARQUBE_DIR/sonarqube-${SONARQUBE_VERSION} sonarqube-${SONARQUBE_VERSION}.zip

# Set permissions
echo "Setting permissions..."
chown -R $SONARQUBE_USER:$SONARQUBE_USER $SONARQUBE_DIR
chmod -R 775 $SONARQUBE_DIR

# Create systemd service for SonarQube
echo "Creating systemd service..."
cat >/etc/systemd/system/$SONARQUBE_SERVICE.service <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=$SONARQUBE_DIR/bin/linux-x86-64/sonar.sh start
ExecStop=$SONARQUBE_DIR/bin/linux-x86-64/sonar.sh stop
User=$SONARQUBE_USER
Group=$SONARQUBE_USER
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start SonarQube
echo "Starting SonarQube service..."
systemctl daemon-reload
systemctl enable $SONARQUBE_SERVICE
systemctl start $SONARQUBE_SERVICE

# Check status
echo "Checking SonarQube status..."
systemctl status $SONARQUBE_SERVICE

echo "SonarQube setup complete! Access it at http://localhost:9000"
