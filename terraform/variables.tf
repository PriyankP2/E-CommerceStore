variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "dockerhub_username" {
  description = "Your DockerHub username"
  type        = string
}

variable "mongo_uri_users" {
  description = "MongoDB URI for user service"
  type        = string
  sensitive   = true
}

variable "mongo_uri_products" {
  description = "MongoDB URI for product service"
  type        = string
  sensitive   = true
}

variable "mongo_uri_carts" {
  description = "MongoDB URI for cart service"
  type        = string
  sensitive   = true
}

variable "mongo_uri_orders" {
  description = "MongoDB URI for order service"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT secret key"
  type        = string
  sensitive   = true
  default     = "my-super-secret-jwt-key-change-me"
}

variable "key_pair_name" {
  description = "Name of existing AWS key pair for SSH access (optional)"
  type        = string
  default     = ""
}
