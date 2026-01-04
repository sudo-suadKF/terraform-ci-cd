resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

   tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "EC2_SG" {
  description = "EC2 instance security group"
  vpc_id = aws_vpc.main.id

}

resource "aws_vpc_security_group_ingress_rule" "Ingress_HTTP" {
  description = "Allows HTTP from internet"
  security_group_id = aws_security_group.EC2_SG.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "Ingress_HTTPS" {
  description = "Allows HTTPS from internet"
  security_group_id = aws_security_group.EC2_SG.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "Ingress_SSH" {
  description = "Allows SSH from anywhere"
  security_group_id = aws_security_group.EC2_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "Egress" {
  description = "Allows all traffic as outbound"
  security_group_id = aws_security_group.EC2_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "EC2" {
  ami = "ami-0a0ff88d0f3f85a14"
  instance_type = "t2.micro"
  key_name = "Networking Task"
  availability_zone = "eu-west-2a"
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.EC2_SG.id ]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y nginx
    sudo systemctl enable nginx
    sudo systemctl start nginx
    echo "<h1>$(hostname -f)</h1>" | sudo tee /var/www/html/index.html
    sudo systemctl reload nginx
  EOF
}