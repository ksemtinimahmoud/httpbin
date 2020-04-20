output "httpbin1" {
  value = aws_instance.httpbin[0].public_ip
}

output "httpbin2" {
  value = aws_instance.httpbin[1].public_ip
}