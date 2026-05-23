output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_eip.ecommerce_eip.public_ip
}

output "frontend_url" {
  description = "URL to access the frontend"
  value       = "http://${aws_eip.ecommerce_eip.public_ip}"
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
  description = "SSH into the instance"
  value       = "ssh -i ~/.ssh/your-key.pem ubuntu@${aws_eip.ecommerce_eip.public_ip}"
}
