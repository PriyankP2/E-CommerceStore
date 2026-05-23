# 🛒 E-Commerce Store — Production Microservices on AWS

### Dockerized Microservices Architecture deployed on AWS EC2 using Terraform (Infrastructure as Code)

![Terraform](https://img.shields.io/badge/Terraform-v1.15.4-7B42BC?style=for-the-badge&logo=terraform)
![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?style=for-the-badge&logo=docker)
![AWS](https://img.shields.io/badge/AWS-EC2%20Deployed-FF9900?style=for-the-badge&logo=amazonaws)
![Node.js](https://img.shields.io/badge/Node.js-Microservices-339933?style=for-the-badge&logo=nodedotjs)
![React](https://img.shields.io/badge/React-Frontend-61DAFB?style=for-the-badge&logo=react)
![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?style=for-the-badge&logo=mongodb)

> A production-grade, fully automated, Infrastructure-as-Code deployment of a MERN-stack E-Commerce application using Docker containers on AWS EC2, provisioned entirely via `terraform apply`.

---

## 🌐 Live Deployment

| Service | URL | Status |
|---|---|---|
| Frontend | http://52.66.81.49 | ✅ Live |
| User Service | http://52.66.81.49:3001/health | ✅ Healthy |
| Product Service | http://52.66.81.49:3002/health | ✅ Healthy |
| Cart Service | http://52.66.81.49:3003/health | ✅ Healthy |
| Order Service | http://52.66.81.49:3004/health | ✅ Healthy |

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Microservices](#-microservices)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Phase 1 — MongoDB Atlas Setup](#phase-1--mongodb-atlas-setup)
- [Phase 2 — Dockerization](#phase-2--dockerization)
- [Phase 3 — Terraform Infrastructure](#phase-3--terraform-infrastructure)
- [Phase 4 — Deploy to AWS](#phase-4--deploy-to-aws)
- [Phase 5 — Verification](#phase-5--verification)
- [Terraform Outputs](#-terraform-outputs)
- [AWS Infrastructure Provisioned](#-aws-infrastructure-provisioned)
- [Security Group Configuration](#-security-group-configuration)
- [DockerHub Images](#-dockerhub-images)
- [Environment Variables](#-environment-variables)
- [API Reference](#-api-reference)
- [Validation Results](#-validation-results)
- [Cleanup](#-cleanup)

---

## 📖 Project Overview

This project demonstrates a **complete end-to-end DevOps deployment** of a MERN-stack e-commerce application following modern microservices architecture patterns.

The entire infrastructure — VPC, subnet, internet gateway, route tables, security groups, EC2 instance, and Elastic IP — is provisioned automatically via a single `terraform apply` command. Docker containers are pulled from DockerHub and started automatically via EC2 user-data bootstrap scripting.

**Key achievements:**

- 5 services containerized and deployed with zero manual server configuration
- Full AWS infrastructure provisioned with Terraform IaC (8 resources)
- Automated EC2 bootstrap via `user-data.sh` (Docker install → image pull → container start)
- MongoDB Atlas cloud database integration with all 4 backend services
- Docker bridge network enabling internal service discovery by container name
- Elastic IP for stable, consistent public access

---

## 🏗️ Architecture

```
DEPLOYMENT FLOW
===============
Developer → GitHub Repo → Docker Build → DockerHub Registry
      ↓
terraform apply → AWS Infrastructure → EC2 Bootstrap
      ↓
Docker Install → Pull Images → Start Containers → App Live


AWS CLOUD (ap-south-1)
=======================

VPC: ecommerce-vpc (10.0.0.0/16)
│
└── Public Subnet: 10.0.1.0/24 (ap-south-1a)
    │
    └── EC2 Instance: ecommerce-server (t3.medium, Ubuntu 22.04)
        Elastic IP: 52.66.81.49
        │
        └── Docker Host — Network: ecommerce-net (bridge)
            │
            ├── frontend        (Nginx + React)  :80
            ├── user-service    (Node.js)         :3001
            ├── product-service (Node.js)         :3002
            ├── cart-service    (Node.js)         :3003
            └── order-service   (Node.js)         :3004
                │
                └── All services ↔ MongoDB Atlas (Cloud DB)

Internet Gateway → Route Table → Public Subnet → EC2
Security Group: ports 22, 80, 3001-3004 open
```
<img width="1351" height="906" alt="image" src="https://github.com/user-attachments/assets/37a3dae7-af5d-44bb-88e7-acd0b9ff2a9d" />
---

## 🧰 Technology Stack

**Frontend**

| Technology | Purpose |
|---|---|
| React 18 | UI framework |
| React Router | Client-side routing |
| Axios | HTTP client for API calls |
| React Query | Server state management |
| Nginx | Production web server (in Docker) |

**Backend (Microservices)**

| Technology | Purpose |
|---|---|
| Node.js + Express.js | REST API framework |
| MongoDB + Mongoose | Database and ODM |
| JWT | Authentication tokens |
| Docker | Containerization |

**DevOps and Infrastructure**

| Technology | Purpose |
|---|---|
| Terraform v1.15.4 | Infrastructure as Code |
| AWS EC2 t3.medium | Compute — runs all Docker containers |
| AWS VPC | Isolated virtual network |
| AWS Security Groups | Firewall rules |
| AWS Elastic IP | Static public IP (52.66.81.49) |
| AWS Internet Gateway | Public internet connectivity |
| DockerHub | Public image registry |
| MongoDB Atlas | Managed cloud database |
| Ubuntu 22.04 LTS | EC2 operating system |

---

## 📦 Microservices

| Service | Port | Container Name | Image | Description |
|---|---|---|---|---|
| Frontend | 80 | `frontend` | `priyank0202/ecommerce-frontend` | React app served via Nginx |
| User Service | 3001 | `user-service` | `priyank0202/user-service` | Auth, JWT, user profiles |
| Product Service | 3002 | `product-service` | `priyank0202/product-service` | Catalog, categories, inventory |
| Cart Service | 3003 | `cart-service` | `priyank0202/cart-service` | Cart CRUD, item validation |
| Order Service | 3004 | `order-service` | `priyank0202/order-service` | Orders, payments, tracking |

**Docker Container Status (verified on EC2):**

```
CONTAINER ID   IMAGE                              STATUS               PORTS
9408e76c6ccc   priyank0202/frontend               Up 4 hours           0.0.0.0:80->80/tcp
bbe9d2b25ad4   priyank0202/order-service          Up 4 hours (healthy) 0.0.0.0:3004->3004/tcp
08f3d36c98e0   priyank0202/cart-service           Up 4 hours (healthy) 0.0.0.0:3003->3003/tcp
ece92d14109c   priyank0202/product-service        Up 4 hours (healthy) 0.0.0.0:3002->3002/tcp
4e7cd3781dd8   priyank0202/user-service           Up 4 hours (healthy) 0.0.0.0:3001->3001/tcp
```

---

## 📁 Project Structure

```
E-CommerceStore/
│
├── backend/
│   ├── user-service/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── middleware/
│   │   ├── server.js
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── product-service/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── server.js
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── cart-service/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── server.js
│   │   ├── package.json
│   │   └── Dockerfile
│   └── order-service/
│       ├── models/
│       ├── routes/
│       ├── server.js
│       ├── package.json
│       └── Dockerfile
│
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   ├── contexts/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── App.js
│   │   └── index.js
│   ├── package.json
│   ├── nginx.conf
│   └── Dockerfile
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars      ← gitignored, contains secrets
│   └── user-data.sh
│
├── .gitignore
├── package.json
└── README.md
```

---

## ✅ Prerequisites

| Tool | Version | Link |
|---|---|---|
| Git | Any | https://git-scm.com |
| Docker Desktop | 24+ | https://docs.docker.com/get-docker/ |
| Node.js + npm | 16+ | https://nodejs.org |
| Terraform CLI | 1.6+ | https://developer.hashicorp.com/terraform/install |
| AWS CLI | 2.x | https://aws.amazon.com/cli/ |
| DockerHub Account | — | https://hub.docker.com |
| AWS Account | — | https://aws.amazon.com |

```bash
# Verify all tools
docker --version
terraform --version
aws --version
node --version
```

**Configure AWS CLI:**

```bash
aws configure
# AWS Access Key ID:     <YOUR_KEY>
# AWS Secret Access Key: <YOUR_SECRET>
# Default region:        ap-south-1
# Default output format: json
```

---

## Phase 1 — MongoDB Atlas Setup

1. Sign up at https://www.mongodb.com/atlas
2. Create a FREE M0 Shared Cluster
3. Under Network Access, add `0.0.0.0/0` to allow EC2 connectivity
4. Create a database user with username and password
5. Copy the connection string: `mongodb+srv://<user>:<pass>@cluster.mongodb.net`
6. Create 4 databases: `ecommerce_users`, `ecommerce_products`, `ecommerce_carts`, `ecommerce_orders`

> Save your connection string — it goes into `terraform.tfvars`

---

## Phase 2 — Dockerization

**Clone the repository:**

```bash
git clone https://github.com/PriyankP2/E-CommerceStore.git
cd E-CommerceStore
```

**Backend Dockerfile (same pattern for all 4 services):**

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE <PORT>
HEALTHCHECK --interval=30s --timeout=10s --start-period=20s \
  CMD wget -qO- http://localhost:<PORT>/health || exit 1
CMD ["node", "server.js"]
```

**Frontend Dockerfile (multi-stage build):**

```dockerfile
# Stage 1: Build React app
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

ARG REACT_APP_USER_SERVICE_URL
ARG REACT_APP_PRODUCT_SERVICE_URL
ARG REACT_APP_CART_SERVICE_URL
ARG REACT_APP_ORDER_SERVICE_URL

ENV REACT_APP_USER_SERVICE_URL=$REACT_APP_USER_SERVICE_URL
ENV REACT_APP_PRODUCT_SERVICE_URL=$REACT_APP_PRODUCT_SERVICE_URL
ENV REACT_APP_CART_SERVICE_URL=$REACT_APP_CART_SERVICE_URL
ENV REACT_APP_ORDER_SERVICE_URL=$REACT_APP_ORDER_SERVICE_URL

RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**`frontend/nginx.conf`:**

```nginx
server {
    listen 80;
    root /usr/share/nginx/html;
    index index.html;
    location / {
        try_files $uri /index.html;
    }
}
```

**`.dockerignore`:**

```
node_modules
npm-debug.log
.env
.git
```

**Build all images:**

```bash
docker build -t priyank0202/user-service    ./backend/user-service
docker build -t priyank0202/product-service ./backend/product-service
docker build -t priyank0202/cart-service    ./backend/cart-service
docker build -t priyank0202/order-service   ./backend/order-service

docker build \
  --build-arg REACT_APP_USER_SERVICE_URL=http://52.66.81.49:3001 \
  --build-arg REACT_APP_PRODUCT_SERVICE_URL=http://52.66.81.49:3002 \
  --build-arg REACT_APP_CART_SERVICE_URL=http://52.66.81.49:3003 \
  --build-arg REACT_APP_ORDER_SERVICE_URL=http://52.66.81.49:3004 \
  -t priyank0202/ecommerce-frontend ./frontend
```

**Push to DockerHub:**

```bash
docker login
docker push priyank0202/user-service
docker push priyank0202/product-service
docker push priyank0202/cart-service
docker push priyank0202/order-service
docker push priyank0202/ecommerce-frontend
```
<img width="1540" height="341" alt="image" src="https://github.com/user-attachments/assets/f4b98dc0-714f-4fcc-8371-4206006d6e7a" />

https://hub.docker.com/repositories/priyank0202
---

## Phase 3 — Terraform Infrastructure

### `terraform/variables.tf`

```hcl
variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "dockerhub_username" {
  type = string
}

variable "mongo_uri_users" {
  type      = string
  sensitive = true
}

variable "mongo_uri_products" {
  type      = string
  sensitive = true
}

variable "mongo_uri_carts" {
  type      = string
  sensitive = true
}

variable "mongo_uri_orders" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
  default   = "my_super_secret_key"
}

variable "key_pair_name" {
  type    = string
  default = ""
}
```

### `terraform/main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.6"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "ecommerce_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "ecommerce-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  tags   = { Name = "ecommerce-igw" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = { Name = "ecommerce-public-subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "ecommerce-public-rt" }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ecommerce_sg" {
  name        = "ecommerce-sg"
  description = "Allow HTTP frontend + backend service ports"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP frontend"
  }

  ingress {
    from_port   = 3001
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Microservice ports"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ecommerce-sg" }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ecommerce_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ecommerce_sg.id]
  key_name               = var.key_pair_name != "" ? var.key_pair_name : null

  user_data = templatefile("${path.module}/user-data.sh", {
    dockerhub_username = var.dockerhub_username
    mongo_uri_users    = var.mongo_uri_users
    mongo_uri_products = var.mongo_uri_products
    mongo_uri_carts    = var.mongo_uri_carts
    mongo_uri_orders   = var.mongo_uri_orders
    jwt_secret         = var.jwt_secret
  })

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = { Name = "ecommerce-server" }
}

resource "aws_eip" "ecommerce_eip" {
  instance = aws_instance.ecommerce_server.id
  domain   = "vpc"
  tags     = { Name = "ecommerce-eip" }
}
```

### `terraform/user-data.sh`

```bash
#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

echo "=== EC2 Bootstrap Start: $(date) ==="

apt-get update -y
apt-get install -y ca-certificates curl gnupg

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable docker
systemctl start docker

echo "=== Docker installed ==="

docker network create ecommerce-net || true

DHUB="${dockerhub_username}"
docker pull $DHUB/user-service:latest
docker pull $DHUB/product-service:latest
docker pull $DHUB/cart-service:latest
docker pull $DHUB/order-service:latest
docker pull $DHUB/ecommerce-frontend:latest

echo "=== Images pulled ==="

docker run -d --name user-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3001:3001 \
  -e PORT=3001 \
  -e MONGODB_URI='${mongo_uri_users}' \
  -e JWT_SECRET='${jwt_secret}' \
  -e NODE_ENV=production \
  $DHUB/user-service:latest

docker run -d --name product-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3002:3002 \
  -e PORT=3002 \
  -e MONGODB_URI='${mongo_uri_products}' \
  -e NODE_ENV=production \
  $DHUB/product-service:latest

docker run -d --name cart-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3003:3003 \
  -e PORT=3003 \
  -e MONGODB_URI='${mongo_uri_carts}' \
  -e PRODUCT_SERVICE_URL=http://product-service:3002 \
  -e NODE_ENV=production \
  $DHUB/cart-service:latest

docker run -d --name order-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3004:3004 \
  -e PORT=3004 \
  -e MONGODB_URI='${mongo_uri_orders}' \
  -e USER_SERVICE_URL=http://user-service:3001 \
  -e PRODUCT_SERVICE_URL=http://product-service:3002 \
  -e CART_SERVICE_URL=http://cart-service:3003 \
  -e NODE_ENV=production \
  $DHUB/order-service:latest

docker run -d --name frontend \
  --network ecommerce-net --restart unless-stopped \
  -p 80:80 \
  $DHUB/ecommerce-frontend:latest

echo "=== All containers started: $(date) ==="
docker ps
```

### `terraform/outputs.tf`

```hcl
output "instance_public_ip" {
  value = aws_eip.ecommerce_eip.public_ip
}

output "frontend_url" {
  value = "http://${aws_eip.ecommerce_eip.public_ip}"
}

output "user_service_url" {
  value = "http://${aws_eip.ecommerce_eip.public_ip}:3001"
}

output "product_service_url" {
  value = "http://${aws_eip.ecommerce_eip.public_ip}:3002"
}

output "cart_service_url" {
  value = "http://${aws_eip.ecommerce_eip.public_ip}:3003"
}

output "order_service_url" {
  value = "http://${aws_eip.ecommerce_eip.public_ip}:3004"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/your-key.pem ubuntu@${aws_eip.ecommerce_eip.public_ip}"
}
```

### `terraform/terraform.tfvars` — gitignored

```hcl
dockerhub_username = "priyank0202"
mongo_uri_users    = "mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_users"
mongo_uri_products = "mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_products"
mongo_uri_carts    = "mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_carts"
mongo_uri_orders   = "mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_orders"
jwt_secret         = "my_super_secret_key"
key_pair_name      = "mygenassist"
```

> Never commit `terraform.tfvars` to Git. Add it to `.gitignore`.

---
<img width="1692" height="360" alt="image" src="https://github.com/user-attachments/assets/18ec1b4b-afa5-40b3-934b-6dbaa7c893d3" />
<img width="1582" height="406" alt="image" src="https://github.com/user-attachments/assets/cc11a5e5-9a20-426c-96a7-671099cdc2ec" />


## Phase 4 — Deploy to AWS

```bash
cd terraform/

terraform init      # Download AWS provider (v5.100.0)
terraform validate  # Confirm: Success! The configuration is valid.
terraform plan      # Confirm: Plan: 8 to add, 0 to change, 0 to destroy.
terraform apply     # Type 'yes' to confirm
```

EC2 launches in approximately 2 minutes. `user-data.sh` runs automatically and takes a further 3-5 minutes to install Docker and start all containers.

---

## 📊 Terraform Outputs

```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

cart_service_url    = "http://52.66.81.49:3003"
frontend_url        = "http://52.66.81.49"
instance_public_ip  = "52.66.81.49"
order_service_url   = "http://52.66.81.49:3004"
product_service_url = "http://52.66.81.49:3002"
ssh_command         = "ssh -i ~/.ssh/your-key.pem ubuntu@52.66.81.49"
user_service_url    = "http://52.66.81.49:3001"
```
<img width="723" height="233" alt="image" src="https://github.com/user-attachments/assets/013fa5c2-84b6-44af-9976-0d4c09fd59f1" />
<img width="1902" height="867" alt="image" src="https://github.com/user-attachments/assets/7860f750-4030-4545-93fe-9fdade43ceb2" />
<img width="1623" height="662" alt="image" src="https://github.com/user-attachments/assets/2636a5fd-65cb-4309-89eb-e56dbfb9b45e" />

---

## ☁️ AWS Infrastructure Provisioned

Terraform created 8 AWS resources:

| Resource | Name | Details |
|---|---|---|
| aws_vpc | ecommerce-vpc | CIDR: 10.0.0.0/16 |
| aws_subnet | ecommerce-public-subnet | CIDR: 10.0.1.0/24, AZ: ap-south-1a |
| aws_internet_gateway | ecommerce-igw | Attached to VPC |
| aws_route_table | ecommerce-public-rt | Route: 0.0.0.0/0 to IGW |
| aws_route_table_association | public_rta | Links subnet to route table |
| aws_security_group | ecommerce-sg | Ports: 22, 80, 3001-3004 |
| aws_instance | ecommerce-server | t3.medium, Ubuntu 22.04, 20GB gp3 |
| aws_eip | ecommerce-eip | Public IP: 52.66.81.49 |

**Instance ID:** `i-03cf8e01a635f6bb4`  
**VPC ID:** `vpc-0a0cd38ad2a6386f3`  
**Subnet ID:** `subnet-0fbc5927a81ad584c`  
**AMI:** `ami-07b301a23def3266d` (Ubuntu 22.04 LTS, ap-south-1)

---

## 🛡️ Security Group Configuration

Security Group: `ecommerce-sg` (`sg-0aed7cdded51735aa`)

**Inbound Rules:**

| Port | Protocol | Source | Description |
|---|---|---|---|
| 22 | TCP | 0.0.0.0/0 | SSH Access |
| 80 | TCP | 0.0.0.0/0 | HTTP Frontend |
| 3001-3004 | TCP | 0.0.0.0/0 | Microservice Ports |

**Outbound Rules:**

| Port | Protocol | Destination |
|---|---|---|
| All | All | 0.0.0.0/0 |

---

## 🐳 DockerHub Images

DockerHub namespace: https://hub.docker.com/repositories/priyank0202

```bash
# Pull any image manually
docker pull priyank0202/user-service:latest
docker pull priyank0202/ecommerce-frontend:latest
```

---

## 🔐 Environment Variables

**Frontend**

```env
REACT_APP_USER_SERVICE_URL=http://52.66.81.49:3001
REACT_APP_PRODUCT_SERVICE_URL=http://52.66.81.49:3002
REACT_APP_CART_SERVICE_URL=http://52.66.81.49:3003
REACT_APP_ORDER_SERVICE_URL=http://52.66.81.49:3004
```

**User Service**

```env
PORT=3001
MONGODB_URI=mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_users
JWT_SECRET=my_super_secret_key
NODE_ENV=production
```

**Product Service**

```env
PORT=3002
MONGODB_URI=mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_products
NODE_ENV=production
```

**Cart Service**

```env
PORT=3003
MONGODB_URI=mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_carts
PRODUCT_SERVICE_URL=http://product-service:3002
NODE_ENV=production
```

**Order Service**

```env
PORT=3004
MONGODB_URI=mongodb+srv://<user>:<pass>@cluster.mongodb.net/ecommerce_orders
USER_SERVICE_URL=http://user-service:3001
PRODUCT_SERVICE_URL=http://product-service:3002
CART_SERVICE_URL=http://cart-service:3003
NODE_ENV=production
```

---

## 📡 API Reference

### Health Checks

```bash
curl http://52.66.81.49:3001/health
# {"service":"User Service","status":"OK","port":"3001"}

curl http://52.66.81.49:3002/health
# {"service":"Product Service","status":"OK","port":"3002"}

curl http://52.66.81.49:3003/health
# {"service":"Cart Service","status":"OK","port":"3003"}

curl http://52.66.81.49:3004/health
# {"service":"Order Service","status":"OK","port":"3004"}
```

### User Service — Port 3001

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login, returns JWT |
| GET | `/api/auth/me` | Get current user |
| GET | `/api/users/profile` | Get user profile |
| PUT | `/api/users/profile` | Update user profile |

```bash
curl -X POST http://52.66.81.49:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Doe","email":"john@example.com","password":"pass1234"}'
```

### Product Service — Port 3002

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/products` | Get products with filtering |
| GET | `/api/products/:id` | Get single product |
| POST | `/api/products` | Create product (admin) |
| PUT | `/api/products/:id` | Update product (admin) |
| DELETE | `/api/products/:id` | Soft delete product (admin) |
| GET | `/api/categories` | Get all categories |

```bash
curl http://52.66.81.49:3002/api/products
curl http://52.66.81.49:3002/api/categories
```

### Cart Service — Port 3003

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/cart/:userId` | Get user's cart |
| POST | `/api/cart/:userId/items` | Add item to cart |
| PUT | `/api/cart/:userId/items/:productId` | Update cart item |
| DELETE | `/api/cart/:userId/items/:productId` | Remove item |
| DELETE | `/api/cart/:userId` | Clear entire cart |

### Order Service — Port 3004

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/orders/user/:userId` | Get user's orders |
| GET | `/api/orders/:id` | Get single order |
| POST | `/api/orders` | Create new order |
| PUT | `/api/orders/:id/status` | Update order status |
| DELETE | `/api/orders/:id` | Cancel order |
| POST | `/api/payments/process` | Process payment |

---

## Phase 5 — Verification

**Monitor bootstrap on EC2:**

```bash
ssh -i ~/.ssh/mygenassist.pem ubuntu@52.66.81.49

tail -f /var/log/user-data.log
# Wait for: === All containers started: ...

docker ps
```

**Verify inter-container networking:**

```bash
docker exec -it cart-service sh
curl http://product-service:3002/health
# {"service":"Product Service","status":"OK","port":"3002"}
exit
```

**Check logs for any errors:**

```bash
docker logs user-service
docker logs product-service
docker logs cart-service
docker logs order-service
docker logs frontend
```

---

## ✅ Validation Results

| Check | Status | Details |
|---|---|---|
| Terraform Init | ✅ Passed | AWS provider v5.100.0 installed |
| Terraform Validate | ✅ Passed | Configuration is valid |
| Terraform Plan | ✅ Passed | 8 resources to add |
| Terraform Apply | ✅ Passed | 8 resources created |
| EC2 Running | ✅ Passed | i-03cf8e01a635f6bb4, 3/3 checks passed |
| Docker Installed | ✅ Passed | Via user-data.sh bootstrap |
| Docker Network | ✅ Passed | ecommerce-net bridge created |
| All Images Pulled | ✅ Passed | 5 images from DockerHub |
| User Service | ✅ Healthy | Port 3001 |
| Product Service | ✅ Healthy | Port 3002 |
| Cart Service | ✅ Healthy | Port 3003 |
| Order Service | ✅ Healthy | Port 3004 |
| Frontend | ✅ Running | Port 80, nginx serving React |
| MongoDB Atlas | ✅ Connected | All 4 services connected |
| Inter-service DNS | ✅ Working | Bridge network name resolution |
| Public Access | ✅ Live | http://52.66.81.49 accessible |

---

## 🧹 Cleanup

> Run this after your demo to avoid ongoing AWS charges.
> t3.medium costs approximately $0.04/hr. Elastic IP costs $0.005/hr.

```bash
cd terraform/
terraform destroy
# Type 'yes' to confirm

# Removes: EC2, EIP, VPC, Subnet, Security Group, IGW, Route Table, RT Association
```

---

## 🔑 Key Design Decisions

**Infrastructure as Code** — 100% reproducible with `terraform apply`. No manual AWS Console clicks required.

**Automated bootstrap** — `user-data.sh` handles full Docker setup on EC2 first boot. No SSH needed for deployment.

**Docker bridge network** — Internal service discovery by container name (`http://product-service:3002`) without exposing internal ports publicly.

**Elastic IP** — Stable public IP that survives EC2 stop/start cycles. Frontend URLs stay consistent.

**Multi-stage Docker build** — Frontend image is lean (94.9 MB) because the builder stage is discarded and only the nginx+static files are shipped.

**Health checks** — All backend containers have `HEALTHCHECK` defined, visible in `docker ps` as `(healthy)`.

**Sensitive variables** — MongoDB URIs and JWT secret are marked `sensitive = true` in Terraform, hiding them from `plan` and `apply` output logs.

---

## 📎 References

| Resource | Link |
|---|---|
| GitHub Repository | https://github.com/PriyankP2/E-CommerceStore |
| DockerHub Images | https://hub.docker.com/repositories/priyank0202 |
| Terraform AWS Provider | https://registry.terraform.io/providers/hashicorp/aws |
| MongoDB Atlas | https://www.mongodb.com/atlas |
| Docker Documentation | https://docs.docker.com |
| AWS EC2 Documentation | https://docs.aws.amazon.com/ec2 |

---

**Built with Terraform, Docker, AWS EC2, and the MERN Stack**

![GitHub](https://img.shields.io/badge/GitHub-PriyankP2-181717?style=flat-square&logo=github)
![DockerHub](https://img.shields.io/badge/DockerHub-priyank0202-2496ED?style=flat-square&logo=docker)
