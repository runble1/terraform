# ====================
#
# EC2
#
# ====================
resource "aws_instance" "a" {
  ami                    = "ami-0c3fd0f5d33134a76"
  vpc_security_group_ids = [aws_security_group.for_webserver_ec2.id]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_a.id
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install -y docker
service docker start
docker pull bkimminich/juice-shop
docker run -d -p 80:3000 bkimminich/juice-shop
  EOF
}

resource "aws_instance" "c" {
  ami                    = "ami-0c3fd0f5d33134a76"
  vpc_security_group_ids = [aws_security_group.for_webserver_ec2.id]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_c.id
  user_data              = <<EOF
#!/bin/bash
yum update -y
yum install -y docker
service docker start
docker pull bkimminich/juice-shop
docker run -d -p 80:3000 bkimminich/juice-shop
  EOF
}

# ====================
#
# Security Group
#
# ====================
resource "aws_security_group" "for_webserver_ec2" {
  name   = "for-ec2"
  vpc_id = aws_vpc.example.id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
