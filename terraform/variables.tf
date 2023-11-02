variable "region" {
  type = string
}

variable "project-name" {
  type = string
}

variable "github-repo" {
  type    = string
  default = "adamhutson/flink-on-eks"
}

variable "vpc-cidr-block" {
  type = string
}

variable "public-subnets-cidr-blocks" {
  type = list(string)
}

variable "private-subnets-cidr-blocks" {
  type = list(string)
}

variable "public-subnet-1-cidr-block" {
  type = string
}

variable "public-subnet-2-cidr-block" {
  type = string
}

variable "public-subnet-3-cidr-block" {
  type = string
}

variable "private-subnet-1-cidr-block" {
  type = string
}

variable "private-subnet-2-cidr-block" {
  type = string
}

variable "private-subnet-3-cidr-block" {
  type = string
}

variable "ec2-bastion-public-key-path" {
  type = string
}

variable "ec2-bastion-private-key-path" {
  type = string
}

variable "ec2-bastion-ingress-ip-1" {
  type = string
}

variable "bastion-bootstrap-script-path" {
  type = string
}