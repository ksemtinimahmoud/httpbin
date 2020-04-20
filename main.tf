module "httpbin"{
  source         = "./modules/ec2-httpbin"
  instance_count = 2
  instance_type  = "t2.micro"
}