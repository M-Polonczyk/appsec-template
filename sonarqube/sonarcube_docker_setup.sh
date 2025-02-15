#!/bin/bash

# Automated SonarQube Docker Setup Script
# This script sets up SonarQube using the official Docker image.

# Exit on error
set -e

# Variables
SONARQUBE_VERSION="9.9.1.69595" # Update this to the latest version if needed
SONARQUBE_CONTAINER_NAME="sonarqube"
SONARQUBE_PORT="9000"
POSTGRES_CONTAINER_NAME="sonarqube_db"
POSTGRES_USER="sonar"
POSTGRES_PASSWORD="sonar"
POSTGRES_DB="sonar"
POSTGRES_PORT="5432"
DOCKER_NETWORK="sonarqube_network"

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
  echo "Docker is not installed. Please install Docker first."
  exit 1
fi

# Create a Docker network for SonarQube and PostgreSQL
echo "Creating Docker network..."
docker network create $DOCKER_NETWORK

# Start PostgreSQL container
echo "Starting PostgreSQL container..."
docker run -d --name $POSTGRES_CONTAINER_NAME \
  --network $DOCKER_NETWORK \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -p $POSTGRES_PORT:5432 \
  postgres:13

# Wait for PostgreSQL to initialize
echo "Waiting for PostgreSQL to initialize..."
sleep 20

# Start SonarQube container
echo "Starting SonarQube container..."
docker run -d --name $SONARQUBE_CONTAINER_NAME \
  --network $DOCKER_NETWORK \
  -p $SONARQUBE_PORT:9000 \
  -e SONAR_JDBC_URL=jdbc:postgresql://$POSTGRES_CONTAINER_NAME:5432/$POSTGRES_DB \
  -e SONAR_JDBC_USERNAME=$POSTGRES_USER \
  -e SONAR_JDBC_PASSWORD=$POSTGRES_PASSWORD \
  sonarqube:$SONARQUBE_VERSION

# Check if SonarQube is running
echo "Checking SonarQube status..."
sleep 10
docker ps --filter "name=$SONARQUBE_CONTAINER_NAME"

echo "SonarQube setup complete! Access it at http://localhost:$SONARQUBE_PORT"
