project-name                = "adam-flink-on-eks"
region                      = "us-east-2"
vpc-cidr-block              = "10.0.0.0/16"
public-subnets-cidr-blocks  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
private-subnets-cidr-blocks = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

public-subnet-1-cidr-block = "10.0.0.0/24"
public-subnet-2-cidr-block = "10.0.1.0/24"
public-subnet-3-cidr-block = "10.0.2.0/24"

private-subnet-1-cidr-block = "10.0.3.0/24"
private-subnet-2-cidr-block = "10.0.4.0/24"
private-subnet-3-cidr-block = "10.0.5.0/24"

ec2-bastion-public-key-path   = "../secrets/ec2-bastion-key-pair.pub"
ec2-bastion-private-key-path  = "../secrets/ec2-bastion-key-pair.pem"
ec2-bastion-ingress-ip-1      = "0.0.0.0/0"
bastion-bootstrap-script-path = "../scripts/bastion-bootstrap.sh"