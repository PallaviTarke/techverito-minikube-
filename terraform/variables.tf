variable "aws_region" {
  default     = "ap-south-1"
  description = "AWS region for deployment"
}

variable "project" {
  default     = "tv-minikube"
  description = "Project name"
}

variable "key_pair_name" {
  description = "Existing AWS key pair name"
}

variable "public_key" {
  description = "Public key content if creating a key pair"
  default     = null
}

variable "create_key_pair" {
  type        = bool
  default     = false
}

variable "ingress_http_port" {
  default     = 30080
  description = "HTTP NodePort for ingress"
}

variable "ingress_https_port" {
  default     = 30443
  description = "HTTPS NodePort for ingress"
}
