variable "private_subnet1_id" { type = string }
variable "private_subnet2_id" { type = string }
variable "vpc_id" {type = string}
variable "AZ1" { type = string }
variable "AZ2" { type = string }
variable "AZ3" { type = string }
variable "Web_Secgrp_id" {}
variable "AMI" {type = string}
variable "LT_name" { type = string }
variable "instance_type"{ type= string }
variable "key_name" {
  type = string
}
