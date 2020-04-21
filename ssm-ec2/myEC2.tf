# ====================
#
# IAM Role
#
# ====================
resource "aws_iam_instance_profile" "instance_role" {
  name  = "instance_role"
  roles = [aws_iam_role.instance_role.name]
}

resource "aws_iam_role" "instance_role" {
  name               = "instance_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "instance_role_policy" {
  name   = "instance_role_policy"
  role   = aws_iam_role.instance_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
EOF
}


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
  #key_name               = aws_key_pair.myKeyPair.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_role.instance_role.id
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
