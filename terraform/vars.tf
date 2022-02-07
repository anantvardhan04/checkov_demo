variable "account_environment" {}
variable "environment" {}
variable "vf_region" {}
variable "region" {}

variable "aws_metadata_ip" {
  default = "169.254.169.254"
}

# BH
variable "bastion_host_sg" {}

# CD
variable "cd_sg" {}

# Network
variable "network_config" {}

#Monitoring
variable "datadog_instance_ami_id" {}
variable "monitoring_instance_type" {}
variable "monitoring_instance_ssh_key" {}
variable "magento_environment" {}
variable "datadog_aws_integration_external_id" {}

# Brand dependent
variable "dickies_config" {}
variable "kipling_config" {}
variable "eastpak_config" {}
variable "whitelabel_config" {}

variable "bucket" {}

variable "tag_manager" {
  type = "map"
  default = {
    Application = "Magento",
    BusinessOwnerEmail = "DEEPAK_LAKSHMANAN1@VFC.COM",
    CostCenter = "118204800",
    TechOwnerEmail = "DevOps_EMEA@vfc.com"
  }

}

variable "route53_environment" {
  default = ""
}

# Notifications
variable "sns_notifications_emails" {}