output "Packer-sg" {
  value = aws_security_group.magento-packer.id
}

output "Web-ALB-internal-load-balancer-full-name" {
  value = aws_alb.magento-int-alb.arn_suffix
}

output "Kipling-EFS-file-system" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.EFS-file-system : "none"
}
output "Kipling-EFS-client-security-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.EFS-client-security-group : "none"
}
output "Kipling-ES-client-security-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.ES-client-security-group : "none"
}
output "Kipling-ES-endpoint" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.ES-endpoint : "none"
}
output "Kipling-EC-client-security-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.EC-client-security-group : "none"
}
output "Kipling-EC-endpoint" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.EC-endpoint : "none"
}
output "Kipling-RDS-endpoint" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.RDS-endpoint : "none"
}
output "Kipling-RDS-client-security-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.RDS-client-security-group : "none"
}
output "Kipling-RDS-pwd" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.RDS-pwd : "none"
}
output "Kipling-Web-security-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.Web-security-group : "none"
}
output "Kipling-Web-ALB-external-load-balancer-full-name" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.Web-ALB-external-load-balancer-full-name : "none"
}
output "Kipling-Web-ALB-external-443-target-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.Web-ALB-external-443-target-group : "none"
}
output "Kipling-Web-ALB-external-443-target-group-full-name" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.Web-ALB-external-443-target-group-full-name : "none"
}
output "Kipling-Web-ALB-internal-443-target-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.Web-ALB-internal-443-target-group : "none"
}
output "Kipling-Web-ALB-internal-443-target-group-full-name" {
  value = var.kipling_config["is_enabled"] ? module.magento-kipling.Web-ALB-internal-443-target-group-full-name : "none"
}


output "Eastpak-EFS-file-system" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.EFS-file-system : "none"
}
output "Eastpak-EFS-client-security-group" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.EFS-client-security-group : "none"
}
output "Eastpak-ES-client-security-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-eastpak.ES-client-security-group : "none"
}
output "Eastpak-ES-endpoint" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.ES-endpoint : "none"
}
output "Eastpak-EC-client-security-group" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.EC-client-security-group : "none"
}
output "Eastpak-EC-endpoint" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.EC-endpoint : "none"
}
output "Eastpak-RDS-endpoint" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.RDS-endpoint : "none"
}
output "Eastpak-RDS-client-security-group" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.RDS-client-security-group : "none"
}
output "Eastpak-RDS-pwd" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.RDS-pwd : "none"
}
output "Eastpak-Web-security-group" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.Web-security-group : "none"
}
output "Eastpak-Web-ALB-external-load-balancer-full-name" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.Web-ALB-external-load-balancer-full-name : "none"
}
output "Eastpak-Web-ALB-external-443-target-group" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.Web-ALB-external-443-target-group : "none"
}
output "Eastpak-Web-ALB-external-443-target-group-full-name" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.Web-ALB-external-443-target-group-full-name : "none"
}
output "Eastpak-Web-ALB-internal-443-target-group" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.Web-ALB-internal-443-target-group : "none"
}
output "Eastpak-Web-ALB-internal-443-target-group-full-name" {
  value = var.eastpak_config["is_enabled"] ? module.magento-eastpak.Web-ALB-internal-443-target-group-full-name : "none"
}


output "Dickies-EFS-file-system" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.EFS-file-system : "none"
}
output "Dickies-EFS-client-security-group" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.EFS-client-security-group : "none"
}
output "Dickies-ES-client-security-group" {
  value = var.kipling_config["is_enabled"] ? module.magento-dickies.ES-client-security-group : "none"
}
output "Dickies-ES-endpoint" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.ES-endpoint : "none"
}
output "Dickies-EC-client-security-group" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.EC-client-security-group : "none"
}
output "Dickies-EC-endpoint" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.EC-endpoint : "none"
}
output "Dickies-RDS-endpoint" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.RDS-endpoint : "none"
}
output "Dickies-RDS-client-security-group" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.RDS-client-security-group : "none"
}
output "Dickies-RDS-pwd" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.RDS-pwd : "none"
}
output "Dickies-Web-security-group" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.Web-security-group : "none"
}
output "Dickies-Web-ALB-external-load-balancer-full-name" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.Web-ALB-external-load-balancer-full-name : "none"
}
output "Dickies-Web-ALB-external-443-target-group" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.Web-ALB-external-443-target-group : "none"
}
output "Dickies-Web-ALB-external-443-target-group-full-name" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.Web-ALB-external-443-target-group-full-name : "none"
}
output "Dickies-Web-ALB-internal-443-target-group" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.Web-ALB-internal-443-target-group : "none"
}
output "Dickies-Web-ALB-internal-443-target-group-full-name" {
  value = var.dickies_config["is_enabled"] ? module.magento-dickies.Web-ALB-internal-443-target-group-full-name : "none"
}

output "Alarms-SNS-topic" {
  value = aws_sns_topic.alarms-sns-topic.arn
}