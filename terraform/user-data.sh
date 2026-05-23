#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1

# 1. System updates
apt-get update -y
apt-get install -y ca-certificates curl gnupg

# 2. Install Docker
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

# 3. Create Docker network
docker network create ecommerce-net || true

# 4. Pull all images
DHUB="${dockerhub_username}"
docker pull $DHUB/user-service:latest
docker pull $DHUB/product-service:latest
docker pull $DHUB/cart-service:latest
docker pull $DHUB/order-service:latest
docker pull $DHUB/ecommerce-frontend:latest

# 5. Run backend services
docker run -d --name user-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3001:3001 \
  -e PORT=3001 \
  -e MONGODB_URI='${mongo_uri_users}' \
  -e JWT_SECRET='${jwt_secret}' \
  $DHUB/user-service:latest

docker run -d --name product-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3002:3002 \
  -e PORT=3002 \
  -e MONGODB_URI='${mongo_uri_products}' \
  $DHUB/product-service:latest

docker run -d --name cart-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3003:3003 \
  -e PORT=3003 \
  -e MONGODB_URI='${mongo_uri_carts}' \
  -e PRODUCT_SERVICE_URL=http://product-service:3002 \
  $DHUB/cart-service:latest

docker run -d --name order-service \
  --network ecommerce-net --restart unless-stopped \
  -p 3004:3004 \
  -e PORT=3004 \
  -e MONGODB_URI='${mongo_uri_orders}' \
  -e CART_SERVICE_URL=http://cart-service:3003 \
  -e PRODUCT_SERVICE_URL=http://product-service:3002 \
  -e USER_SERVICE_URL=http://user-service:3001 \
  $DHUB/order-service:latest

# 6. Run frontend
docker run -d --name frontend \
  --network ecommerce-net --restart unless-stopped \
  -p 80:80 \
  $DHUB/ecommerce-frontend:latest

echo "=== All containers started at $(date) ==="
docker ps
