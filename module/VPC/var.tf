variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "Name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "Pub_Subnet01_cidr" {
  type = string
}
variable "AZ1" {
  type = string
}