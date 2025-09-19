provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"

  name     = "vault-vpc"
  vpc_cidr = "10.0.0.0/16"

  public_subnets = [
    { cidr = "10.0.1.0/24", az = "us-east-1a" },
    { cidr = "10.0.2.0/24", az = "us-east-1b" }
  ]

  tags = {
    Environment = "dev"
    Project     = "Vault"
  }
}

module "efs" {
  source              = "./modules/efs"
  name                = "vault-directory"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
  allowed_cidr_blocks = ["10.0.0.0/16"]
}



module "dynamo-vault" {
  source = "./modules/database"
  name   = "vault-data"
}


module "ecs_cluster" {
  source                = "./modules/ecs-cluster"
  environment_name      = "test"
  vpc_id                = module.vpc.vpc_id
  namespace_name        = "Vault"
  log_retention_in_days = 7
}

module "kms" {
  source = "./modules/kms"
}

module "ecs_task_role" {
  source             = "./modules/ecs-task-role"
  name               = "ecs-task-role"
  dynamodb_table_arn = module.dynamo-vault.dynamodb.arn
  kms_key_arn        = module.kms.encryption.arn
}

module "vault-service" {
  source = "./modules/service"

  environment_name                               = "test"
  service_name                                   = "Vault"
  cluster_arn                                    = module.ecs_cluster.ecs_cluster_arn
  vpc_id                                         = module.vpc.vpc_id
  subnet_ids                                     = module.vpc.public_subnet_ids
  container_image                                = "hashicorp/vault:1.14.3"
  cloudwatch_logs_group_id                       = module.ecs_cluster.log_group_id
  container_port                                 = 8200
  to_port                                        = 8200
  from_port                                      = 8200
  healthcheck_path                               = ""
  additional_task_role_iam_policy_arns           = [module.ecs_task_role.task_role_policy]
  additional_task_execution_role_iam_policy_arns = [module.ecs_task_role.task_role_policy]
  service_discovery_namespace_arn                = module.ecs_cluster.service_discovery_namespace_arn
  access_point_id                                = module.efs.access_point_id
  file_system_id                                 = module.efs.file_system_id
  kms_key_id                                     = module.kms.encryption.id
  alb_target_group_arn=module.vault_alb.target_group_arn
  depends_on                                     = [module.ecs_task_role, module.kms, module.efs, module.ecs_cluster, module.vpc,module.vault_alb]
  service_connect_enabled                        = false
}

module "acm_vault" {
  source      = "./modules/acm"
  domain_name = "vault.djordje-test-app.click"
  subject_alternative_names = ["djordje-test-app.click"]
  zone_name   = "djordje-test-app.click"
}

module "vault_alb" {
  source          = "./modules/alb"
  name            = "vault-alb"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnet_ids
  target_port     = 8080
  target_protocol = "HTTP"
  certificate_arn = module.acm_vault.certificate_arn
}

module "domain" {
  source = "./modules/domain"
  alb_dns_name = module.vault_alb.alb_dns_name
  alb_zone_id = module.vault_alb.alb_zone_id
  depends_on = [ module.vault_alb]
}







