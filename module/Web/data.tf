data "aws_key_pair" "Keypair" {
  key_name = "3tier_Web_key"
}

data "aws_ami" "Ubuntu_AMI" {
  owners = ["099720109477"]  # Canonical (Ubuntu official account)
  most_recent = true
  name_regex = "^ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-.*"

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}