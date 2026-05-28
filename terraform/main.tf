module "vpc" {
  source = "./modules/vpc"

  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"
  # jenkins server configuration
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnets[0] 
  security_group_id = module.security_groups.jenkins_sg_id
  key_name          = var.key_name
  public_key_path   = var.public_key_path
  user_data         = file("${path.module}/userdata/install.sh")
}

module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
  key_name     = var.key_name
}
