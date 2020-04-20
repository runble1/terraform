# ====================
#
# AMI
#
# ====================
# 最新版のAmazonLinux2のAMI情報
data "aws_ami" "myAMI" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ====================
#
# EC2 Instance
#
# ====================
resource "aws_instance" "myEC2" {
  ami                    = data.aws_ami.myAMI.image_id
  vpc_security_group_ids = [aws_security_group.mySecurityGroup.id]
  subnet_id              = aws_subnet.mySubnet.id
  key_name               = aws_key_pair.myKeyPair.id
  instance_type          = "t2.micro"
  tags = {
    Name = "myEC2"
  }
}

# ====================
#
# Elastic IP
#
# ====================
resource "aws_eip" "myElasticIP" {
  instance = aws_instance.myEC2.id
  vpc      = true
}

# ====================
#
# Key Pair
#
# ====================
resource "aws_key_pair" "myKeyPair" {
  key_name   = "myKeyPair"
  public_key = file("./myKeyPair.pub") # 先程`ssh-keygen`コマンドで作成した公開鍵を指定
}
