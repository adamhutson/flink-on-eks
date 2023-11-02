locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    terraform   = "true"
    github-repo = var.github-repo
  }
  vpc_name = "${var.project-name}-vpc"
}