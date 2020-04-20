output "httpbin1" {
  value = aws_eip.this[0].public_ip
}

output "httpbin2" {
  value = aws_eip.this[1].public_ip
}