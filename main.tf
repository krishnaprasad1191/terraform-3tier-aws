module "VPC" {
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
  pvtsub3 = {cidr= var.Pvtsub03_cidr, az= var.availability_zones["AZ_01"]}
  pvtsub4 = {cidr= var.Pvtsub04_cidr, az= var.availability_zones["AZ_02"]}
}
}

module "Web_Tier" {
  source = "./module/Web"
  vpc_id = module.VPC.vpc_id
  
  public_subnet1_id = module.VPC.Pubsub01_id
  public_subnet2_id = module.VPC.Pubsub02_id

  AZ1 = var.availability_zones["AZ_01"]
  AZ2 = var.availability_zones["AZ_02"]
  AZ3 = var.availability_zones["AZ_03"]

  LT_name = "Web_LT"
  instance_type = "t3.micro"
  depends_on = [ module.VPC ]
}

module "App_Tier" {
  source = "./module/App"

  Web_Secgrp_id = module.Web_Tier.Web_SG_id
  vpc_id = module.VPC.vpc_id

  private_subnet1_id = module.VPC.Pvtsub01_id
  private_subnet2_id = module.VPC.Pvtsub02_id

  AZ1 = var.availability_zones["AZ_01"]
  AZ2 = var.availability_zones["AZ_02"]
  AZ3 = var.availability_zones["AZ_03"]

  AMI = module.Web_Tier.ami_id
  key_name = module.Web_Tier.Keypair_name
  LT_name = "APP_Tier_LT"
  instance_type = "c7i-flex.large"
  depends_on = [ module.Web_Tier ]
}

module "DB_Tier" {
  source = "./module/DB"
  app_sg_id = module.App_Tier.App_SG_ID
  vpc_id = module.VPC.vpc_id
  Pvtsubnet3_id = module.VPC.Pvtsub03_id
  Pvtsubnet4_id = module.VPC.Pvtsub04_id
}