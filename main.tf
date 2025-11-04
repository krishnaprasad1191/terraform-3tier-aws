module "VPC_Module" {
source = "./module/VPC"
Vpc_Name = var.vpc_name
vpc_cidr_block = var.vpc_cidr_block


Public_Subnets = { 
  pubsub1 = {cidr= var.Pubsub01_cidr, az= var.availability_zones["AZ_01"]}
  pubsub2 = {cidr = var.Pubsub02_cidr,az=var.availability_zones["AZ_02"]}
}

Private_Subnets = { 
  pvtsub1 = {cidr= var.Pvtsub01_cidr, az= var.availability_zones["AZ_01"]}
  pvtsub2 = {cidr = var.Pvtsub02_cidr,az=var.availability_zones["AZ_02"]}
}
}

module "Web_Tier" {
  source = "./module/Web"
  vpc_id = module.VPC_Module.vpc_id
}