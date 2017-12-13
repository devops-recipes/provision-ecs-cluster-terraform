#========================== AMI VPC =============================
# Define a vpc
resource "aws_vpc" "ami_vpc" {
  cidr_block = "${var.ami_network_cidr}"
  tags {
    Name = "${var.ami_vpc}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "ami_ig" {
  vpc_id = "${aws_vpc.ami_vpc.id}"
  tags {
    Name = "ami_ig"
  }
}

# Public subnet
resource "aws_subnet" "ami_public_sn" {
  vpc_id = "${aws_vpc.ami_vpc.id}"
  cidr_block = "${var.ami_public_cidr}"
  availability_zone = "${lookup(var.availability_zone, var.region)}"
  tags {
    Name = "ami_public_sn"
  }
}

# Routing table for public subnet
resource "aws_route_table" "ami_public_sn_rt" {
  vpc_id = "${aws_vpc.ami_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ami_ig.id}"
  }
  tags {
    Name = "ami_public_sn_rt"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "ami_public_sn_rt_assn" {
  subnet_id = "${aws_subnet.ami_public_sn.id}"
  route_table_id = "${aws_route_table.ami_public_sn_rt.id}"
}

# ECS Instance Security group
resource "aws_security_group" "ami_public_sg" {
  name = "ami_public_sg"
  description = "AMI public access security group"
  vpc_id = "${aws_vpc.ami_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [
      "${var.ami_public_cidr}"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "ami_public_sg"
  }
}

#========================== TEST VPC =============================

# Declare the data source
data "aws_availability_zones" "available" {}


# Define a vpc
resource "aws_vpc" "test_vpc" {
  cidr_block = "${var.test_network_cidr}"
  tags {
    Name = "${var.test_vpc}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "test_ig" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  tags {
    Name = "test_ig"
  }
}

# Public subnet 1
resource "aws_subnet" "test_public_sn_01" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${var.test_public_01_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  # availability_zone = "${lookup(var.availability_zone, var.region)}"
  tags {
    Name = "test_public_sn_01"
  }
}

# Public subnet 2
resource "aws_subnet" "test_public_sn_02" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  cidr_block = "${var.test_public_02_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  # availability_zone = "${lookup(var.availability_zone, var.region)}"
  tags {
    Name = "test_public_sn_02"
  }
}

# Routing table for public subnet 1
resource "aws_route_table" "test_public_sn_rt_01" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_ig.id}"
  }
  tags {
    Name = "test_public_sn_rt_01"
  }
}

# Associate the routing table to public subnet 1
resource "aws_route_table_association" "test_public_sn_rt_01_assn" {
  subnet_id = "${aws_subnet.test_public_sn_01.id}"
  route_table_id = "${aws_route_table.test_public_sn_rt_01.id}"
}

# Routing table for public subnet 2
resource "aws_route_table" "test_public_sn_rt_02" {
  vpc_id = "${aws_vpc.test_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test_ig.id}"
  }
  tags {
    Name = "test_public_sn_rt_02"
  }
}

# Associate the routing table to public subnet 2
resource "aws_route_table_association" "test_public_sn_rt_assn_02" {
  subnet_id = "${aws_subnet.test_public_sn_02.id}"
  route_table_id = "${aws_route_table.test_public_sn_rt_02.id}"
}

# ECS Instance Security group
resource "aws_security_group" "test_public_sg" {
  name = "test_public_sg"
  description = "Test public access security group"
  vpc_id = "${aws_vpc.test_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [
      "${var.test_public_01_cidr}",
      "${var.test_public_02_cidr}"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "test_public_sg"
  }
}

#========================== PROD VPC =============================
# Define a vpc
resource "aws_vpc" "prod_vpc" {
  cidr_block = "${var.prod_network_cidr}"
  tags {
    Name = "${var.prod_vpc}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "prod_ig" {
  vpc_id = "${aws_vpc.prod_vpc.id}"
  tags {
    Name = "prod_ig"
  }
}

## Public subnet
#resource "aws_subnet" "prod_public_sn" {
#  vpc_id = "${aws_vpc.prod_vpc.id}"
#  cidr_block = "${var.prod_public_cidr}"
#  availability_zone = "${lookup(var.availability_zone, var.region)}"
#  tags {
#    Name = "prod_public_sn"
#  }
#}
#
## Routing table for public subnet
#resource "aws_route_table" "prod_public_sn_rt" {
#  vpc_id = "${aws_vpc.prod_vpc.id}"
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = "${aws_internet_gateway.prod_ig.id}"
#  }
#  tags {
#    Name = "prod_public_sn_rt"
#  }
#}
#
## Associate the routing table to public subnet
#resource "aws_route_table_association" "prod_public_sn_rt_assn" {
#  subnet_id = "${aws_subnet.prod_public_sn.id}"
#  route_table_id = "${aws_route_table.prod_public_sn_rt.id}"
#}

# Public subnet 1
resource "aws_subnet" "prod_public_sn_01" {
  vpc_id = "${aws_vpc.prod_vpc.id}"
  cidr_block = "${var.prod_public_01_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  # availability_zone = "${lookup(var.availability_zone, var.region)}"
  tags {
    Name = "prod_public_sn_01"
  }
}

# Public subnet 2
resource "aws_subnet" "prod_public_sn_02" {
  vpc_id = "${aws_vpc.prod_vpc.id}"
  cidr_block = "${var.prod_public_02_cidr}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  # availability_zone = "${lookup(var.availability_zone, var.region)}"
  tags {
    Name = "prod_public_sn_02"
  }
}

# Routing table for public subnet 1
resource "aws_route_table" "prod_public_sn_rt_01" {
  vpc_id = "${aws_vpc.prod_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.prod_ig.id}"
  }
  tags {
    Name = "prod_public_sn_rt_01"
  }
}

# Associate the routing table to public subnet 1
resource "aws_route_table_association" "prod_public_sn_rt_01_assn" {
  subnet_id = "${aws_subnet.prod_public_sn_01.id}"
  route_table_id = "${aws_route_table.prod_public_sn_rt_01.id}"
}

# Routing table for public subnet 2
resource "aws_route_table" "prod_public_sn_rt_02" {
  vpc_id = "${aws_vpc.prod_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.prod_ig.id}"
  }
  tags {
    Name = "prod_public_sn_rt_02"
  }
}

# Associate the routing table to public subnet 2
resource "aws_route_table_association" "prod_public_sn_rt_assn_02" {
  subnet_id = "${aws_subnet.prod_public_sn_02.id}"
  route_table_id = "${aws_route_table.prod_public_sn_rt_02.id}"
}

# ECS Instance Security group
resource "aws_security_group" "prod_public_sg" {
  name = "prod_public_sg"
  description = "Prod public access security group"
  vpc_id = "${aws_vpc.prod_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = [
      "${var.prod_public_01_cidr}",
      "${var.prod_public_02_cidr}"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "prod_public_sg"
  }
}
