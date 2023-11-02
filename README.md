# flink-on-eks
Flink on EKS

## Overview

The purpose of this repository is to be a tutorial for how to use Terraform to provision an Amazon Elastic Kubernetes Service (EKS) cluster, then deploy Apache Flink's Kubernetes Operator, and manage/update Apache Flink jobs as a playground for testing Flink's streaming capabilities.  The spirit is to keep it as light-weight as possible, by only creating the minimum resources required to accomplish our goal.

## Anti-Overview

The simplest/fastest way to accomplish our goal is to use an existing Blueprint from AWS Labs, like [this Flink example](https://github.com/awslabs/data-on-eks/tree/main/streaming/flink).  It'll stand up everything we need and a whole lot more that we don't.  But where is the fun in that?  It exclusively uses pre-built modules to do all the heavy lifting.  The spirit of this repository is to understand all of the components that it takes to accomplish our goal of Flink on EKS.

## Requirements

This projects expects that you have a few things installed on your system.
* terraform - A command like tool for provisioning resources in cloud providers.  See https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli for information on installing it.
* kubectl - A command line tool for working with Kubernetes clusters.  See https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html for information on installing it.
* helm - A command line tool to manage Kubernetes applications. See https://helm.sh/docs/intro/install/ for information on installing it.
* aws-cli -  A command like tool for working with AWS services.  See https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html for information on installing it.
* AWS Account - A user account set up in Amazon Web Services.  See https://aws.amazon.com/resources/create-account/ for information on creating it.

## Quick Start

Initialize the terraform environment:
```bash
cd provision
terraform init --upgrade
```

View the plan of resources (i.e. the EKS cluster, etc) to be created (which saves the plan file):
```bash
terraform plan -out=tfplan -input=false
```

Apply the plan file to create the resources (i.e. the EKS cluster, etc): (takes ~15-20 minutes)
```bash
terraform apply -input=false tfplan
```

Configure our local `kubectl` to connect to the new EKS cluster:

```bash
aws eks update-kubeconfig --name adam-flink-on-eks --region us-east-2

```

Deploy the latest Flink Operator into the EKS cluster:

```bash
helm repo add flink-operator-repo https://downloads.apache.org/flink/flink-kubernetes-operator-1.6.1/
helm install flink-kubernetes-operator flink-operator-repo/flink-kubernetes-operator
```

Now that we have a place to test our flink jobs, lets submit a sample job and do some port-forwarding to be able to view the results:

```bash
kubectl create -f https://raw.githubusercontent.com/apache/flink-kubernetes-operator/release-1.6/examples/basic.yaml
kubectl port-forward svc/basic-example-rest 8081
```

View the Flink Dashboard for the job we just ran at [localhost:8081](localhost:8081).

When we're done, we can stop our sample job:

```bash
kubectl delete flinkdeployment/basic-example
```

## Quick Stop

When we are all done testing our Flink Jobs, and have no immediate need for our EKS cluster, we should tear down all of the resources we created.  This will save us money by not letting an idle cluster burn our cash.  We can always spin all of the resources back up when we're ready to run some more Flink jobs.

```bash
terraform destroy -auto-approve
```


## Components

<< Insert diagram of overview of components >>
Virtual Private Cloud (VPC) - across 3 Availability Zones (AZs), with 3 public & 3 private subnets, 1 of each in each of the AZs.
Elastic Cloud Compute (EC2) Bastion - an EC2 host for isolationg
Elastic Kubernetes Service (EKS)
Apache Flink Kubernetes Operator
Example Apache Flink job

### VPC

What is a VPC?  As a fundamental building block of the AWS cloud infrastructure, it is a logically isolated section of the AWS cloud where you can launch AWS resources that you define.  The VPC allows the user to define/control the network topology, IP address range, & network gateways, making it easy to configure/manage the network infrastructure.  For this tutorial, we will be configuring a CIDR, Subnets, Internet Gateways, NAT Gateway, NACLs, & Security Groups.

#### CIDR

A CIDR stands for Classless Inter-Domain Routing.  It is a way of specifying IP address and their associated routing prefix.  More specifically, it's a notation that allows us to represent and IP address range using a single IP address and a slash followed by the number of bits in the network prefix.  Our tutorial will use the CIDR 10.0.0.0/16 which means we will have 65,531 IP addresses available in our VPC.

#### Subnet

A Subnet is a range of IP addresses, that our VPC can allocate resources to.  They are created within a VPC and are associated with a particular Availability Zone (AZ).  Each subnet can have up to 256 IP addresses.  They are used to segregate resources and apply network security policies.  Typically, subnets are divided into either public or private accessible, depending on their placement in the overall architecture.

#### Internet Gateway
An Internet Gateway allows communication between our VPC and the internet.  It enables resources in our public subnet(s) to connect to the internet.  It is also a target in our Routing Tables for internet-routable traffic.

#### NAT Gateway
A Network Address Translation (NAT) gateway is a service that maps private addresses of resources and allows them to connect to the outside world, and limits external services from connecting with those private addresses.  NAT gateways can either be public or private, and work in conjuction with the Internet Gateway

#### Security Group
A Security Group controls traffic that is allowed to reach/leave the resources it is associated with.  It primarily allows control of network access to a VPC.

### EC2 Bastion

(This isn't terraformed yet) The idea is that we use an EC2 instance in one of the public subnets we've  had terraform provision.  Then we'd have terraform create (or we could manually provide) an SSH key pair, so that we'd be able to ssh into the bastion host (or use an ssh tunnel) to do our kubectl commands.  Or even better, we use an AWS Auto-Scaling group for our EC2 instance, with a min group size of 1.  This way, if our EC2 host is ever degraded/terminated, a new one will be automatically created in its place.  Will also need to ensure the EKS control plane security groups allow ingress traffic on port 443 from the bastion.

### Elastic Kubernetes Service (EKS)

### Apache Flink Kubernetes Operator

### Example Apache Flink job

### Monitoring Flink