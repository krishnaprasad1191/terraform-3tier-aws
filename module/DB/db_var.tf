variable "app_sg_id" { type = string }
variable "vpc_id" {type = string}

variable "Pvtsubnet3_id" { type = string }
variable "Pvtsubnet4_id" { type = string }
variable "db_username" {
    type = string
    default = "admin"
    sensitive = true
}
variable "db_password" { 
    type = string
    default = "Admin@123"
    sensitive = true
}

variable "engine_type" {
  type = string
  default = "mysql"
}
variable "identifier" {
  type = string
  default = "db-identifier"
}
variable "engine_version" {
  type = string
  default = "8.0"
}
variable "storage" {
  type = number
  default = 20
}

variable "instance_class" {
  type = string
  default = "db.t3.micro"
}