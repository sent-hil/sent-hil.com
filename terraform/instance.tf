# -----------------------------------------------------------------------------
# Public facing Dokku instance.
# -----------------------------------------------------------------------------
resource "aws_instance" "instance_1" {
  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.keypair_name
  subnet_id                   = aws_subnet.pub_subnet.id

  root_block_device  {
    volume_size = 30
  }

  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_outbound_internet.id,
    aws_security_group.allow_inbound_http.id
  ]

  # `tail -f /var/log/cloud-init-output.log` to see output of below commands
  user_data = <<EOF
#!/bin/bash
sudo apt-get update
wget https://raw.githubusercontent.com/dokku/dokku/v0.20.4/bootstrap.sh;
sudo DOKKU_TAG=v0.20.4 bash bootstrap.sh
  EOF

  tags = {
    Name = "${var.project}-1"
  }
}

# -----------------------------------------------------------------------------
# Security group so you can connect to the instance.
# -----------------------------------------------------------------------------
resource "aws_security_group" "allow_ssh" {
  vpc_id      = aws_vpc.vpc.id
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from my computer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.personal_ip}/32"]
  }

  tags = {
    Name = "Allow SSH from my ip"
  }
}

# -----------------------------------------------------------------------------
# Security group to let instance and RDS connect to internet.
# -----------------------------------------------------------------------------
resource "aws_security_group" "allow_outbound_internet" {
  vpc_id      = aws_vpc.vpc.id
  name        = "allow_outbound_internet"
  description = "Allow outbound internet traffic from instances"

  egress {
    description = "Internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow outbound internet"
  }
}

# -----------------------------------------------------------------------------
# Security group to allow only inbound http and https access to instance.
# -----------------------------------------------------------------------------
resource "aws_security_group" "allow_inbound_http" {
  vpc_id      = aws_vpc.vpc.id
  name        = "allow_inbound_http"
  description = "Allow HTTP/HTTPS inbound traffic"

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP/HTTPS inbound traffic"
  }
}

# -----------------------------------------------------------------------------
# Static ip for instance.
# -----------------------------------------------------------------------------
resource "aws_eip" "instance_1_static_ip" {
  instance = aws_instance.instance_1.id
  vpc      = true

  tags = {
    Name = "${var.project} instance-1 static ip"
  }
}
