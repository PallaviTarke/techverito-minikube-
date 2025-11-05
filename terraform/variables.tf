variable "aws_region" { default = "ap-south-1" }
variable "project" { default = "tv-minikube" }
variable "key_pair_name" { description = "Existing AWS key pair name" }
variable "public_key" { description = "Public key content if creating a key pair", default = null }
variable "create_key_pair" { type = bool, default = false }
variable "ingress_http_port" { default = 30080 }
variable "ingress_https_port" { default = 30443 }