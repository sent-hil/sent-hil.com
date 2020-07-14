# -----------------------------------------------------------------------------
# Subnet group for private subnets
# -----------------------------------------------------------------------------
resource "aws_db_subnet_group" "maindb_subnet_group" {
  name        = "db_subnets_group"
  description = "${var.project} vpc"
  subnet_ids  = [
    aws_subnet.priv_subnet[0].id,
    aws_subnet.priv_subnet[1].id
  ]

  tags = {
    Name = "main_db_subnet_group"
  }
}

# -----------------------------------------------------------------------------
# Postgres RDS instance in private subnet.
# -----------------------------------------------------------------------------
resource "aws_db_instance" "maindb" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "9.6.11"
  instance_class         = "db.t2.micro"
  name                   = "maindb"
  identifier             = "maindb"
  username               = "maindb"
  password               = "thenewnew"
  db_subnet_group_name   = aws_db_subnet_group.maindb_subnet_group.name
  vpc_security_group_ids = [
    aws_security_group.db_vpc_only.id,
    aws_security_group.allow_outbound_internet.id
  ]

  tags  = {
    Name = "maindb"
  }
}

# -----------------------------------------------------------------------------
# Security group for instances to connect to DB.
# -----------------------------------------------------------------------------
resource "aws_security_group" "db_vpc_only" {
  vpc_id      = aws_vpc.vpc.id
  name        = "db_vpc_only"
  description = "Allow private subnets to connect to DB"

  ingress {
    description = "5432 from both vpc subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [
      aws_subnet.pub_subnet.cidr_block,
    ]
  }

  tags = {
    Name = "Allow inbound VPC, outbound to internet"
  }
}
