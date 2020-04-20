# ====================
#
# EC2 Instance
#
# ====================
data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "myEC2" {
  ami                    = data.aws_ssm_parameter.amzn2_ami.value
  vpc_security_group_ids = [aws_security_group.mySecurityGroup.id]
  subnet_id              = aws_subnet.mySubnet.id
  key_name               = aws_key_pair.myKeyPair.id
  instance_type          = "t2.micro"
  tags = {
    Name = "${terraform.workspace}-myEC2"
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
