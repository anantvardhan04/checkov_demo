variable "account_environment" {}
variable "environment" {}
variable "aws_metadata_ip" {}
variable "aws_region" {}
variable "bastion_host_sg" {}
variable "cd_sg" {}
variable "int_alb_listener_443_arn" {}
variable "int_alb_listener_80_arn" {}
variable "int_alb_dns_name" {}
variable "int_alb_sg" {}
variable "int_alb_zone_id" {}
variable "packer_sg" {}
variable "magento_team_sg_1" {}
variable "magento_team_sg_2" {}
variable "magento_team_sg_3" {}
variable "payment_sg" {}
variable "vf_region" {}
variable "sns_notifications_topic" {}
variable "route53_environment" {}
variable "magento_environment" {}

# Network
variable "network_config" {
  default = {}
}

# Module variables
variable "brand_config" {
  type = map(string)
}

variable "tag_manager" {
  type = "map"
  default = {
    Application = "Magento",
    BusinessOwnerEmail = "DEEPAK_LAKSHMANAN1@VFC.COM",
    CostCenter = "118204800",
    TechOwnerEmail = "DevOps_EMEA@vfc.com"
  }
}

