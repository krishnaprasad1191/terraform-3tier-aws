variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "Vpc_Name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "Public_Subnets" {
  type = map(object({
    cidr = string
    az = string 
  }))
}

variable "Private_Subnets" {
  type = map(object({
    cidr = string
    az = string 
  }))
}

variable "Internet" {
  type = string
  default = "0.0.0.0/0"
}