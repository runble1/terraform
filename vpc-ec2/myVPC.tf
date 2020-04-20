# ====================
#
# VPC
#
# ====================
resource "aws_vpc" "myVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "myVPC"
  }
}

# ====================
#
# Subnet
#
# ====================
resource "aws_subnet" "mySubnet" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.myVPC.id
  # trueにするとインスタンスにパブリックIPアドレスを自動的に割り当ててくれる
  map_public_ip_on_launch = true
  tags = {
    Name = "mySubnet"
  }
}

# ====================
#
# Internet Gateway
#
# ====================
resource "aws_internet_gateway" "myGW" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = "myGW"
  }
}

# ====================
#
# Route Table
#
# ====================
resource "aws_route_table" "myRouteTable" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = "myRouteTable"
  }
}
resource "aws_route" "myRoute" {
  gateway_id             = aws_internet_gateway.myGW.id
  route_table_id         = aws_route_table.myRouteTable.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route_table_association" "myRouteTableAssociation" {
  subnet_id      = aws_subnet.mySubnet.id
  route_table_id = aws_route_table.myRouteTable.id
}


# ====================
#
# Security Group
#
# ====================
resource "aws_security_group" "mySecurityGroup" {
  vpc_id = aws_vpc.myVPC.id
  name   = "mySecurityGroup"
  tags = {
    Name = "mySecurityGroup"
  }
}
# インバウンドルール(ssh接続用)
resource "aws_security_group_rule" "in_ssh" {
  security_group_id = aws_security_group.mySecurityGroup.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

# インバウンドルール(pingコマンド用)
resource "aws_security_group_rule" "in_icmp" {
  security_group_id = aws_security_group.mySecurityGroup.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
}

# インバウンドルール(proxy用)
resource "aws_security_group_rule" "in_proxy" {
  security_group_id = aws_security_group.mySecurityGroup.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3128
  to_port           = 3128
  protocol          = "tcp"
}

# アウトバウンドルール(全開放)
resource "aws_security_group_rule" "out_all" {
  security_group_id = aws_security_group.mySecurityGroup.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}
