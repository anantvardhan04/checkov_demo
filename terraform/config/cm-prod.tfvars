# Global
account_environment = "cm-prod" # pc-poc, cm-dev, cm-qa, cm-prod
environment = "PROD" # POC, DEV, QA, PROD
vf_region = "emea"
magento_environment = "prod"

# Terraform state
bucket = "vf-cm-prod-infrastructure-code"
key = "terraform-state/infrastructure/magento/cm-prod/terraform.tfstate"
region = "eu-west-1"

# Network
network_config = {
  availability_zones = [
    "eu-west-1a",
    "eu-west-1b"]
  vpc_id = "vpc-0a0ecb40b9d377a44"
  public_subnets = [
    "subnet-038ffc7565cad51ab",
    "subnet-035fda4940f8ea333"]
  ec2_private_subnets = [
    "subnet-0a4850a98ae25eca0",
    "subnet-0867df2a3bde1b904"]
  private_subnets = [
    "subnet-0a4850a98ae25eca0",
    "subnet-0867df2a3bde1b904",
    "subnet-09bf1db532a626905"]
  private_subnet_lb_cidr = "172.23.134.0/26"
  internal_alb_public_hosted_zone = "Z23734FJEUOV77"
  internal_SSL_certificate_arn = "arn:aws:acm:eu-west-1:453318629493:certificate/170804d3-8595-4f1f-b66d-4a2c41e3d6f6"
  is_internal_alb_registered_on_route53 = true
}

# Infrastracture
bastion_host_sg = "sg-0d62fdfdb8bd4398a"
cd_sg = ["sg-05141c5b81a1bf28f"]
sns_notifications_emails=["EMEA_ECOM_MAGENTO_SUPP@vfc.com"]

# Monitoring instance
monitoring_instance_type = "t3.nano"
monitoring_instance_ssh_key = "vf-cm-prod-emea-magento"
datadog_instance_ami_id = "ami-063d4ab14480ac177"

# Brand dependent
dickies_config = {
  brand_full_name = "dickies"
  brand_short_lc_name = "dk"
  brand_short_uc_name = "DK"
  create_bucket_images = false
  create_bucket_prices = true
  create_bucket_stock = true
  external_load_balancer_domain = "www.dickieslife.com"
  external_load_balancer_alt_domain = "dickieslife.com"
  internal_load_balancer_domain = "dickieslife.mage.cm-prod-emea.vfc-int.com"
  cache_type = "cache.m5.xlarge"
  elastic_instance_type = "r5.large.elasticsearch"
  elastic_number_instances = 2
  elastic_volume_size = 25
  elastic_subnet = "subnet-0867df2a3bde1b904,subnet-09bf1db532a626905"
  is_elastic_instances_created = true
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:453318629493:certificate/1a1b4597-c57c-458a-a9d4-57aa6da405b3"
  rds_multi_az = true
  rds_storage_encrypted = true
  rds_cluster_instance_number = 2
  rds_cluster_instance_class = "db.r5.2xlarge"
  rds_cluster_instance_snapshot = ""
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
  external_load_balancer_domain = "www.kipling.com"
  external_load_balancer_alt_domain = "prod.kipling.com,kipling.com,kipling.co.uk,kipling.de,kipling.it,kipling.be,kipling.nl,kipling.es,kipling.at,kipling.ie,kipling.pt,www.kipling.co.uk,www.kipling.de,www.kipling.it,www.kipling.be,www.kipling.nl,www.kipling.es,www.kipling.at,www.kipling.ie,www.kipling.pt,webservice.api.kipling.com"
  internal_load_balancer_domain = "kipling.mage.cm-prod-emea.vfc-int.com"
  cache_type = "cache.m5.xlarge"
  elastic_instance_type = "r5.large.elasticsearch"
  elastic_number_instances = 2
  elastic_volume_size = 25
  elastic_subnet = "subnet-0867df2a3bde1b904,subnet-09bf1db532a626905"
  is_elastic_instances_created = true
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:453318629493:certificate/72769b06-e8a1-4cea-aeb4-c18ee7a8fdc2"
  rds_multi_az = true
  rds_storage_encrypted = true
  rds_cluster_instance_number = 2
  rds_cluster_instance_class = "db.r5.2xlarge"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:453318629493:snapshot:prod-kp-migrate-to-aurora"
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
  external_load_balancer_domain = "www.eastpak.com"
  external_load_balancer_alt_domain = "prod.eastpak.com,eastpak.at,eastpak.be,eastpak.co.uk,eastpak.com,eastpak.de,eastpak.es,eastpak.ie,eastpak.it,eastpak.nl,eastpak.pt,webservice.api.eastpak.com,www.eastpak.at,www.eastpak.be,www.eastpak.co.uk,www.eastpak.de,www.eastpak.es,www.eastpak.ie,www.eastpak.it,www.eastpak.nl,www.eastpak.pt"
  internal_load_balancer_domain = "eastpak.mage.cm-prod-emea.vfc-int.com"
  cache_type = "cache.m5.xlarge"
  elastic_instance_type = "r5.large.elasticsearch"
  elastic_number_instances = 2
  elastic_volume_size = 25
  elastic_subnet = "subnet-0867df2a3bde1b904,subnet-09bf1db532a626905"
  is_elastic_instances_created = true
  external_SSL_certificate_arn = "arn:aws:acm:eu-west-1:453318629493:certificate/4582945a-4307-4fa3-b329-0e1d4ab6f568"
  rds_multi_az = true
  rds_storage_encrypted = true
  rds_cluster_instance_number = 2
  rds_cluster_instance_class = "db.r5.2xlarge"
  rds_cluster_instance_snapshot = "arn:aws:rds:eu-west-1:453318629493:snapshot:prod-ep-migrate-to-aurora"
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
