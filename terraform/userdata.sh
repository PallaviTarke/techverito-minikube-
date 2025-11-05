#!/usr/bin/env bash
set -eux

# Basic updates
apt-get update -y && apt-get upgrade -y
apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https

#################################################
# Install Docker
#################################################
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
| tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker ubuntu

#################################################
# Install kubectl
#################################################
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#################################################
# Install Helm
#################################################
curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

#################################################
# Install Minikube
#################################################
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

#################################################
# Start minikube using Docker driver
#################################################
sudo -u ubuntu -H bash -lc 'minikube start --driver=docker --kubernetes-version=stable'

#################################################
# Enable NGINX ingress (NodePort)
#################################################
cat <<EOF >/tmp/nginx-values.yaml
controller:
  service:
    type: NodePort
    nodePorts:
      http: 30080
      https: 30443
EOF

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  -n ingress-nginx --create-namespace -f /tmp/nginx-values.yaml

#################################################
# Configure kubeconfig for ubuntu user
#################################################
mkdir -p /home/ubuntu/.kube
sudo -u ubuntu -H bash -lc 'minikube kubectl -- config view --raw' > /home/ubuntu/.kube/config
chown -R ubuntu:ubuntu /home/ubuntu/.kube

#################################################
# Alias k = kubectl
#################################################
echo 'alias k=kubectl' >> /home/ubuntu/.bashrc
