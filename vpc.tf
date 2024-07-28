# CrateVPC,Subnets,Internet Gateways, Security Group

resource "aws_vpc" "awstfvpc" {
  cidr_block       = "${var.public_subnets}" 

  tags = {
    Name = "aws-tf-vpc"
  }
}

resource "aws_internet_gateway" "IGW1" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.awstfvpc.id               # vpc_id will be generated after we create VPC
}


resource "aws_subnet" "publicsubnetstf" {    # Creating Public Subnets
   vpc_id =  aws_vpc.awstfvpc.id
   cidr_block = "${var.public_subnets}"        # CIDR block of public subnets
}


resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.awstfvpc.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW1.id
     }
}

resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnetstf.id
    route_table_id = aws_route_table.PublicRT.id
}

resource "aws_security_group" "vpc_security_tf" {
  name        = "aws_tf_simplek8s"
  description = "Secuirty Group for tf Instances inbound traffic"
  vpc_id      = aws_vpc.awstfvpc.id

  tags = {
    Name = "k8s_secuirty_tf"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.vpc_security_tf.id
  cidr_ipv4   = var.public_snets
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.vpc_security_tf.id

  cidr_ipv4   = var.public_snets
  from_port   = 443 
  ip_protocol = "tcp"
  to_port     = 443 
}
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.vpc_security_tf.id

  cidr_ipv4   = var.public_snets
  from_port   = 22 
  ip_protocol = "tcp"
  to_port     = 22 
}
resource "aws_vpc_security_group_ingress_rule" "dash" {
  security_group_id = aws_security_group.vpc_security_tf.id

  cidr_ipv4   = var.public_snets
  from_port   = 30002 
  ip_protocol = "tcp"
  to_port     = 30002 
}
resource "aws_vpc_security_group_ingress_rule" "k8srule" {
  security_group_id = aws_security_group.vpc_security_tf.id

  cidr_ipv4   = var.public_snets
  from_port   = 6443 
  ip_protocol = "tcp"
  to_port     = 6443 
}

resource "aws_vpc_security_group_ingress_rule" "k8sdashrule" {
  security_group_id = aws_security_group.vpc_security_tf.id

  cidr_ipv4   = var.public_snets
  from_port   = 8443 
  ip_protocol = "tcp"
  to_port     = 8443 
}
resource "aws_vpc_security_group_egress_rule" "egre_rule" {
  security_group_id = aws_security_group.vpc_security_tf.id

  cidr_ipv4   = var.public_snets
  ip_protocol = "-1"
}
