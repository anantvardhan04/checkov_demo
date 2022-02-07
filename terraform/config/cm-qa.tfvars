# Global
account_environment = "cm-qa" # pc-poc, cm-dev, cm-qa, cm-prod
environment = "QA" # POC, DEV, QA, PROD
vf_region = "emea"
magento_environment = "uat"

# Terraform state
bucket = "vf-cm-qa-infrastructure-code"
key = "terraform-state/infrastructure/magento/cm-qa/terraform.tfstate"
region = "eu-west-1"

# Network
network_config = {
  availability_zones = [
    "eu-west-1a",
    "eu-west-1b"]
  vpc_id = "vpc-009c37b8ef375374b"
  public_subnets = [
    "subnet-0f9da854f5ce75a7c",
    "subnet-0154504e35e2cbe76"]
  ec2_private_subnets = [
    "subnet-0e4d7ccfc21c29e27",
    "subnet-0410b42e0eea95aee"]
  private_subnets = [
    "subnet-0e4d7ccfc21c29e27",
    "subnet-0410b42e0eea95aee"]
  private_subnet_lb_cidr = "172.23.132.0/26"
  internal_alb_public_hosted_zone = "Z1KNAVJPPKUNVV"
  internal_SSL_certificate_arn = "arn:aws:acm:eu-west-1:120425330901:certificate/a6591f25-2035-4adb-a625-d0de01671472"
  is_internal_alb_registered_on_route53 = true
}

# Infrastracture
bastion_host_sg = "sg-044327bdc01177bc3"
cd_sg = ["sg-080589e93f2878de1"]
sns_notifications_emails=["adrian_sullivan@vfc.com", "vitalii_grygor@vfc.com", "bohdan.chaplyk@vfc.com"]

# Monitoring instance
monitoring_instance_type = "t3.nano"
monitoring_instance_ssh_key = "vf-no-prod-emea"
datadog_instance_ami_id = "ami-063d4ab14480ac177"

# Brand dependent
dickies_config = {
  brand_full_name = "dickies"
  brand_short_lc_name = "dk"
  brand_short_uc_name = "DK"
  create_bucket_images = false
  create_bucket_prices = true
  create_bucket_stock = true
  external_load_balancer_domain = "tst.dickieslife.com"
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = "dickieslife.mage.cm-qa-emea.vfc-int.com"
  cache_type = "cache.t3.medium"
  elastic_instance_type = "t2.medium.elasticsearch"
  elastic_number_instances = 2
  elastic_volume_size = 25
  elastic_subnet = "subnet-0e4d7ccfc21c29e27"
  is_elastic_instances_created = true
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:120425330901:certificate/23727d51-e43a-4eff-a1ab-340ef046657b"
  rds_multi_az = true
  rds_storage_encrypted = true
  rds_cluster_instance_number = 2
  rds_cluster_instance_class = "db.t3.medium"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:120425330901:snapshot:uat-dk-migrate-to-aurora"
  is_enabled = true
  is_opened_to_internet = true
}

kipling_config = {
  brand_full_name = "kipling"
  brand_short_lc_name = "kp"
  brand_short_uc_name = "KP"
  create_bucket_images = false
  create_bucket_prices = true
  create_bucket_stock = true
  external_load_balancer_domain = "tst-m2.kipling.com"
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = "kipling.mage.cm-qa-emea.vfc-int.com"
  cache_type = "cache.t3.medium"
  elastic_instance_type = "t2.medium.elasticsearch"
  elastic_number_instances = 2
  elastic_volume_size = 25
  elastic_subnet = "subnet-0e4d7ccfc21c29e27"
  is_elastic_instances_created = true
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:120425330901:certificate/a33b06b8-53af-4edb-84ff-b3ead179728f"
  rds_multi_az = true
  rds_storage_encrypted = true
  rds_cluster_instance_number = 2
  rds_cluster_instance_class = "db.t3.medium"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:120425330901:snapshot:uat-kp-migrate-to-aurora"
  is_enabled = true
  is_opened_to_internet = true
}

eastpak_config = {
  brand_full_name = "eastpak"
  brand_short_lc_name = "ep"
  brand_short_uc_name = "EP"
  create_bucket_images = false
  create_bucket_prices = true
  create_bucket_stock = true
  external_load_balancer_domain = "tst-m2.eastpak.com"
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = "eastpak.mage.cm-qa-emea.vfc-int.com"
  cache_type = "cache.t3.medium"
  elastic_instance_type = "t2.medium.elasticsearch"
  elastic_number_instances = 2
  elastic_volume_size = 25
  elastic_subnet = "subnet-0e4d7ccfc21c29e27"
  is_elastic_instances_created = true
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:120425330901:certificate/3fc0377c-4757-4a30-8f7d-2ae0d85e3323"
  rds_multi_az = true
  rds_storage_encrypted = true
  rds_cluster_instance_number = 2
  rds_cluster_instance_class = "db.t3.medium"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:120425330901:snapshot:uat-ep-migrate-to-aurora"
  is_enabled = true
  is_opened_to_internet = true
}

whitelabel_config = {
  brand_full_name = ""
  brand_short_lc_name = ""
  brand_short_uc_name = ""
  create_bucket_images = false
  create_bucket_prices = false
  create_bucket_stock = false
  external_load_balancer_domain = ""
  external_load_balancer_alt_domain = ""
  internal_load_balancer_domain = ""
  cache_type = ""
  elastic_instance_type = ""
  elastic_number_instances = 0
  elastic_volume_size = 25
  elastic_subnet = ""
  is_elastic_instances_created = false
  external_SSL_certificate_arn = ""
  rds_multi_az = false
  rds_storage_encrypted = false
  rds_cluster_instance_number = 1
  rds_cluster_instance_class = "db.t3.medium"
  is_enabled = false
  is_opened_to_internet = false
}
