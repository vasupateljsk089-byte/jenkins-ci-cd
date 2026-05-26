
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = data.aws_vpc.default.id
}

module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = data.aws_subnets.default.ids[0]
  security_group_id = module.security_groups.jenkins_sg_id
  key_name          = var.key_name
  public_key_path   = var.public_key_path
  user_data         = file("${path.module}/userdata/install.sh")
}

module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  subnet_ids   = data.aws_subnets.default.ids
  vpc_id       = data.aws_vpc.default.id
  key_name     = var.key_name
}
