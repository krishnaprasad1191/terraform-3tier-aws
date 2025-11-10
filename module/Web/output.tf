output "Web_SG_id" {
  value = aws_security_group.Web_SG.id
}

output "ami_id" {
  value = data.aws_ami.Ubuntu_AMI.id
}

output "Keypair_name" {
  value = data.aws_key_pair.Keypair.key_name
}