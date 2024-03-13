
module "vpc" {
  source              = "./modules/vpc"
  default_vpc_name    = local.default_vpc_name
  default_subnet_name = local.default_subnet_name
}

module "iam" {
  source                        = "./modules/iam"
  iam_policy_name               = local.iam_policy_name
  iam_role_name                 = local.iam_role_name
  iam_policy_attachment_name    = local.iam_policy_attachment_name
  jenkins_instance_profile_name = local.jenkins_instance_profile_name
}

module "ec2" {
  source                     = "./modules/ec2"
  vpc_id                     = module.vpc.default_vpc_id
  ec2_security_group_name    = local.ec2_security_group_name
  ec2_security_group_desc    = local.ec2_security_group_desc
  ec2_security_group_tag_val = local.ec2_security_group_tag_val

  ec2_security_group_http_proxy_desc     = local.ec2_security_group_http_proxy_desc
  ec2_security_group_http_proxy_port     = local.ec2_security_group_http_proxy_port
  ec2_security_group_http_proxy_protocol = local.ec2_security_group_http_proxy_protocol
  ec2_security_group_http_proxy_cidr     = local.ec2_security_group_http_proxy_cidr

  ec2_security_group_ssh_proxy_desc     = local.ec2_security_group_ssh_proxy_desc
  ec2_security_group_ssh_proxy_port     = local.ec2_security_group_ssh_proxy_port
  ec2_security_group_ssh_proxy_protocol = local.ec2_security_group_ssh_proxy_protocol
  ec2_security_group_ssh_proxy_cidr     = local.ec2_security_group_ssh_proxy_cidr

  ec2_security_group_egress_port      = local.ec2_security_group_egress_port
  ec2_security_group_egrress_protocol = local.ec2_security_group_egrress_protocol
  ec2_security_group_egress_cidr      = local.ec2_security_group_egress_cidr

  default_az_id                 = module.vpc.default_az_id
  jenkins_instance_profile_name = module.iam.jenkins_instance_profile_name
  ec2_keypair_name              = local.ec2_keypair_name
  ec2_instanct_tag_val          = local.ec2_instanct_tag_val
}

module "ssh_connection" {
  source                          = "./modules/ssh_connection"
  local_file_name                 = module.ec2.local_file_name
  public_ip                       = module.ec2.public_ip
  ssh_connection_user             = local.ssh_connection_user
  ssh_connection_file_source      = local.ssh_connection_file_source
  ssh_connection_file_destination = local.ssh_connection_file_destination
}