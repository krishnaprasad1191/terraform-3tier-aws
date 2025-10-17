module "VPC_Module" {
source = "./module/VPC"
Name = var.vpc_name
cidr_block = var.vpc_cidr_block
Pub_Subnet01_cidr = var.Pubsub01_cidr
AZ1 = var.availability_zones["AZ_01"]

}