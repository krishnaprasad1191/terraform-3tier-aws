variable "Internet" {
    type = string
    default = "0.0.0.0/0"
}

variable "vpc_id" { type = string }

variable "public_subnet1_id" { type = string }
variable "public_subnet2_id" { type = string }

variable "AZ1" { type = string }
variable "AZ2" { type = string }
variable "AZ3" { type = string }

variable "AMI" {type = string}
variable "LT_name" { type = string }
variable "instance_type"{ type= string }