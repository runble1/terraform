# ====================
#
# Output
#
# ====================
# apply後にElastic IPのパブリックIPを出力する
output "public_ip" {
  value = aws_eip.myElasticIP.public_ip
}


output "operation_instance_id" {
  value = aws_instance.myEC2.id
}
