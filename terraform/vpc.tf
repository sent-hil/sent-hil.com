# -----------------------------------------------------------------------------
# VPC that will contain all the resources created.
# -----------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/22"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project}"
  }
}

# -----------------------------------------------------------------------------
# 2 private subnets for RDS.
# -----------------------------------------------------------------------------
resource "aws_subnet" "priv_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index+1}.0/24"
  count             = 2

  # RDS requires you have 2 diff. availability zones.
  availability_zone = "${var.aws_region}${count.index == 0 ? "b" : "a"}"

  tags = {
    Name = "${var.project} priv subnet ${count.index+1}"
  }
}

# -----------------------------------------------------------------------------
# 1 public subnet for the instance.
# -----------------------------------------------------------------------------
resource "aws_subnet" "pub_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.3.0/24"

  # TODO: does this matter which availability zone this is in?
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "${var.project} pub subnet 1"
  }
}

# -----------------------------------------------------------------------------
# Internet gateway & route associations for private subnet.
# -----------------------------------------------------------------------------
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project} ig 1"
  }
}

resource "aws_route_table" "pub_route_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "${var.project} pub route to internet"
  }
}

resource "aws_route_table_association" "pub_route_1_pub_subnet_1" {
  route_table_id = aws_route_table.pub_route_1.id
  subnet_id      = aws_subnet.pub_subnet.id
}
