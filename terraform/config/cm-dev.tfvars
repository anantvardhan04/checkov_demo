# Global
account_environment = "cm-dev" # pc-poc, cm-dev, cm-qa, cm-prod
environment = "DEV" # POC, DEV, QA, PROD
vf_region = "emea"
magento_environment = "dev"

# Terraform state
bucket = "vf-cm-dev-infrastructure-code"
key = "terraform-state/infrastructure/magento/cm-dev/terraform.tfstate"
region = "eu-west-1"

# Network
network_config = {
  availability_zones = [
    "eu-west-1a",
    "eu-west-1b"]
  vpc_id = "vpc-045d7f140caa2ea88"
  public_subnets = [
    "subnet-0a699a42528e10bfb",
    "subnet-0e12b91ea710b16bc"]
  ec2_private_subnets = [
    "subnet-063d02969858b6ee3",
    "subnet-0cb26c3d6b09cbe44"]
  private_subnets = [
    "subnet-063d02969858b6ee3",
    "subnet-0cb26c3d6b09cbe44"]
  private_subnet_lb_cidr = "172.23.130.0/26"
  internal_alb_public_hosted_zone = "Z33S34NGX10227"
  internal_SSL_certificate_arn = "arn:aws:acm:eu-west-1:018795316058:certificate/3bb7a090-5108-432d-982c-93ab01aa5e08"
  is_internal_alb_registered_on_route53 = true
}

# Infrastracture
bastion_host_sg = "sg-0cad739689b806385"
cd_sg = ["sg-0c20f329449328c92"]
sns_notifications_emails=["adrian_sullivan@vfc.com"]

# Monitoring instance
monitoring_instance_type = "t3.nano"
monitoring_instance_ssh_key = "vf-no-prod-emea"
datadog_instance_ami_id = "ami-063d4ab14480ac177"

# Brand dependent
dickies_config = {
  brand_full_name = "dickies"
  brand_short_lc_name = "dk"
  brand_short_uc_name = "DK"
  create_bucket_images = true
  create_bucket_prices = true
  create_bucket_stock = true
  external_load_balancer_domain = "dev.dickieslife.com"
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = "dickieslife-dev.mage.cm-dev-emea.vfc-int.com"
  cache_type = "cache.t3.micro"
  elastic_instance_type = "t2.small.elasticsearch"
  elastic_number_instances = 0
  elastic_volume_size = 20
  elastic_subnet = "subnet-063d02969858b6ee3"
  is_elastic_instances_created = false
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:018795316058:certificate/900801a3-af6d-450c-b879-91d670683251"
  rds_multi_az = false
  rds_storage_encrypted = false
  rds_cluster_instance_number = 1
  rds_cluster_instance_class = "db.t3.medium"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:018795316058:snapshot:dev-dk-migrate-to-aurora"
  is_enabled = true
  is_opened_to_internet = false
}

kipling_config = {
  brand_full_name = "kipling"
  brand_short_lc_name = "kp"
  brand_short_uc_name = "KP"
  create_bucket_images = true
  create_bucket_prices = true
  create_bucket_stock = true
  external_load_balancer_domain = "dev-m2.kipling.com"
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = "kipling-dev.mage.cm-dev-emea.vfc-int.com"
  cache_type = "cache.t3.micro"
  elastic_instance_type = "t2.small.elasticsearch"
  elastic_number_instances = 0
  elastic_volume_size = 20
  elastic_subnet = "subnet-063d02969858b6ee3"
  is_elastic_instances_created = false
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:018795316058:certificate/8d83a432-e10c-40a1-acc0-5722e356e3f6"
  rds_multi_az = false
  rds_storage_encrypted = false
  rds_cluster_instance_number = 1
  rds_cluster_instance_class = "db.t3.medium"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:018795316058:snapshot:dev-kp-migrate-to-aurora"
  is_enabled = true
  is_opened_to_internet = false
}

eastpak_config = {
  brand_full_name = "eastpak"
  brand_short_lc_name = "ep"
  brand_short_uc_name = "EP"
  create_bucket_images = true
  create_bucket_prices = true
  create_bucket_stock = true
  external_load_balancer_domain = "dev-m2.eastpak.com"
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = "eastpak-dev.mage.cm-dev-emea.vfc-int.com"
  cache_type = "cache.t3.micro"
  elastic_instance_type = "t2.small.elasticsearch"
  elastic_number_instances = 0
  elastic_volume_size = 20
  elastic_subnet = "subnet-063d02969858b6ee3"
  is_elastic_instances_created = false
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:018795316058:certificate/b210fc01-60e0-42df-a296-98e7460a7d54"
  rds_multi_az = false
  rds_storage_encrypted = false
  rds_cluster_instance_number = 1
  rds_cluster_instance_class = "db.t3.medium"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:018795316058:snapshot:dev-ep-migrate-to-aurora"
  is_enabled = true
  is_opened_to_internet = false
}

whitelabel_config = {
  brand_full_name = "whitelabel"
  brand_short_lc_name = "vf"
  brand_short_uc_name = "VF"
  create_bucket_images = false
  create_bucket_prices = false
  create_bucket_stock = false
  external_load_balancer_domain = "vf-cm-dev-emea.ecg.magento.com"
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = "whitelabel.mage.cm-dev-emea.vfc-int.com"
  cache_type = "cache.t3.micro"
  elastic_instance_type = "t2.small.elasticsearch"
  elastic_number_instances = 0
  elastic_volume_size = 20
  elastic_subnet = "subnet-063d02969858b6ee3"
  is_elastic_instances_created = false
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:018795316058:certificate/ce748bca-0fb3-41fc-97e4-97f782f202de"
  rds_multi_az = false
  rds_storage_encrypted = false
  rds_cluster_instance_number = 1
  rds_cluster_instance_class = "db.t3.small"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:018795316058:snapshot:dev-migration-to-aurora"
  is_enabled = true
  is_opened_to_internet = false
}

route53_environment = "dev"
