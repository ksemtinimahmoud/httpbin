locals {
  user_data = <<EOF
#!/bin/bash
# redirect port 80 -> 8080, in order to not specify port 8080 explicitly.
iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
# Next line is to have iptables survive reboot, just in case.
service iptables save
# Install httpbin
apt-get update &&  apt-get install -y python-httpbin;
# Run httpbin on port 8080
gunicorn -b 0.0.0.0:8080 httpbin:app -k gevent;
EOF
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_eip" "this" {
  count    = var.instance_count
  vpc      = true
  instance = aws_instance.httpbin[count.index].id
}

# Using most recent Ubuntu 18.04 image as requested by the Home task
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-*",
    ]
  }
}

resource "aws_instance" "httpbin" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  # Make the instances running on separate subnets
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[count.index]
  user_data_base64            = base64encode(local.user_data)
  associate_public_ip_address = true
  tags = {
    Name  = "httpbin-${count.index + 1}"
  }
}
