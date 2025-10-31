variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "MyVPC"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "Pubsub01_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "Pubsub02_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "Pvtsub01_cidr" {
  type = string
  default = "10.0.6.0/24"
}

variable "Pvtsub02_cidr" {
  type = string
  default = "10.0.7.0/24"
}

variable "availability_zones" {
  description = "Map of availability zones"
  type        = map(string)
  default = {
    AZ_01 = "us-east-1a"
    AZ_02 = "us-east-1b"
    AZ_03 = "us-east-1c"
  }
}